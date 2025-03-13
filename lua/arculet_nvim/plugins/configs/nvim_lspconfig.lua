local M = {}

function M.setup()
    local lspconfig = require("lspconfig")
    lspconfig.lua_ls.setup({})
end

return M
