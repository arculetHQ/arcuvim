local M = {}

function M.setup()
    require("aerial").setup({
        -- optionally use on_attach to set keymaps when aerial has attached to a buffer
        on_attach = function(bufnr)
            -- Jump forwards/backwards with '{' and '}'
            vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
            vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr })
        end,
    })
end

function M.keys()
    return {
        { mode = "n", "<leader>at", "<cmd>AerialToggle!<cr>", desc = "Aerial toggle" },
    }
end

return M
