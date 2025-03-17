local M = {}

function M.setup()
	require("nvim-treesitter").setup({
		ensure_installed = require("arcuvim.plugins.language_support").treesitter_list(),

		sync_install = false,
		auto_install = true,

		highlight = {
			enable = true,
			additional_vim_regex_highlighting = false,
		},
	})
end

return M
