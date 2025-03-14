return {
  'akinsho/bufferline.nvim',
  after = "catppuccin",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    'moll/vim-bbye',
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    require("arcuvim.plugins.configs.bufferline").setup()
  end,
  keys = require("arcuvim.plugins.configs.bufferline").keys()
}
