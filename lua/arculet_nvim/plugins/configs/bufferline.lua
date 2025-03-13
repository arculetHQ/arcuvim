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
        { mode = 'n', '<leader>bt', '<cmd>BufferLinePick<CR>', desc = 'Pick buffer' },
        { mode = 'n', '<leader>btt', '<cmd>BufferLinePickClose<CR>', desc = 'Pick and close buffer' },
        { mode = 'n', '<leader>bn', '<cmd>BufferLineCycleNext<CR>', desc = 'Go to next buffer' },
        { mode = 'n', '<leader>bp', '<cmd>BufferLineCyclePrev<CR>', desc = 'Go to previous buffer' },
        { mode = 'n', '<leader>bcn', '<cmd>BufferLineCloseRight<CR>', desc = 'Close buffer to the right' },
        { mode = 'n', '<leader>bcp', '<cmd>BufferLineCloseLeft<CR>', desc = 'Close buffer to the left' },
        { mode = 'n', '<leader>bco', '<cmd>BufferLineCloseOther<CR>', desc = 'Close other buffers' },
        { mode = 'n', '<leader>bca', '<cmd>BufferLineCloseAllButCurrent<CR>', desc = 'Close all buffers except current' },
        { mode = 'n', '<leader>bcc', '<cmd>Bdelete<CR>', desc = 'Close all buffers' },
    }
end

return M
