return {
    "williamboman/mason-lspconfig.nvim",
    config = function()
        require("arculet_nvim.plugins.configs.mason_lspconfig").setup()
    end
}
