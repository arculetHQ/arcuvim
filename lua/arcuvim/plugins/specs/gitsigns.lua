return {
    "lewis6991/gitsigns.nvim",
    event = "VeryLazy",
    config = function ()
        require("arcuvim.plugins.configs.gitsigns").setup()
    end
}
