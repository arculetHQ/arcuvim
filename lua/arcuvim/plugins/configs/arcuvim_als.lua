local M = {}

local function nmap(bufnr, keys, func, desc)
	vim.keymap.set("n", keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
end

local function on_attach(client, bufnr)
	local telescope = require("telescope.builtin")
	nmap(bufnr, "<leader>cr", vim.lsp.buf.rename, "Rename")
	nmap(bufnr, "<leader>ca", vim.lsp.buf.code_action, "Code Action")
	nmap(bufnr, "gd", telescope.lsp_definitions, "Goto Definition")
	nmap(bufnr, "gr", telescope.lsp_references, "Goto References")
	nmap(bufnr, "gI", telescope.lsp_implementations, "Goto Implementation")
	nmap(bufnr, "gy", telescope.lsp_type_definitions, "Goto Type Definition")
	nmap(bufnr, "K", "<cmd>Lspsaga hover_doc<CR>", "Hover Documentation")
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

function M.lsp_setup()
	local lspsupport = require("arcuvim.plugins.language_support")
	local lspconfig, cmp = require("lspconfig"), require("cmp")
	local cmp_git = require("cmp_git")
	local copilot = require("copilot")
	local luasnip_from_vscode = require("luasnip.loaders.from_vscode")
	local lspsaga = require("lspsaga")
	local lsp_lines = require("lsp_lines")
	local lspkind = require("lspkind")
	local mason_tool_installer = require("mason-tool-installer")
	local mason_lspconfig, mason_null_ls = require("mason-lspconfig"), require("mason-null-ls")
	local null_ls = require("null-ls")
	local capabilities = require("cmp_nvim_lsp").default_capabilities()
	local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

	capabilities.textDocument.completion.completionItem.snippetSupport = true
	capabilities.textDocument.completion.completionItem.resolveSupport = {
		properties = { "documentation", "detail", "additionalTextEdits" },
	}
	capabilities.textDocument.foldingRange = { dynamicRegistration = false, lineFoldingOnly = true }

	mason_tool_installer.setup({
		ensure_installed = vim.tbl_flatten({ lspsupport.mason_lsp_list(), lspsupport.mason_null_ls_list() }),
	})

	mason_null_ls.setup({ ensure_installed = lspsupport.mason_null_ls_list(), automatic_installation = true })

	mason_lspconfig.setup({
		ensure_installed = lspsupport.mason_lsp_list(),
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
		sources = lspsupport.none_null_ls_list(),
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
			["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
			["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
			["<C-Space>"] = cmp.mapping.complete(),
			["<C-e>"] = cmp.mapping.abort(),
			["<CR>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
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

	cmp.setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
		sources = {
			{ name = "dap" },
		},
	})

	cmp_git.setup({})
	copilot.setup({
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

	luasnip_from_vscode.lazy_load()

	lspsaga.setup({
		lightbulb = { enable = false },
		symbol_in_winbar = { enable = true },
		outline = { auto_preview = false },
		ui = { border = "rounded" },
	})

	lsp_lines.setup()

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

	vim.api.nvim_set_hl(0, "@lsp.type.class", { link = "Structure" })
	vim.api.nvim_set_hl(0, "@lsp.type.decorator", { link = "Function" })

	cmp.event:on("menu_opened", function()
		vim.b.copilot_suggestion_hidden = true
	end)

	cmp.event:on("menu_closed", function()
		vim.b.copilot_suggestion_hidden = false
	end)
end

function M.dap_setup()
	local dap = require("dap")
	local dapui = require("dapui")
	local nvim_dap_vt = require("nvim-dap-virtual-text")
	dapui.setup()
	nvim_dap_vt.setup({})

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
