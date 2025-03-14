return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        require("arcuvim.plugins.configs.harpoon").setup()
    end,
    keys = require("arcuvim.plugins.configs.harpoon").keys()
}
