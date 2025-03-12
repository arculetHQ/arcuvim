local M = {}

function M.setup()
    require("scope").setup({
        
    })

    require("telescope").load_extension("scope")
end

return M
