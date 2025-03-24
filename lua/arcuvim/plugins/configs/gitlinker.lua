local M = {}

function M.keys()
	return {
		{ "<leader>gy", "<cmd>GitLink<cr>", mode = { "n", "v" }, desc = "Yank git link" },
	}
end

return M
