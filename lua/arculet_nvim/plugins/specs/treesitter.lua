return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        require("arculet_nvim.plugins.configs.treesitter").setup()
    end
}
