local M = {}

function M.setup()
    local scope = require("scope")
    local telescope = require("telescope")
    
    scope:setup()

    telescope:load_extension("scope")
end

return M
