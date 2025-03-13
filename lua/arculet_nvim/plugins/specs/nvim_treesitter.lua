return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
        require("arculet_nvim.plugins.configs.nvim_treesitter").setup()
    end
}
