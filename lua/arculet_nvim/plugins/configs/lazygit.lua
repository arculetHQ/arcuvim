local M = {}

function M.keys()
    return {
        { "n", "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" }
    }
end

return M
