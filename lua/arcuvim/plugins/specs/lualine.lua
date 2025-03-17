return {
    "nvim-lualine/lualine.nvim",
    dependencies = {{ "nvim-tree/nvim-web-devicons" }, {"AndreM222/copilot-lualine"}},
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        require("arcuvim.plugins.configs.lualine").setup()
    end
}
