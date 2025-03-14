local M = {}

function M.keys()
    return {
        { mode = 'n', "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" }
    }
end

return M
