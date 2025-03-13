local M = {}

function M.setup()
    require('lspconfig').lua_ls.setup()
end

return M
