return {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        require("arculet_nvim.plugins.configs.lualine").setup()
    end
}
