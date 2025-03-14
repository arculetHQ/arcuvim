local telescope = require "telescope"
local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local make_entry = require "telescope.make_entry"
local conf = require "telescope.config".values
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"
local sorters = require "telescope.sorters"

local M = {}

--------------------------------------------------
-- Configuration
--------------------------------------------------

-- Default configuration
local default_config = {
  -- Key mappings configuration
  mappings = {
    multigrep = "<leader>fg",      -- Basic multi-grep
    project_grep = "<leader>fp",   -- Project-wide multi-grep
    hidden_grep = "<leader>fh",    -- Search including hidden files
    buffer_grep = "<leader>fb",    -- Search in open buffers
  },
  
  -- Default options for live_multigrep
  default_opts = {
    debounce = 100,                -- Debounce time in ms
    hidden = false,                -- Search hidden files by default
    follow = false,                -- Follow symlinks
    rg_args = {},                  -- Additional ripgrep arguments
    use_default_sorter = false,    -- Use empty sorter by default
  },
  
  -- Prompt titles
  prompt_titles = {
    default = "Multi Grep",
    project = "Project-wide Multi Grep",
    hidden = "Multi Grep (including hidden)",
    buffer = "Multi Grep (within buffers)",
  },
  
  -- Input mode settings
  input = {
    separator = " | ",             -- Separator between search pattern and file pattern
    help_message = "Search pattern | File pattern (separate with ` | `)",
  },
  
  -- Telescope extension registration
  register_extension = false,
}

--------------------------------------------------
-- Utility Functions
--------------------------------------------------

-- Ensure ripgrep is available in the system
local function ensure_rg_available()
  if vim.fn.executable("rg") == 0 then
    vim.notify("ripgrep (rg) is required for multi-grep but not found!", vim.log.levels.ERROR)
    return false
  end
  return true
end

-- Get the current working directory with compatibility
local function get_cwd()
  -- Support both older vim.loop.cwd() and newer vim.uv.cwd()
  return (vim.uv and vim.uv.cwd or vim.loop.cwd)()
end

-- Parse a prompt string into search term and file pattern
---@param prompt string The user's input prompt
---@param separator string Separator between search term and file pattern
---@return string? search_term Search pattern or nil
---@return string? file_pattern File pattern or nil
local function parse_prompt(prompt, separator)
  if not prompt or prompt == "" then
    return nil, nil
  end
  
  local pieces = vim.split(prompt, separator)
  
  local search_term = pieces[1] and pieces[1]:gsub("^%s*(.-)%s*$", "%1") or nil
  local file_pattern = pieces[2] and pieces[2]:gsub("^%s*(.-)%s*$", "%1") or nil
  
  -- Return nil if empty strings after trimming
  if search_term and search_term == "" then search_term = nil end
  if file_pattern and file_pattern == "" then file_pattern = nil end
  
  return search_term, file_pattern
end

-- Generate ripgrep command based on prompt and options
---@param prompt string The user's input prompt
---@param opts table Options including custom ripgrep arguments
---@return table|nil Command and arguments for the job
local function generate_multigrep_command(prompt, opts)
  if not prompt or prompt == "" then
    return nil
  end

  local search_term, file_pattern = parse_prompt(prompt, opts.separator or default_config.input.separator)
  
  if not search_term then
    return nil
  end

  local args = { "rg" }

  -- Search pattern
  vim.list_extend(args, { "-e", search_term })

  -- File pattern filter
  if file_pattern then
    vim.list_extend(args, { "-g", file_pattern })
  end

  -- Add default ripgrep arguments
  vim.list_extend(args, {
    "--color=never",
    "--no-heading",
    "--with-filename",
    "--line-number",
    "--column",
    "--smart-case"
  })
  
  -- Add hidden files flag
  if opts.hidden then
    vim.list_extend(args, { "--hidden" })
  end
  
  -- Add follow symlinks flag
  if opts.follow then
    vim.list_extend(args, { "--follow" })
  end
  
  -- Add any custom arguments from options
  if opts.rg_args and #opts.rg_args > 0 then
    vim.list_extend(args, opts.rg_args)
  end
  
  return args
end

-- Create a finder for buffer-based search
---@param prompt string User input prompt.
---@param opts table Options.
---@return table|nil List of results for the finder.
local function buffer_multigrep_finder(prompt, opts)
  local search_term, file_pattern = parse_prompt(prompt, opts.separator or default_config.input.separator)
  
  if not search_term or search_term == "" then
    return {}
  end

  -- Escape Lua pattern special characters
  local escaped_search = vim.pesc(search_term)
  local pattern = opts.case_insensitive and escaped_search:lower() or escaped_search

  -- Get valid buffers
  local buffers = {}
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(buf) and 
       vim.api.nvim_buf_is_loaded(buf) and 
       vim.api.nvim_buf_get_option(buf, "buflisted") then
      
      local filename = vim.api.nvim_buf_get_name(buf)
      if filename == "" then filename = "[No Name]" end
      
      -- Convert file pattern to Lua pattern
      if file_pattern then
        file_pattern = file_pattern:gsub("%*", ".*"):gsub("%?", ".")
        if not filename:match(file_pattern) then
          goto continue
        end
      end

      -- Get buffer content safely
      local ok, lines = pcall(vim.api.nvim_buf_get_lines, buf, 0, -1, false)
      if not ok then goto continue end

      table.insert(buffers, {
        bufnr = buf,
        filename = filename,
        lines = lines
      })
      
      ::continue::
    end
  end

  -- Search in buffers
  local results = {}
  for _, buffer in ipairs(buffers) do
    for lnum, line in ipairs(buffer.lines) do
      local processed_line = opts.case_insensitive and line:lower() or line
      local start_idx, end_idx = processed_line:find(pattern)
      
      if start_idx then
        -- Calculate UTF-8 aware column position
        local col = vim.str_utfindex(line, start_idx - 1) + 1
        table.insert(results, {
          bufnr = buffer.bufnr,
          filename = buffer.filename,
          lnum = lnum,
          col = col,
          text = line
        })
      end
    end
  end

  return results
end


--------------------------------------------------
-- Main Functionality
--------------------------------------------------

---@param opts table Configuration options
function M.live_multigrep(opts)
  if not ensure_rg_available() then return end

  opts = vim.tbl_deep_extend("force", {}, M.config.default_opts, opts or {})
  
  -- Handle cwd
  opts.cwd = opts.cwd and vim.fn.expand(opts.cwd) or get_cwd()
  opts.entry_maker = opts.entry_maker or make_entry.gen_from_vimgrep(opts)
  
  -- Create dynamic finder based on prompt
  local finder = finders.new_async_job {
    command_generator = function(prompt)
      return generate_multigrep_command(prompt, opts)
    end,
    entry_maker = opts.entry_maker,
    cwd = opts.cwd,
  }

  -- Create and configure the picker
  local picker = pickers.new(opts, {
    prompt_title = opts.prompt_title or M.config.prompt_titles.default,
    finder = finder,
    previewer = conf.grep_previewer(opts),
    sorter = opts.use_default_sorter and conf.generic_sorter(opts) or sorters.empty(),
    debounce = opts.debounce,
    attach_mappings = function(prompt_bufnr, map)
      -- Toggle preview with Ctrl-P
      map("i", "<C-p>", function()
        actions.toggle_preview(prompt_bufnr)
      end)
      
      -- Save search to quickfix list with Ctrl-Q
      map("i", "<C-q>", function()
        actions.send_to_qflist(prompt_bufnr)
        actions.open_qflist(prompt_bufnr)
      end)
      
      -- Show help text with Ctrl-H
      map("i", "<C-h>", function()
        local separator = opts.separator or M.config.input.separator
        local separator_desc = separator == "  " and "double spaces" or "'" .. separator .. "'"
        local help_text = "Usage: <search_term>" .. separator .. "<file_pattern> (separate with " .. separator_desc .. ")"
        vim.notify(help_text, vim.log.levels.INFO)
      end)
    
      -- Copy current result to clipboard with Ctrl-Y
      map("i", "<C-y>", function()
        local selection = action_state.get_selected_entry()
        if selection then
          local result = selection.filename .. ":" .. selection.lnum
          vim.fn.setreg("+", result)
          vim.notify("Copied: " .. result, vim.log.levels.INFO)
        end
      end)
      
      -- Allow user-defined mappings to be applied
      if opts.attach_mappings then
        opts.attach_mappings(prompt_bufnr, map)
      end
      
      return true
    end,
  })

  -- Display help message at bottom of picker
  local separator = opts.separator or M.config.input.separator
  local separator_desc = separator == "  " and "double spaces" or "'" .. separator .. "'"
  
  if picker.prompt_border and picker.prompt_border.change_title then
    picker.prompt_border:change_title(
      "Search pattern" .. separator .. "File pattern (separate with " .. separator_desc .. ")"
    )
  end
  
  picker:find()
end

--- Launch buffer multi-grep (searching open buffers).
---@param opts table Configuration options.
function M.buffer_multigrep(opts)
  opts = vim.tbl_deep_extend("force", {}, M.config.default_opts, opts or {})
  
  -- Create a custom entry maker
  local entry_maker = function(entry)
    return {
      value = entry,
      display = string.format("%s:%d:%d %s", 
        entry.filename, 
        entry.lnum, 
        entry.col, 
        entry.text
      ),
      ordinal = entry.text,
      filename = entry.filename,
      lnum = entry.lnum,
      col = entry.col,
      bufnr = entry.bufnr
    }
  end

  local picker = pickers.new(opts, {
    prompt_title = opts.prompt_title or M.config.prompt_titles.buffer,
    finder = finders.new_dynamic({
      entry_maker = entry_maker,
      fn = function(prompt)
        return buffer_multigrep_finder(prompt, opts)
      end
    }),
    previewer = conf.grep_previewer(opts),
    sorter = conf.generic_sorter(opts),
    debounce = opts.debounce,
    attach_mappings = function(prompt_bufnr, map)
      map("i", "<CR>", function()
        local selection = action_state.get_selected_entry()
        if selection then
          vim.api.nvim_win_set_buf(0, selection.value.bufnr)
          vim.api.nvim_win_set_cursor(0, {selection.value.lnum, selection.value.col - 1})
          actions.close(prompt_bufnr)
        end
      end)
      return true
    end,
  })

  picker:find()
end

--------------------------------------------------
-- Setup and Configuration
--------------------------------------------------

--- Setup multigrep with optional configuration
---@param user_config table Configuration table
function M.setup(user_config)
  -- Merge user config with defaults
  M.config = vim.tbl_deep_extend("force", default_config, user_config or {})
  
  -- Set default keymaps unless disabled
  if M.config.mappings ~= false then
    local mappings = M.config.mappings
    
    -- Basic multi-grep
    vim.keymap.set(
      "n", 
      mappings.multigrep,
      function() 
        M.live_multigrep()
      end,
      { desc = "Telescope multi-grep (pattern + file filter)" }
    )
    
    -- Project-wide search
    if mappings.project_grep ~= false then
      vim.keymap.set(
        "n",
        mappings.project_grep,
        function() 
          M.live_multigrep({
            prompt_title = M.config.prompt_titles.project,
            cwd = vim.fn.getcwd()
          })
        end,
        { desc = "Telescope multi-grep in project root" }
      )
    end
    
    -- Hidden files search
    if mappings.hidden_grep ~= false then
      vim.keymap.set(
        "n",
        mappings.hidden_grep,
        function() 
          M.live_multigrep({
            prompt_title = M.config.prompt_titles.hidden,
            hidden = true
          })
        end,
        { desc = "Telescope multi-grep including hidden files" }
      )
    end
    
    -- Buffer search
    if mappings.buffer_grep ~= false then
      vim.keymap.set(
        "n",
        mappings.buffer_grep,
        function() 
          M.buffer_multigrep({
            prompt_title = M.config.prompt_titles.buffer
          })
        end,
        { desc = "Telescope multi-grep in open buffers" }
      )
    end
  end
  
  -- Register as a Telescope extension if requested
  if M.config.register_extension then
    telescope.register_extension({
      exports = {
        multigrep = function(opts)
          opts = vim.tbl_deep_extend("force", {}, M.config.default_opts, opts or {})
          M.live_multigrep(opts)
        end,
        buffer_multigrep = function(opts)
          opts = vim.tbl_deep_extend("force", {}, M.config.default_opts, opts or {})
          M.buffer_multigrep(opts)
        end
      }
    })
  end
  
  return M
end

return M
