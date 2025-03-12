return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require("arculet_nvim.plugins.configs.treesitter").setup()
        end
    },
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        after = "nvim-treesitter",
        dependencies = {
            "nvim-treesitter/nvim-treesitter"
        },
    }
}
