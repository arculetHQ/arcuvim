return {
    "neovim/nvim-lspconfig",
    config = function()
        require("arculet_nvim.plugins.configs.nvim_lspconfig").setup()
    end
}
