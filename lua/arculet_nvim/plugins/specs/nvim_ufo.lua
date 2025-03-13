return {
    "kevinhwang91/nvim-ufo",
    dependencies = {
        "kevinhwang91/promise-async"
    },
    config = function()
        require("arculet_nvim.plugins.configs.nvim_ufo").setup()
    end,
    keys = require("arculet_nvim.plugins.configs.nvim_ufo").keys()
}
