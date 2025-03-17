return {
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			"nvimtools/none-ls.nvim",
			"nvimtools/none-ls-extras.nvim",
			"jay-babu/mason-null-ls.nvim",
			"onsails/lspkind.nvim",
			"https://git.sr.ht/~whynothugo/lsp_lines.nvim",
			"AckslD/swenv.nvim",
			{
				"williamboman/mason.nvim",
				event = "VeryLazy",
				opts = {},
			},
			{
				"hrsh7th/nvim-cmp",
				dependencies = {
					"hrsh7th/cmp-nvim-lsp",
					"hrsh7th/cmp-nvim-lua",
					"hrsh7th/cmp-buffer",
					"hrsh7th/cmp-path",
					"hrsh7th/cmp-cmdline",
					"petertriho/cmp-git",
					"hrsh7th/cmp-calc",
					"hrsh7th/cmp-emoji",
					"rcarriga/cmp-dap",
					{
						"zbirenbaum/copilot.lua",
						cmd = "Copilot",
						event = "InsertEnter",
						opts = {},
					},
					{
						"CopilotC-Nvim/CopilotChat.nvim",
						dependencies = {
							"zbirenbaum/copilot.lua", -- or zbirenbaum/copilot.lua
							"nvim-telescope/telescope.nvim",
							{ "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
						},
						build = "make tiktoken", -- Only on MacOS or Linux
						opts = {},
						keys = require("arcuvim.plugins.configs.arcuvim_als").copilot_chat__keys(),
					},
					{
						"zbirenbaum/copilot-cmp",
						after = "copilot.lua",
						opts = {},
					},
				},
			},
			{
				"L3MON4D3/LuaSnip",
				build = "make install_jsregexp",
				dependencies = {
					"rafamadriz/friendly-snippets",
					"saadparwaiz1/cmp_luasnip",
				},
			},
			{
				"folke/lazydev.nvim",
				ft = "lua", -- only load on lua files
				opts = {
					library = {
						-- See the configuration section for more details
						-- Load luvit types when the `vim.uv` word is found
						{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
					},
				},
			},
			{
				"nvimdev/lspsaga.nvim",
				dependencies = {
					"nvim-treesitter/nvim-treesitter", -- optional
					"nvim-tree/nvim-web-devicons", -- optional
				},
			},
			{
				"VidocqH/lsp-lens.nvim",
				opts = {},
			},
		},
		config = function()
			require("arcuvim.plugins.configs.arcuvim_als").lsp_setup()
		end,
	},
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"rcarriga/nvim-dap-ui",
			"theHamsta/nvim-dap-virtual-text",
			"andrewferrier/debugprint.nvim",
			"nvim-neotest/nvim-nio",
			"nvim-telescope/telescope-dap.nvim",
			"Weissle/persistent-breakpoints.nvim",
			"echasnovski/mini.nvim",
			"mxsdev/nvim-dap-vscode-js",
			{
				"microsoft/vscode-js-debug",
				build = "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out",
			},
		},
		config = function()
			require("arcuvim.plugins.configs.arcuvim_als").dap_setup()
		end,
	},
}
