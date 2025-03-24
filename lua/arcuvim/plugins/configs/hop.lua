local M = {}

function M.keys()
	return {
		{
			mode = "n",
			"f",
			function()
				local hop = require("hop")
				local directions = require("hop.hint").HintDirection

				hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true })
			end,
			remap = true,
		},
		{
			mode = "n",
			"F",
			function()
				local hop = require("hop")
				local directions = require("hop.hint").HintDirection

				hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true })
			end,
			remap = true,
		},
		{
			mode = "n",
			"t",
			function()
				local hop = require("hop")
				local directions = require("hop.hint").HintDirection

				hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true, hint_offset = -1 })
			end,
			remap = true,
		},
		{
			mode = "n",
			"T",
			function()
				local hop = require("hop")
				local directions = require("hop.hint").HintDirection

				hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true, hint_offset = 1 })
			end,
			remap = true,
		},
		{
			mode = "n",
			"<leader>hw",
			"<cmd>HopWord<cr>",
			remap = true,
		},
		{
			mode = "n",
			"<leader>hl",
			"<cmd>HopLineStart<cr>",
			remap = true,
		},
	}
end

return M
