return {
	"folke/persistence.nvim",
	event = "BufReadPre", -- this will only start session saving when an actual file was opened
	keys = require("arcuvim.plugins.configs.persistence_nvim").keys(),
	opts = {
		-- add any custom options here
	},
}
