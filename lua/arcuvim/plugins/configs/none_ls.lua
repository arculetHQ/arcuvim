local M = {}

function M.setup()
    local null_ls = require("null-ls")

    null_ls.setup({
        sources = {
            null_ls.builtins
        }
    })
end

return {}
