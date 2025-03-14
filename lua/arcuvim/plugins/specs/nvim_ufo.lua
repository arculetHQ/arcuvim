return {
    "kevinhwang91/nvim-ufo",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "kevinhwang91/promise-async"
    },
    config = function()
        require("arcuvim.plugins.configs.nvim_ufo").setup()
    end,
    keys = require("arcuvim.plugins.configs.nvim_ufo").keys()
}
