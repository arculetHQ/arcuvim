return {
    "folke/trouble.nvim",
    cmd = "Trouble",
    configs = function()
        require("arcuvim.plugins.configs.trouble").setup()
    end,
    keys = require("arcuvim.plugins.configs.trouble").keys()
}
