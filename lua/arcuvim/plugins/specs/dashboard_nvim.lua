return {
  'nvimdev/dashboard-nvim',
  event = 'VimEnter',
  dependencies = {{'nvim-tree/nvim-web-devicons'}},
  config = function()
    require("arcuvim.plugins.configs.dashboard_nvim").setup()
  end,
  keys = require("arcuvim.plugins.configs.dashboard_nvim").keys()
}
