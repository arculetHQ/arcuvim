local M = {}

function M.setup()
   require("ts-node-action").setup({})

   vim.keymap.set(
    { "n" },
    "<leader>tk",
    require("ts-node-action").node_action,
    { desc = "Trigger Node Action" }
)

end

return M
