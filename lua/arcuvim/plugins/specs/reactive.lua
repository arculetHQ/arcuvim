return {
    "rasulomaroff/reactive.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        require("arcuvim.plugins.configs.reactive").setup()
    end
}
