local M = {}

function M.setup()
    local lsp_list = require("arcuvim.plugins.language_support").lsp_list()
    require("mason-lspconfig").setup({
        ensure_installed = lsp_list
    })
end

return M
