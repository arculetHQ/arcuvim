return {
    'stevearc/aerial.nvim',
    opts = {},
    -- Optional dependencies
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-tree/nvim-web-devicons"
    },
    config = function()
        require("arculet_nvim.plugins.configs.aerial").setup()
    end,
    keys = require("arculet_nvim.plugins.configs.aerial").keys()
}
