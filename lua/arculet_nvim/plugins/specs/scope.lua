return {
    "tiagovla/scope.nvim",
    after = "telescope",
    config = function()
        require("arculet_nvim.plugins.configs.scope").setup()
    end
}
