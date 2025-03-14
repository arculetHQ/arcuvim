return {
    "neovim/nvim-lspconfig",
    after = "mason-lspconfig.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        require("arcuvim.plugins.configs.nvim_lspconfig").setup()
    end
}
