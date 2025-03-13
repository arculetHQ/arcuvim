local M = {}

local telescope = require("telescope")
local telescope_builtin = require("telescope.builtin")

function M.setup()
    telescope:setup()
end

function M.keys()
    return {
        { 'n', '<leader>pf', function() telescope_builtin:find_files() end, desc = 'Telescope find files' },
        { 'n', '<C-p>', function() telescope_builtin:git_files() end, desc = 'Telescope git files' },
        { 'n', '<leader>pws', function() telescope_builtin:grep_string({ search = vim.fn.expand("<cword>") }) end, desc = 'Telescope grep word' },
        { 'n', '<leader>pWs', function() telescope_builtin:grep_string({ search = vim.fn.expand("<cWORD>") }) end, desc = 'Telescope grep WORD' },
        { 'n', '<leader>ps', function() telescope_builtin:grep_string({ search = vim.fn.input("Grep > ") }) end, desc = 'Telescope grep string' },
        { 'n', '<leader>vh', function() telescope_builtin:help_tags() end, desc = 'Telescope help tags' },
        { 'n', '<leader>fr', function() telescope_builtin:resume() end, desc = 'Telescope resume' },
    }
end

return M
