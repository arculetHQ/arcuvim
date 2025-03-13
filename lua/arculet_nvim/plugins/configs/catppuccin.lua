local M = {}

function M.setup()
    require("catppuccin").setup({
        term_colors = true, -- sets terminal colors (e.g. `g:terminal_color_0`)
        integrations = {
            harpoon = true,
            notify = true,
            window_picker = true,
            lsp_trouble = true,
            which_key = true,
            octo = true,
            diffview = true,
            hop = true,
            noice = true,
            fidget = true,
            sandwich = true,
            snacks = {
                enabled = true,
                indent_scope_color = "mauve", -- catppuccin color (eg. `lavender`) Default: text
            }
        },
    })

    -- Set 'Catppuccin' color theme globally for all Neovim interfaces
    vim.cmd.colorscheme("catppuccin")
end

return M
