local M = {}

function M.lsp_list()
    return {"lua_ls"}
end

function M.formatter_list()
    return { "stylua" }
end

return M
