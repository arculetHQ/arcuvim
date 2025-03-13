return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        require("arculet_nvim.plugins.configs.nvim_lspconfig").setup()
    end
}
