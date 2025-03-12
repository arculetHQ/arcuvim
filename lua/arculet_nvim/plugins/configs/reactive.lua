local M = {}

function M.setup()
    require("reactive").setup({
        builtin = {
            cursorline = true,
            cursor = true,
            modemsg = true,
        },
        load = { 'catppuccin-mocha-cursor', 'catppuccin-mocha-cursorline' }
    })
end

return M
