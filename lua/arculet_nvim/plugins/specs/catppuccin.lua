return {
  "catppuccin/nvim",
  name = "catppuccin",
  lazy = false,
  priority = 1000,
  config = function()
    require("arculet_nvim.plugins.configs.catppuccin").setup()
  end
}
