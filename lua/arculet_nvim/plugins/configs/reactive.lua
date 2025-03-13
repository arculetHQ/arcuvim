local M = {}

local reactive = require("reactive")

function M.setup()
    reactive:setup({
        builtin = {
            cursorline = true,
            cursor = true,
            modemsg = true,
        },
        load = { 'catppuccin-mocha-cursor', 'catppuccin-mocha-cursorline' }
    })
end

return M
