local M = {}

function M.setup()
    local lsp_list = require("arcuvim.plugins.language_support").lsp_list()
    local lspconfig = require("lspconfig")

    for _, lsp in ipairs(lsp_list) do
        lspconfig[lsp].setup({})
    end
end

return M
