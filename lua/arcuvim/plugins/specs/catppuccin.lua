return {
  "catppuccin/nvim",
  name = "catppuccin",
  lazy = false,
  priority = 1000,
  config = function()
    require("arcuvim.plugins.configs.catppuccin").setup()
  end
}
