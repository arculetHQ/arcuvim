return {
  'nvimdev/dashboard-nvim',
  event = 'VimEnter',
  dependencies = {{'nvim-tree/nvim-web-devicons'}},
  config = function()
    require("arculet_nvim.plugins.configs.dashboard_nvim").setup()
  end
}
