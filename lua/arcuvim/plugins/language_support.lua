local M = {}

function M.lsp_list()
    return {"lua_ls" }
end

function M.none_ls_source_list()
    return {
        { type = "builtin", name = "formatting.stylua" },
        -- { type = "external", name = "none-ls.diagnostics.eslint" }
    }
end

return M
