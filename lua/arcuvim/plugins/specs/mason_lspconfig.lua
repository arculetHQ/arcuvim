return {
    "williamboman/mason-lspconfig.nvim",
    after = "mason",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        require("arcuvim.plugins.configs.mason_lspconfig").setup()
    end
}
