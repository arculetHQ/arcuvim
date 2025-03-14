return {
    'stevearc/aerial.nvim',
    opts = {},
    -- Optional dependencies
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-tree/nvim-web-devicons"
    },
    config = function()
        require("arcuvim.plugins.configs.aerial").setup()
    end,
    keys = require("arcuvim.plugins.configs.aerial").keys()
}
