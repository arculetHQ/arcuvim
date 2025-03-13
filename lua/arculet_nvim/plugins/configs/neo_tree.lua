local M = {}


function M.setup()
    local neo_tree = require("neo-tree")
    
    neo_tree:setup()

    vim.fn.sign_define("DiagnosticSignError", { text = " ", texthl = "DiagnosticSignError" })
    vim.fn.sign_define("DiagnosticSignWarn", { text = " ", texthl = "DiagnosticSignWarn" })
    vim.fn.sign_define("DiagnosticSignInfo", { text = " ", texthl = "DiagnosticSignInfo" })
    vim.fn.sign_define("DiagnosticSignHint", { text = "󰌵", texthl = "DiagnosticSignHint" })
end

function M.keys()
    return {
        { "n", "<leader>e", "<cmd>Neotree toggle position=right<cr>", desc = "Toggle neotree" },
    }
end

return M
