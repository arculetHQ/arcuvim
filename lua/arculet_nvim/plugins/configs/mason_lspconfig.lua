local M = {}

function M.setup()
    require("mason-lspconfig").setup({
        ensure_installed = {
            "lua_ls",
            "clangd"
        }
    })
end

return M
