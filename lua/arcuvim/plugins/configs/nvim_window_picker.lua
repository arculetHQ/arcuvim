local M = {}

function M.setup()
	require("window-picker").setup({
		hint = "floating-big-letter",
		filter_rules = {
			include_current_win = false,
			autoselect_one = true,
			-- filter using buffer options
			bo = {
				-- if the file type is one of following, the window will be ignored
				filetype = { "neo-tree", "neo-tree-popup", "notify" },
				-- if the buffer type is one of following, the window will be ignored
				buftype = { "terminal", "quickfix" },
			},
		},
	})

	vim.keymap.set("n", "<leader>ww", function()
		local picked_window_id = require("window-picker").pick_window()
		if picked_window_id then
			vim.api.nvim_set_current_win(picked_window_id)
		end
	end)
end

return M
