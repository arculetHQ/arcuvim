local M = {}

function M.setup()
    require("bufferline").setup({
        right_mouse_command = false, -- can be a string | function | false, see "Mouse actions"
        separator_style = {"|", "|"}, -- "slant" | "slope" | "thick" | "thin" | { 'any', 'any' },
        highlights = require("catppuccin.groups.integrations.bufferline").get()
    })
end

function M.keys()
    return {
        { 'n', '<leader>bt', '<cmd>BufferLinePick<CR>', desc = 'Pick buffer' },
        { 'n', '<leader>btt', '<cmd>BufferLinePickClose<CR>', desc = 'Pick and close buffer' },
        { 'n', '<leader>bn', '<cmd>BufferLineCycleNext<CR>', desc = 'Go to next buffer' },
        { 'n', '<leader>bp', '<cmd>BufferLineCyclePrev<CR>', desc = 'Go to previous buffer' },
        { 'n', '<leader>bcn', '<cmd>BufferLineCloseRight<CR>', desc = 'Close buffer to the right' },
        { 'n', '<leader>bcp', '<cmd>BufferLineCloseLeft<CR>', desc = 'Close buffer to the left' },
        { 'n', '<leader>bco', '<cmd>BufferLineCloseOther<CR>', desc = 'Close other buffers' },
        { 'n', '<leader>bca', '<cmd>BufferLineCloseAllButCurrent<CR>', desc = 'Close all buffers except current' },
        { 'n', '<leader>bcc', '<cmd>Bdelete<CR>', desc = 'Close all buffers' },
    }
end

return M
