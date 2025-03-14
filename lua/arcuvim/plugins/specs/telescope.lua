return {
    'nvim-telescope/telescope.nvim',
    name = "telescope",
    tag = '0.1.8',
    dependencies = {
        'nvim-lua/plenary.nvim',
        { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' }
    },
    cmd = { "Telescope" },
    config = function()
        require("arcuvim.plugins.configs.telescope").setup()
    end,
    keys = require("arcuvim.plugins.configs.telescope").keys()
}
