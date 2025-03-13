local M = {}

local neo_tree = require("neo-tree")

function M.setup()
    vim.fn.sign_define("DiagnosticSignError", { text = " ", texthl = "DiagnosticSignError" })
    vim.fn.sign_define("DiagnosticSignWarn", { text = " ", texthl = "DiagnosticSignWarn" })
    vim.fn.sign_define("DiagnosticSignInfo", { text = " ", texthl = "DiagnosticSignInfo" })
    vim.fn.sign_define("DiagnosticSignHint", { text = "󰌵", texthl = "DiagnosticSignHint" })

    neo_tree:setup()
end

function M.keys()
    return {
        { "n", "<leader>et", "<cmd>Neotree toggle position=right<cr>", desc = "Toggle neotree" },
    }
end

return M
