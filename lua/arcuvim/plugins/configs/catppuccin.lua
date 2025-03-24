local M = {}

function M.setup()
	require("catppuccin").setup({
		term_colors = true, -- sets terminal colors (e.g. `g:terminal_color_0`)
		integrations = {
			harpoon = true,
			notify = true,
			window_picker = true,
			lsp_trouble = true,
			which_key = true,
			octo = true,
			diffview = true,
			hop = true,
			noice = true,
			fidget = true,
			sandwich = true,
			lsp_saga = true,
			nvim_surround = true,
			window_picker = true,
			snacks = {
				enabled = true,
				indent_scope_color = "mauve", -- catppuccin color (eg. `lavender`) Default: text
			},
			mini = {
				enabled = true,
				indentscope_color = "", -- catppuccin color (eg. `lavender`) Default: text
			},
			colorful_winsep = {
				enabled = true,
			},
			illuminate = {
				enabled = true,
				lsp = true,
			},
		},
	})

	-- Set 'Catppuccin' color theme globally for all Neovim interfaces
	vim.cmd.colorscheme("catppuccin")
end

return M
