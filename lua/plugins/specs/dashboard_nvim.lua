return {
  'nvimdev/dashboard-nvim',
  event = 'VimEnter',
  dependencies = {{'nvim-tree/nvim-web-devicons'}},
  config = function()
    require("plugins.configs.dashboard_nvim").setup()
  end
}
