local M = {}


function M.setup()
    vim.fn.sign_define("DiagnosticSignError", { text = " ", texthl = "DiagnosticSignError" })
    vim.fn.sign_define("DiagnosticSignWarn", { text = " ", texthl = "DiagnosticSignWarn" })
    vim.fn.sign_define("DiagnosticSignInfo", { text = " ", texthl = "DiagnosticSignInfo" })
    vim.fn.sign_define("DiagnosticSignHint", { text = "󰌵", texthl = "DiagnosticSignHint" })

    require("neo-tree").setup({
        filesystem = {
            filtered_items = {
                visible = true,
            },
        },
    })
end

function M.keys()
    return {
        { mode = 'n', "<leader>e", "<cmd>Neotree toggle position=right<cr>", desc = "Toggle neotree" },
    }
end

return M
