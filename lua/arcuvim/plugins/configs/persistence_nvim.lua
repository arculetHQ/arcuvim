local M = {}

function M.keys()
	return {

		{
			mode = "n",
			"<leader>qs",
			function()
				require("persistence").load()
			end,
		},
		{
			mode = "n",
			"<leader>qS",
			function()
				require("persistence").select()
			end,
		},
		{
			mode = "n",
			"<leader>ql",
			function()
				require("persistence").load({ last = true })
			end,
		},
		{
			mode = "n",
			"<leader>qd",
			function()
				require("persistence").stop()
			end,
		},
	}
end

return M
