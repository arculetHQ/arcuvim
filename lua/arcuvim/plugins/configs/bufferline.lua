local M = {}

function M.setup()
    require("bufferline").setup({
        options = {
            right_mouse_command = false, -- can be a string | function | false, see "Mouse actions"
            separator_style = {"|", "|"}, -- "slant" | "slope" | "thick" | "thin" | { 'any', 'any' },
            hover = { enabled = true, reveal = { "close" }, delay = 200 },
            diagnostics = "nvim_lsp",
            diagnostics_update_on_event = true,
            diagnostics_indicator = function(count, level, diagnostics_dict, context)
                if context.buffer:current() then
                    return ''
                end
                local s = " "
                for e, n in pairs(diagnostics_dict) do
                    local sym = e == "error" and " "
                        or (e == "warning" and " " or " ")
                    s = s .. sym .. n .. " "
                end
                return s
            end,
        },
        highlights = require("catppuccin.groups.integrations.bufferline").get()
    })
end

function M.keys()
    return {
        { mode = 'n', '<leader>bt', '<cmd>BufferLinePick<CR>', desc = 'Pick buffer' },
        { mode = 'n', '<leader>btt', '<cmd>BufferLinePickClose<CR>', desc = 'Pick and close buffer' },
        { mode = 'n', '<leader>bn', '<cmd>BufferLineCycleNext<CR>', desc = 'Go to next buffer' },
        { mode = 'n', '<leader>bp', '<cmd>BufferLineCyclePrev<CR>', desc = 'Go to previous buffer' },
        { mode = 'n', '<leader>bcn', '<cmd>BufferLineCloseRight<CR>', desc = 'Close buffer to the right' },
        { mode = 'n', '<leader>bcp', '<cmd>BufferLineCloseLeft<CR>', desc = 'Close buffer to the left' },
        { mode = 'n', '<leader>bco', '<cmd>BufferLineCloseOthers<CR>', desc = 'Close other buffers' },
        { mode = 'n', '<leader>bcc', '<cmd>Bdelete<CR>', desc = 'Close all buffers' },
        { mode = 'n', '<leader>tc', '<cmd>tabnew<CR>', desc = 'Create new tab' },
    }
end

return M
