local M = {}

function M.setup()
  -- Load Lazy first
  require("arculet_nvim.plugins.lazy").setup()

  -- Initialize plugin manager
  require("lazy").setup({
    spec = {
      	{ import = "arculet_nvim.plugins.specs" },
      	{ import = "arculet_nvim.custom.plugins" }
    },
    defaults = {
	lazy = false,
	version = false
    },
    install = {
	colorscheme = { "catppuccin" }
    },
    checker = {
	enabled = true
    },
  })
end

return M
