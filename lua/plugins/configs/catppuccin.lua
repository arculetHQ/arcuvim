local M = {}

function M.setup()
    require("catppuccin").setup({
        flavour = "mocha",
    })

    -- Set 'Catppuccin' color theme globally for all Neovim interfaces
    vim.cmd.colorscheme("catppuccin")
end

return M
