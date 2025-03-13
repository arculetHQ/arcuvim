local M = {}

function M.setup()
    local mason_lspconfig = require("mason-lspconfig")

    mason_lspconfig:setup({
        ensure_installed = {
            "lua_ls",
            "clangd"
        }
    })
end

return M
