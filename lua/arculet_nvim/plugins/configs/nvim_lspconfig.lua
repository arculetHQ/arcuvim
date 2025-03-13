local M = {}

local lspconfig = require('lspconfig')

function M.setup()
    lspconfig:lua_ls.setup()
end

return M
