return {
    "williamboman/mason.nvim",
    config = function()
        require("arculet_nvim.plugins.configs.mason").setup()
    end
}
