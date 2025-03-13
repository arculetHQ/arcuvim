local M = {}

local mason_lspconfig = require("mason-lspconfig")

function M.setup()
    mason_lspconfig:setup({
        ensure_installed = {
            "lua_ls",
            "clangd"
        }
    })
end

return M
