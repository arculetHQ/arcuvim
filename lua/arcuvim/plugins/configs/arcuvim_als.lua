local M = {}

function M.lsp_setup()
	local dynamic_capabilities = vim.lsp.protocol.make_client_capabilities()
	local capabilities = require("cmp_nvim_lsp").default_capabilities(dynamic_capabilities)
	local lspconfig = require("lspconfig")
	local mason_tool_installer = require("mason-tool-installer")
	local lspkind = require("lspkind")
	local null_ls = require("null-ls")
	local cmp = require("cmp")
	capabilities.textDocument.completion.completionItem.snippetSupport = true
	capabilities.textDocument.completion.completionItem.resolveSupport = {
		properties = { "documentation", "detail", "additionalTextEdits" },
	}
	capabilities.textDocument.foldingRange = { dynamicRegistration = false, lineFoldingOnly = true }

	local prompts = {
		-- Code related prompts
		Explain = "Please explain how the following code works.",
		Review = "Please review the following code and provide suggestions for improvement.",
		Tests = "Please explain how the selected code works, then generate unit tests for it.",
		Refactor = "Please refactor the following code to improve its clarity and readability.",
		FixCode = "Please fix the following code to make it work as intended.",
		FixError = "Please explain the error in the following text and provide a solution.",
		BetterNamings = "Please provide better names for the following variables and functions.",
		Documentation = "Please provide documentation for the following code.",
		SwaggerApiDocs = "Please provide documentation for the following API using Swagger.",
		SwaggerJsDocs = "Please write JSDoc for the following API using Swagger.",
		-- Text related prompts
		Summarize = "Please summarize the following text.",
		Spelling = "Please correct any grammar and spelling errors in the following text.",
		Wording = "Please improve the grammar and wording of the following text.",
		Concise = "Please rewrite the following text to make it more concise.",
	}

	local on_attach = function(client, bufnr)
		-- Omnipotent keymaps
		local function nmap(keys, func, desc)
			vim.keymap.set("n", keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
		end

		nmap("<leader>cr", vim.lsp.buf.rename, "Rename")
		nmap("<leader>ca", vim.lsp.buf.code_action, "Code Action")
		nmap("gd", require("telescope.builtin").lsp_definitions, "Goto Definition")
		nmap("gr", require("telescope.builtin").lsp_references, "Goto References")
		nmap("gI", require("telescope.builtin").lsp_implementations, "Goto Implementation")
		nmap("gy", require("telescope.builtin").lsp_type_definitions, "Goto Type Definition")
		nmap("K", "<cmd>Lspsaga hover_doc<cr>", "Hover Documentation")
	end

	local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
	local mason_lsp_list = require("arcuvim.plugins.language_support").mason_lsp_list()
	local mason_null_ls_list = require("arcuvim.plugins.language_support").mason_null_ls_list()
	local none_null_ls_list = require("arcuvim.plugins.language_support").none_null_ls_list()

	local merged_mason_list = {}

	for _, v in ipairs(mason_lsp_list) do
		table.insert(merged_mason_list, v)
	end
	for _, v in ipairs(mason_null_ls_list) do
		table.insert(merged_mason_list, v)
	end

	local lsp_formatting = function(bufnr)
		vim.lsp.buf.format({
			filter = function(client)
				-- apply whatever logic you want (in this example, we'll only use null-ls)
				return client.name == "null-ls"
			end,
			bufnr = bufnr,
		})
	end

	local function is_null_ls_formatting_enabled(bufnr)
		local file_type = vim.api.nvim_buf_get_option(bufnr, "filetype")
		local generators =
			require("null-ls.generators").get_available(file_type, require("null-ls.methods").internal.FORMATTING)
		return #generators > 0
	end

	mason_tool_installer.setup({
		ensure_installed = merged_mason_list,
	})

	require("mason-null-ls").setup({
		ensure_installed = mason_null_ls_list,
		automatic_installation = true,
		handlers = {},
	})

	require("mason-lspconfig").setup({
		ensure_installed = mason_lsp_list,
		automatic_installation = true,
		handlers = {
			function(server)
				lspconfig[server].setup({
					on_attach = on_attach,
					capabilities = capabilities,
					autostart = true,
				})
			end,
		},
	})

	null_ls.setup({
		sources = none_null_ls_list,
		debug = true,
		on_attach = function(client, bufnr)
			if client.supports_method("textDocument/formatting") then
				vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
				vim.api.nvim_create_autocmd("BufWritePre", {
					group = augroup,
					buffer = bufnr,
					callback = function()
						lsp_formatting(bufnr)
					end,
				})
			end

			if client.server_capabilities.documentFormattingProvider then
				if client.name == "null-ls" and is_null_ls_formatting_enabled(bufnr) or client.name ~= "null-ls" then
					vim.bo[bufnr].formatexpr = "v:lua.vim.lsp.formatexpr()"
					vim.keymap.set(
						"n",
						"<leader>gq",
						"<cmd>lua vim.lsp.buf.format({ async = true, timeout = 5000 })<CR>"
					)
				else
					vim.bo[bufnr].formatexpr = nil
				end
			end
		end,
		autostart = true,
	})

	cmp.setup({
		snippet = {
			-- REQUIRED - you must specify a snippet engine
			expand = function(args)
				require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
			end,
		},
		enabled = function()
			return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt" or require("cmp_dap").is_dap_buffer()
		end,
		window = {
			completion = cmp.config.window.bordered({
				winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual",
			}),
			documentation = cmp.config.window.bordered(),
		},
		mapping = cmp.mapping.preset.insert({
			["<C-b>"] = cmp.mapping.scroll_docs(-4),
			["<C-f>"] = cmp.mapping.scroll_docs(4),
			["<C-Space>"] = cmp.mapping.complete(),
			["<C-e>"] = cmp.mapping.abort(),
			["<CR>"] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
		}),
		formatting = {
			format = lspkind.cmp_format({
				mode = "symbol", -- show only symbol annotations
				maxwidth = {
					-- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
					-- can also be a function to dynamically calculate max width such as
					-- menu = function() return math.floor(0.45 * vim.o.columns) end,
					menu = 50, -- leading text (labelDetails)
					abbr = 50, -- actual suggestion item
				},
				ellipsis_char = "...", -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
				show_labelDetails = true, -- show labelDetails in menu. Disabled by default
				symbol_map = { Copilot = "" },

				-- The function below will be called before any actual modifications from lspkind
				-- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
				before = function(entry, vim_item)
					-- ...
					return vim_item
				end,
			}),
		},
		sources = cmp.config.sources({
			{ name = "nvim_lsp" },
			{ name = "nvim_lua" },
			{ name = "luasnip" },
			{ name = "calc" },
			{ name = "copilot" },
			{ name = "path" },
			{ name = "buffer" },
			{ name = "lazydev" },
			{ name = "emoji" },
		}),
	})

	cmp.setup.filetype("gitcommit", {
		sources = cmp.config.sources({
			{ name = "git" },
		}, {
			{ name = "buffer" },
		}),
	})

	require("cmp").setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
		sources = {
			{ name = "dap" },
		},
	})

	require("cmp_git").setup({})
	require("copilot").setup({
		suggestion = { enabled = false },
		panel = { enabled = false },
	})

	cmp.setup.cmdline({ "/", "?" }, {
		mapping = cmp.mapping.preset.cmdline(),
		sources = {
			{ name = "buffer" },
		},
	})

	cmp.setup.cmdline(":", {
		mapping = cmp.mapping.preset.cmdline(),
		sources = cmp.config.sources({
			{ name = "path" },
		}, {
			{ name = "cmdline" },
		}),
		matching = { disallow_symbol_nonprefix_matching = false },
	})

	require("luasnip.loaders.from_vscode").lazy_load()

	require("lspsaga").setup({
		lightbulb = { enable = false },
		symbol_in_winbar = { enable = true },
		outline = { auto_preview = false },
		ui = { border = "rounded" },
	})

	require("lsp_lines").setup()
	vim.diagnostic.config({
		virtual_text = false,
		virtual_lines = true,
		update_in_insert = false,
		severity_sort = true,
		float = {
			border = "rounded",
			source = "always",
			header = "",
			prefix = "",
		},
	})

	require("CopilotChat").setup({
		question_header = "## User ",
		answer_header = "## Copilot ",
		error_header = "## Error ",
		prompts = prompts,
		mappings = {
			-- Use tab for completion
			complete = {
				detail = "Use @<Tab> or /<Tab> for options.",
				insert = "<Tab>",
			},
			-- Close the chat
			close = {
				normal = "q",
				insert = "<C-c>",
			},
			-- Reset the chat buffer
			reset = {
				normal = "<C-x>",
				insert = "<C-x>",
			},
			-- Submit the prompt to Copilot
			submit_prompt = {
				normal = "<CR>",
				insert = "<C-CR>",
			},
			-- Accept the diff
			accept_diff = {
				normal = "<C-y>",
				insert = "<C-y>",
			},
			-- Show help
			show_help = {
				normal = "g?",
			},
		},
	})

	vim.api.nvim_create_user_command("CopilotChatVisual", function(args)
		require("CopilotChat").ask(args.args, { selection = require("CopilotChat.select").visual })
	end, { nargs = "*", range = true })

	vim.api.nvim_create_user_command("CopilotChatInline", function(args)
		require("CopilotChat").ask(args.args, {
			selection = require("CopilotChat.select").visual,
			window = {
				layout = "float",
				relative = "cursor",
				width = 1,
				height = 0.4,
				row = 1,
			},
		})
	end, { nargs = "*", range = true })

	-- Restore CopilotChatBuffer
	vim.api.nvim_create_user_command("CopilotChatBuffer", function(args)
		require("CopilotChat").ask(args.args, { selection = require("CopilotChat.select").buffer })
	end, { nargs = "*", range = true })

	-- Custom buffer for CopilotChat
	vim.api.nvim_create_autocmd("BufEnter", {
		pattern = "copilot-*",
		callback = function()
			vim.opt_local.relativenumber = true
			vim.opt_local.number = true

			-- Get current filetype and set it to markdown if the current filetype is copilot-chat
			local ft = vim.bo.filetype
			if ft == "copilot-chat" then
				vim.bo.filetype = "markdown"
			end
		end,
	})

	vim.api.nvim_set_hl(0, "@lsp.type.class", { link = "Structure" })
	vim.api.nvim_set_hl(0, "@lsp.type.decorator", { link = "Function" })
	vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#6CC644" })

	cmp.event:on("menu_opened", function()
		vim.b.copilot_suggestion_hidden = true
	end)

	cmp.event:on("menu_closed", function()
		vim.b.copilot_suggestion_hidden = false
	end)
end

function M.copilot_chat__keys()
	return {
		{
			"<leader>cp",
			function()
				require("CopilotChat").select_prompt({
					context = {
						"buffers",
					},
				})
			end,
			desc = "CopilotChat - Prompt actions",
		},
		{
			"<leader>cp",
			function()
				require("CopilotChat").select_prompt()
			end,
			mode = "x",
			desc = "CopilotChat - Prompt actions",
		},
		-- Code related commands
		{ "<leader>ce", "<cmd>CopilotChatExplain<cr>", desc = "CopilotChat - Explain code" },
		{ "<leader>ct", "<cmd>CopilotChatTests<cr>", desc = "CopilotChat - Generate tests" },
		{ "<leader>ccr", "<cmd>CopilotChatReview<cr>", desc = "CopilotChat - Review code" },
		{ "<leader>cR", "<cmd>CopilotChatRefactor<cr>", desc = "CopilotChat - Refactor code" },
		{ "<leader>cn", "<cmd>CopilotChatBetterNamings<cr>", desc = "CopilotChat - Better Naming" },
		-- Chat with Copilot in visual mode
		{
			"<leader>cv",
			":CopilotChatVisual",
			mode = "x",
			desc = "CopilotChat - Open in vertical split",
		},
		{
			"<leader>cx",
			":CopilotChatInline",
			mode = "x",
			desc = "CopilotChat - Inline chat",
		},
		-- Custom input for CopilotChat
		{
			"<leader>cai",
			function()
				local input = vim.fn.input("Ask Copilot: ")
				if input ~= "" then
					vim.cmd("CopilotChat " .. input)
				end
			end,
			desc = "CopilotChat - Ask input",
		},
		-- Generate commit message based on the git diff
		{
			"<leader>cm",
			"<cmd>CopilotChatCommit<cr>",
			desc = "CopilotChat - Generate commit message for all changes",
		},
		-- Quick chat with Copilot
		{
			"<leader>cq",
			function()
				local input = vim.fn.input("Quick Chat: ")
				if input ~= "" then
					vim.cmd("CopilotChatBuffer " .. input)
				end
			end,
			desc = "CopilotChat - Quick chat",
		},
		-- Fix the issue with diagnostic
		{ "<leader>ccf", "<cmd>CopilotChatFixError<cr>", desc = "CopilotChat - Fix Diagnostic" },
		-- Clear buffer and chat history
		{ "<leader>ccl", "<cmd>CopilotChatReset<cr>", desc = "CopilotChat - Clear buffer and chat history" },
		-- Toggle Copilot Chat Vsplit
		{ "<leader>cv", "<cmd>CopilotChatToggle<cr>", desc = "CopilotChat - Toggle" },
		-- Copilot Chat Models
		{ "<leader>c?", "<cmd>CopilotChatModels<cr>", desc = "CopilotChat - Select Models" },
		-- Copilot Chat Agents
		{ "<leader>caa", "<cmd>CopilotChatAgents<cr>", desc = "CopilotChat - Select Agents" },
	}
end

function M.dap_setup()
	local dap = require("dap")
	local dapui = require("dapui")
	dapui.setup()
	require("nvim-dap-virtual-text").setup({})
	require("arcuvim.plugins.language_support").debuggers()

	dap.listeners.before.attach.dapui_config = function()
		dapui.open()
	end
	dap.listeners.before.launch.dapui_config = function()
		dapui.open()
	end
	dap.listeners.before.event_terminated.dapui_config = function()
		dapui.close()
	end
	dap.listeners.before.event_exited.dapui_config = function()
		dapui.close()
	end

	require("persistent-breakpoints").setup({
		load_breakpoints_event = { "BufReadPost" },
	})

	require("swenv").setup({
		post_set_venv = function()
			local client = vim.lsp.get_clients({ name = "basedpyright" })[1]
			if not client then
				return
			end
			local venv = require("swenv.api").get_current_venv()
			if not venv then
				return
			end
			local venv_python = venv.path .. "/bin/python"
			if client.settings then
				client.settings =
					vim.tbl_deep_extend("force", client.settings, { python = { pythonPath = venv_python } })
			else
				client.config.settings =
					vim.tbl_deep_extend("force", client.config.settings, { python = { pythonPath = venv_python } })
			end
			client.notify("workspace/didChangeConfiguration", { settings = nil })
		end,
	})

	vim.api.nvim_create_autocmd("FileType", {
		pattern = { "python" },
		callback = function()
			require("swenv.api").auto_venv()
		end,
	})

	local opts = { noremap = true, silent = true }
	local keymap = vim.api.nvim_set_keymap
	-- Save breakpoints to file automatically.
	keymap("n", "<leader>bpt", "<cmd>lua require('persistent-breakpoints.api').toggle_breakpoint()<cr>", opts)
	keymap("n", "<leader>bpc", "<cmd>lua require('persistent-breakpoints.api').set_conditional_breakpoint()<cr>", opts)
	keymap("n", "<leader>bpac", "<cmd>lua require('persistent-breakpoints.api').clear_all_breakpoints()<cr>", opts)
	keymap("n", "<leader>bpp", "<cmd>lua require('persistent-breakpoints.api').set_log_point()<cr>", opts)
end

return M
