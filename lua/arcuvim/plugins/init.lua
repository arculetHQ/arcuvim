local M = {}

function M.setup()
  -- Load Lazy first
  require("arcuvim.plugins.lazy").setup()

  -- Initialize plugin manager
  require("lazy").setup({
    spec = {
      	{ import = "arcuvim.plugins.specs" }
    },
    defaults = {
	lazy = true,
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
