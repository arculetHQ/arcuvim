local M = {}

function M.setup()
    require("catppuccin").setup({
        flavour = "auto", -- latte, frappe, macchiato, mocha
        background = { -- :h background
            light = "latte",
            dark = "mocha",
        },
        transparent_background = false, -- disables setting the background color.
        show_end_of_buffer = false, -- shows the '~' characters after the end of buffers
        term_colors = true, -- sets terminal colors (e.g. `g:terminal_color_0`)
        dim_inactive = {
            enabled = false, -- dims the background color of inactive window
            shade = "dark",
            percentage = 0.15, -- percentage of the shade to apply to the inactive window
        },
        no_italic = false, -- Force no italic
        no_bold = false, -- Force no bold
        no_underline = false, -- Force no underline
        styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
            comments = { "italic" }, -- Change the style of comments
            conditionals = { "italic" },
            loops = {},
            functions = {},
            keywords = {},
            strings = {},
            variables = {},
            numbers = {},
            booleans = {},
            properties = {},
            types = {},
            operators = {},
            -- miscs = {}, -- Uncomment to turn off hard-coded styles
        },
        color_overrides = {},
        custom_highlights = {},
        default_integrations = true,
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
