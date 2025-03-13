return {
    'nvim-telescope/telescope.nvim',
    name = "telescope",
    tag = '0.1.8',
    dependencies = {
        'nvim-lua/plenary.nvim'
    },
    cmd = { "Telescope" },
    config = function()
        require("arculet_nvim.plugins.configs.telescope").setup()
    end,
    keys = require("arculet_nvim.plugins.configs.telescope").keys()
}
