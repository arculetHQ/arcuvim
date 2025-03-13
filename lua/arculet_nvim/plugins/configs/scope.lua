local M = {}

local scope = require("scope")
local telescope = require("telescope")

function M.setup()
    scope.setup()

    telescope.load_extension("scope")
end

return M
