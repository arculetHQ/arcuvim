local M = {}

function M.setup()
	local lsp_list = require("arcuvim.plugins.language_support").lsp_list()
	local none_ls_source_list = require("arcuvim.plugins.language_support").none_ls_source_list()
	local capabilities = require("cmp_nvim_lsp").default_capabilities()
	local lspconfig = require("lspconfig")
	local lspkind = require("lspkind")
	local null_ls = require("null-ls")
	local cmp = require("cmp")
	local dynamic_capabilities = vim.lsp.protocol.make_client_capabilities()
	local sources = {}
	dynamic_capabilities.textDocument.completion.completionItem.snippetSupport = true
	dynamic_capabilities.textDocument.completion.completionItem.resolveSupport = {
		properties = { "documentation", "detail", "additionalTextEdits" },
	}
	capabilities = vim.tbl_deep_extend("force", capabilities, dynamic_capabilities)
	capabilities.textDocument.semanticHighlighting = {
		ranges = true,
		tokenModifiers = { "declaration", "documentation", "readonly", "static" },
		tokenTypes = 256, -- Access all semantic token types
	}
	capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = true

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
		nmap("<leader>cd", "<cmd>TroubleToggle document_diagnostics<cr>", "Document Diagnostics")
		nmap("<leader>cs", "<cmd>TroubleToggle workspace_diagnostics<cr>", "Workspace Diagnostics")
		nmap("<leader>cf", function()
			vim.lsp.buf.format({ async = true, timeout = 5000 })
		end, "Format")
		nmap("<leader>cl", "<cmd>LspLineDiagnostics<cr>", "Line Diagnostics")

		-- Inlay hints
		require("inlay-hints").on_attach(client, bufnr)

		-- Signature help
		require("lsp_signature").on_attach({
			bind = true,
			handler_opts = { border = "rounded" },
			hint_prefix = "󰌶 ",
		}, bufnr)

		-- CodeLens support
		if client.supports_method("textDocument/codeLens") then
			vim.lsp.codelens.refresh()
			vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
				buffer = bufnr,
				callback = vim.lsp.codelens.refresh,
			})
		end
	end

	for _, lsp in ipairs(lsp_list) do
		lspconfig[lsp].setup({
			on_attach = on_attach,
			capabilities = capabilities,
		})
	end

	require("mason-lspconfig").setup({
		ensure_installed = lsp_list,
		automatic_installation = true,
	})

	for _, item in ipairs(none_ls_source_list) do
		if item.type == "builtin" then
			-- Handle built-in sources from null-ls.builtins
			local builtin = require("null-ls.builtins")
			local module = builtin

			for segment in item.name:gmatch("([^%.]+)") do
				module = module[segment]
				if not module then
					break
				end
			end

			if module then
				table.insert(sources, module)
			end
		elseif item.type == "external" then
			-- Handle external sources (like none-ls-extras.nvim)
			local success, external_module = pcall(require, item.name)
			if success then
				table.insert(sources, external_module)
			else
				print("Warning: Could not load " .. item.name)
			end
		end
	end

	null_ls.setup({
		sources = sources,
	})

	cmp.setup({
		snippet = {
			-- REQUIRED - you must specify a snippet engine
			expand = function(args)
				require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
			end,
		},
		preselect = cmp.PreselectMode.Item,
		window = {
			completion = cmp.config.window.bordered({
				winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual",
			}),
			documentation = cmp.config.window.bordered(),
		},
		mapping = cmp.mapping.preset.insert({
			["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
			["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
			["<C-Space>"] = cmp.mapping.complete(),
			["<C-e>"] = cmp.mapping.abort(),
			["<CR>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
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
			{
				name = "lazydev",
			},
		}, {
			{ name = "buffer" },
		}),
	})

	cmp.setup.filetype("gitcommit", {
		sources = cmp.config.sources({
			{ name = "git" },
		}, {
			{ name = "buffer" },
		}),
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

	local has_words_before = function()
		if vim.api.nvim_get_option_value(0, "buftype") == "prompt" then
			return false
		end
		local line, col = unpack(vim.api.nvim_win_get_cursor(0))
		return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") == nil
	end
	cmp.setup({
		mapping = {
			["<Tab>"] = vim.schedule_wrap(function(fallback)
				if cmp.visible() and has_words_before() then
					cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
				else
					fallback()
				end
			end),
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
			selection = require("CopilotChat,select").visual,
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

	vim.lsp.handlers["workspace/didChangeWorkspaceFolders"] = function(_, _, ctx)
		require("lspconfig.util").refresh_config(ctx.client_id)
		vim.schedule(function()
			vim.lsp.buf.execute_command({
				command = "workspace/reload",
				arguments = { vim.fn.getcwd() },
			})
		end)
	end

	vim.api.nvim_set_hl(0, "@lsp.type.class", { link = "Structure" })
	vim.api.nvim_set_hl(0, "@lsp.type.decorator", { link = "Function" })

	vim.keymap.set("n", "gD", "<CMD>Glance definitions<CR>")
	vim.keymap.set("n", "gR", "<CMD>Glance references<CR>")
	vim.keymap.set("n", "gY", "<CMD>Glance type_definitions<CR>")
	vim.keymap.set("n", "gM", "<CMD>Glance implementations<CR>")
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

return M
