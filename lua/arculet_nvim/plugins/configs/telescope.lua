local M = {}

function M.setup()
    require("telescope").setup({})
end

function M.keys()    
    return {
        { 'n', '<leader>pf', function() require("telescope.builtin").find_files() end, desc = 'Telescope find files' },
        { 'n', '<C-p>', function() require("telescope.builtin").git_files() end, desc = 'Telescope git files' },
        { 'n', '<leader>pws', function() require("telescope.builtin").grep_string({ search = vim.fn.expand("<cword>") }) end, desc = 'Telescope grep word' },
        { 'n', '<leader>pWs', function() require("telescope.builtin").grep_string({ search = vim.fn.expand("<cWORD>") }) end, desc = 'Telescope grep WORD' },
        { 'n', '<leader>ps', function() require("telescope.builtin").grep_string({ search = vim.fn.input("Grep > ") }) end, desc = 'Telescope grep string' },
        { 'n', '<leader>vh', function() require("telescope.builtin").help_tags() end, desc = 'Telescope help tags' },
        { 'n', '<leader>fr', function() require("telescope.builtin").resume() end, desc = 'Telescope resume' },
    }
end

return M
