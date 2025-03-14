return {
    "nvim-treesitter/nvim-treesitter-textobjects",
    after = "nvim-treesitter",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
        "nvim-treesitter/nvim-treesitter"
    },
}
