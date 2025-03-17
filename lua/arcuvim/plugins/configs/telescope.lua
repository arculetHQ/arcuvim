local M = {}

function M.setup()
    require("telescope").setup({
        extensions = {
            ["ui-select"] = {
                require("telescope.themes").get_dropdown {
                -- even more opts
                }
            },
            fzf = {
                fuzzy = true,                    -- false will only do exact matching
                override_generic_sorter = true,  -- override the generic sorter
                override_file_sorter = true,     -- override the file sorter
                case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
            }
        }
    })

    require("arcuvim.plugins.configs.telescope_grepx").setup({
        mappings = {
            multigrep = "<leader>mg",
            project_grep = "<leader>mgp",
            hidden_grep = "<leader>mgh",
            buffer_grep = "<leader>mgb",
        },
        default_opts = {
            follow = true,
            use_default_sorter = true,
        },
        register_extension = true,
    })

    require("telescope").load_extension("ui-select")
    require('telescope').load_extension('fzf')
    require("telescope").load_extension("scope")
    require('telescope').load_extension('dap')
    require('telescope').load_extension('projects')
end

function M.keys()
    return {
        { mode = 'n', '<leader>ff', function() require("telescope.builtin").find_files() end, desc = 'Telescope find files' },
        { mode = 'n', '<leader>fg', function() require("telescope.builtin").git_files() end, desc = 'Telescope git files' },
        { mode = 'n', '<leader>fcw', function() require("telescope.builtin").grep_string({ search = vim.fn.expand("<cword>") }) end, desc = 'Telescope grep word' },
        { mode = 'n', '<leader>fcs', function() require("telescope.builtin").grep_string({ search = vim.fn.expand("<cWORD>") }) end, desc = 'Telescope grep WORD' },
        { mode = 'n', '<leader>fs', function() require("telescope.builtin").grep_string({ search = vim.fn.input("Grep > ") }) end, desc = 'Telescope grep string' },
        { mode = 'n', '<leader>fl', function() require("telescope.builtin").live_grep() end, desc = 'Telescope live grep' },
        { mode = 'n', '<leader>fh', function() require("telescope.builtin").help_tags() end, desc = 'Telescope help tags' },
        { mode = 'n', '<leader>fr', function() require("telescope.builtin").resume() end, desc = 'Telescope resume' },
    }
end

return M
