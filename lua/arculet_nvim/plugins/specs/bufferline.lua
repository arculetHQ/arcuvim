return {
  'akinsho/bufferline.nvim',
  after = "catppuccin",
  dependencies = {
    'moll/vim-bbye',
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    require("arculet_nvim.plugins.configs.bufferline").setup()
  end,
}
