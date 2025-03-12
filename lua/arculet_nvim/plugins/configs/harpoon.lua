local M = {}

local harpoon = require("harpoon")
local harpoon_extensions = require("harpoon.extensions")

local telescope_finders = require("telescope.finders")
local telescope_pickers = require("telescope.pickers")
local telescope_config = require("telescope.config").values
local telescope_actions = require("telescope.actions")
local telescope_actions_state = require("telescope.actions.state")

--[=[
    -- telescope configuration
    local function toggle_telescope(harpoon_files)
        local current_items = harpoon_files.items

        local finder = function()
            local paths = {}
            for _, item in ipairs(current_items) do
                table.insert(paths, item.value)
            end

            return telescope_finders.new_table({
                results = paths,
            })
        end

        telescope_pickers.new({}, {
            prompt_title = "Harpoon",
            finder = finder(),
            previewer = false,
            sorter = telescope_config.generic_sorter({}),
            layout_config = {
                height = 0.4,
                width = 0.5,
                prompt_position = "top",
                preview_cutoff = 120,
            },
            attach_mappings = function(prompt_bufnr, map)
                map("i", "<C-d>", function()
                    local state = telescope_actions_state
                    local selected_entry = state.get_selected_entry()
                    local current_picker = state.get_current_picker(prompt_bufnr)

                    table.remove(current_items, selected_entry.index)
                    current_picker:refresh(finder())
                end)

                map("n", "<C-j>", function()
                    local state = telescope_actions_state
                    local selected_entry = state.get_selected_entry()
                    local current_picker = state.get_current_picker(prompt_bufnr)
                    if selected_entry.index < #current_items then
                        current_items[selected_entry.index], current_items[selected_entry.index+1] = 
                        current_items[selected_entry.index+1], current_items[selected_entry.index]
                        current_picker:refresh(finder())
                    end
                end,
                { desc = "Moves selected harpoon item down" })

                map("n", "<C-k>", function()
                    local state = telescope_actions_state
                    local selected_entry = state.get_selected_entry()
                    local current_picker = state.get_current_picker(prompt_bufnr)
                    if selected_entry.index > 1 then
                        current_items[selected_entry.index-1], current_items[selected_entry.index] = 
                        current_items[selected_entry.index], current_items[selected_entry.index-1]
                        current_picker:refresh(finder())
                    end
                end,
                { desc = "Moves selected harpoon item up" })
                return true
            end,
        }):find()
    end
--]=]

-- Keep track of toggle
local toggle_cache = {}

local function harpoon_toggle(idx1, idx2)
    -- Validate indices when creating the function
    local sorted_idx1 = math.min(idx1, idx2)
    local sorted_idx2 = math.max(idx1, idx2)
    local cache_key = string.format("%d-%d", sorted_idx1, sorted_idx2)

    return function()
        local list = harpoon:list()
        
        -- Validate indices are within list bounds
        if sorted_idx2 > #list.items then
            vim.notify(string.format(
                "Harpoon list only has %d items (requested %d and %d)",
                #list.items,
                sorted_idx1,
                sorted_idx2
            ), vim.log.levels.WARN)
            return
        end

        -- Initialize or get current toggle state
        toggle_cache[cache_key] = toggle_cache[cache_key] or sorted_idx1
        local current_index = toggle_cache[cache_key]
        local new_index = current_index == sorted_idx1 and sorted_idx2 or sorted_idx1

        -- Perform the toggle
        list:select(new_index)
        toggle_cache[cache_key] = new_index
    end
end

function M.setup()
    harpoon:setup({})
    harpoon:extend(harpoon_extensions.builtins.highlight_current_file())
    
    vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end, { desc = "Add current buffer to the harpoon list" })
    
    -- vim.keymap.set("n", "<C-e>", function() toggle_telescope(harpoon:list()) end, { desc = "Open harpoon window" })
    vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
    
    vim.keymap.set("n", "<leader><Tab>", harpoon_toggle(1, 2), { desc = "Toggle between items 1 and 2" })

    -- Toggle previous & next buffers stored within Harpoon list
    vim.keymap.set("n", "<M-i>", function() harpoon:list():prev() end, { desc = "Switch to the previous buffer on the harpoon list" })
    vim.keymap.set("n", "<M-o>", function() harpoon:list():next() end, { desc = "Switch to the next buffer on the harpoon list" })

end

return M
