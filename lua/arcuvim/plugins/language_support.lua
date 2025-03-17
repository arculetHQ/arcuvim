local M = {}

function M.treesitter_list()
	return {
		"lua",
		"c",
		"regex",
		"dap_repl",
		"javascript",
		"tsx",
		"typescript",
		"json",
		"jsonc",
		"json5",
	}
end

function M.mason_lsp_list()
	return { "lua_ls", "ts_ls", "eslint" }
end

function M.mason_null_ls_list()
	return { "stylua", "eslint_d", "prettierd" }
end

function M.none_null_ls_list()
	local null_ls = require("null-ls")
	return {
		null_ls.builtins.code_actions.gitsigns,
		null_ls.builtins.diagnostics.commitlint,
		null_ls.builtins.diagnostics.editorconfig_checker,
		null_ls.builtins.diagnostics.todo_comments,
		null_ls.builtins.formatting.codespell,
		null_ls.builtins.diagnostics.codespell,
		null_ls.builtins.completion.spell,
		null_ls.builtins.diagnostics.textidote,
		null_ls.builtins.code_actions.ts_node_action,
		null_ls.builtins.diagnostics.checkmake,

		-- Prettire
		-- Filetypes: { "javascript", "javascriptreact", "typescript",
		-- "typescriptreact", "vue", "css", "scss", "less", "html",
		-- "json", "jsonc", "yaml", "markdown", "markdown.mdx",
		-- "graphql", "handlebars", "svelte", "astro", "htmlangular" }
		null_ls.builtins.formatting.prettierd,

		-- Stylua
		-- Filetypes: { "lua", "luau" }
		null_ls.builtins.formatting.stylua,
	}
end

function M.debuggers()
	local dap = require("dap")

	-- JavaScript
	-- Update this accordingly
	local FIREFOX_BINARY = "/usr/bin/firefox"
	local FIREFOX_DEBUG_ADAPTER_PATH = os.getenv("HOME") .. "/Playground/language_servers/dap/vscode-firefox-debug/dist"
	require("dap-vscode-js").setup({
		adapters = { "pwa-node", "pwa-chrome" },
	})

	-- Node Debugger
	dap.configurations.javascript = {
		{
			type = "pwa-node",
			request = "launch",
			name = "Launch file",
			program = "${file}",
			cwd = "${workspaceFolder}",
		},
	}

	-- Deno Debugger
	dap.configurations.typescript = {
		{
			type = "pwa-node",
			request = "launch",
			name = "Launch file",
			runtimeExecutable = "deno",
			runtimeArgs = {
				"run",
				"--inspect-wait",
				"--allow-all",
			},
			program = "${file}",
			cwd = "${workspaceFolder}",
			attachSimplePort = 9229,
		},
	}

	-- FireFox Debugger
	dap.adapters.firefox = {
		type = "executable",
		command = "node",
		args = { FIREFOX_DEBUG_ADAPTER_PATH .. "/adapter.bundle.js" },
	}

	dap.configurations.typescript = {
		{
			name = "Debug with Firefox",
			type = "firefox",
			request = "launch",
			reAttach = true,
			url = "http://localhost:3000",
			webRoot = "${workspaceFolder}",
			firefoxExecutable = FIREFOX_BINARY,
		},
	}

	dap.configurations.typescriptreact = {
		{
			name = "Debug with Firefox",
			type = "firefox",
			request = "launch",
			reAttach = true,
			url = "http://localhost:3000",
			webRoot = "${workspaceFolder}",
			firefoxExecutable = FIREFOX_BINARY,
		},
	}

	dap.configurations.javascript = {
		{
			name = "Debug with Firefox",
			type = "firefox",
			request = "launch",
			reAttach = true,
			url = "http://localhost:3000",
			webRoot = "${workspaceFolder}",
			firefoxExecutable = FIREFOX_BINARY,
		},
	}

	dap.configurations.javascriptreact = {
		{
			name = "Debug with Firefox",
			type = "firefox",
			request = "launch",
			reAttach = true,
			url = "http://localhost:3000",
			webRoot = "${workspaceFolder}",
			firefoxExecutable = FIREFOX_BINARY,
		},
	}

	-- -- Chrome Debugger
	-- dap.configurations.javascriptreact = {
	-- 	{
	-- 		type = "pwa-chrome",
	-- 		request = "attach",
	-- 		program = "${file}",
	-- 		cwd = vim.fn.getcwd(),
	-- 		sourceMaps = true,
	-- 		protocol = "inspector",
	-- 		port = 9222,
	-- 		webRoot = "${workspaceFolder}",
	-- 	},
	-- }
	--
	-- dap.configurations.javascript = {
	-- 	{
	-- 		type = "chrome",
	-- 		request = "attach",
	-- 		program = "${file}",
	-- 		cwd = vim.fn.getcwd(),
	-- 		sourceMaps = true,
	-- 		protocol = "inspector",
	-- 		port = 9222,
	-- 		webRoot = "${workspaceFolder}",
	-- 	},
	-- }
	--
	-- dap.configurations.typescriptreact = {
	-- 	{
	-- 		type = "chrome",
	-- 		request = "attach",
	-- 		program = "${file}",
	-- 		cwd = vim.fn.getcwd(),
	-- 		sourceMaps = true,
	-- 		protocol = "inspector",
	-- 		port = 9222,
	-- 		webRoot = "${workspaceFolder}",
	-- 	},
	-- }
	--
	-- dap.configurations.typescript = {
	-- 	{
	-- 		type = "chrome",
	-- 		request = "attach",
	-- 		program = "${file}",
	-- 		cwd = vim.fn.getcwd(),
	-- 		sourceMaps = true,
	-- 		protocol = "inspector",
	-- 		port = 9222,
	-- 		webRoot = "${workspaceFolder}",
	-- 	},
	-- }

	-- C/C++ Debugger
	dap.adapters.gdb = {
		type = "executable",
		command = "gdb",
		args = { "--interpreter=dap", "--eval-command", "set print pretty on" },
	}
end

return M
