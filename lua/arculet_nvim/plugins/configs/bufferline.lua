local M = {}

local mocha = require("catppuccin.palettes").get_palette "mocha"

function M.setup()
    require('bufferline').setup {
        options = {
            right_mouse_command = false, -- can be a string | function | false, see "Mouse actions"
            separator_style = {"|", "|"}, -- "slant" | "slope" | "thick" | "thin" | { 'any', 'any' },
        },
        highlights = require("catppuccin.groups.integrations.bufferline").get()
    }

    vim.keymap.set('n', '<leader>ct', '<cmd>tabnew<CR>', { desc = "Create new tab" })
    vim.keymap.set('n', '<leader>cct', '<cmd>tabclose<CR>', { desc = "Close current tab" })
    vim.keymap.set('n', 'gb', '<cmd>BufferLineCycleNext<CR>', { desc = "Go to next buffer" })
    vim.keymap.set('n', 'gB', '<cmd>BufferLineCyclePrev<CR>', { desc = "Go to previous buffer" })
    vim.keymap.set('n', 'bmn', '<cmd>BufferLineMoveNext<CR>', { desc = "Mover buffer to right" })
    vim.keymap.set('n', 'bmp', '<cmd>BufferLineMovePrev<CR>', { desc = "Move buffer to left" })
    vim.keymap.set('n', 'bcc', '<cmd>Bdelete<CR>', { desc = "Close current buffer" })
    vim.keymap.set('n', 'bco', '<cmd>BufferLineCloseOthers<CR>', { desc = "Close all buffers except current" })
    vim.keymap.set('n', 'bcn', '<cmd>BufferLineCloseNext<CR>', { desc = "Close buffer to the right" })
    vim.keymap.set('n', 'bcp', '<cmd>BufferLineClosePrev<CR>', { desc = "Clsoe buffer to the left" })
end

return M
