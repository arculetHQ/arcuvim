return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        require("arculet_nvim.plugins.configs.harpoon").setup()
    end,
    keys = require("arculet_nvim.plugins.configs.harpoon").keys()
}
