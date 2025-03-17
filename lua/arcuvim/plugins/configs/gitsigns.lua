local M = {}

function M.setup()
    require('gitsigns').setup({
        current_line_blame = true,
    })
end

return M
