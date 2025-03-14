local M = {}

function M.setup()
    require("lualine").setup({
        options = {
            component_separators = { left = '|', right = '|'},
            section_separators = { left = '▊', right = ''},
        },
        sections = {
            lualine_a = {
                {
                    "mode",
                    icon = "",
                    on_click = function()
                        local current_bg = vim.o.background
                        vim.defer_fn(function() vim.o.background = current_bg == "dark" and "light" or "dark" end, 100)
                        vim.defer_fn(function() vim.o.background = current_bg end, 200)
                        vim.defer_fn(function() vim.o.background = current_bg == "dark" and "light" or "dark" end, 300)
                        vim.defer_fn(function() vim.o.background = current_bg end, 400)
                    end
                },
            },
            lualine_c = {},
            lualine_x = { 'encoding', 'fileformat', 'filetype', 'lsp_status' }
        },
        extensions = { "neo-tree" }
    })
end

return M
