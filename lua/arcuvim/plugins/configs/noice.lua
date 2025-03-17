local M = {}

function M.setup()
    require("noice").setup({
        lsp = {
            -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
            override = {
                ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                ["vim.lsp.util.stylize_markdown"] = true,
                ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
            },
        },
        -- you can enable a preset for easier configuration
        presets = {
            bottom_search = true, -- use a classic bottom cmdline for search
            command_palette = true, -- position the cmdline and popupmenu together
            long_message_to_split = true, -- long messages will be sent to a split
            inc_rename = true, -- enables an input dialog for inc-rename.nvim
            lsp_doc_border = false, -- add a border to hover docs and signature help
        },
        cmdline = {
            format = {
                cmdline = {
                    icon = ""
                },
                filter = {
                    icon = ""
                }
            }
        },
        messages = {
            view = "mini",
            view_warn = "mini",
        }
    })

    require("telescope").load_extension("noice")
end

function M.keys()
    return {
        { mode = 'n', "<leader>nl", "<cmd>NoiceLast<cr>", desc = "Noice last" },
        { mode = 'n', "<leader>nh", "<cmd>NoiceHistory<cr>", desc = "Noice history" },
    }
end

return M
