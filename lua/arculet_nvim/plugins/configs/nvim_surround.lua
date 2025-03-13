local M = {}

function M.setup()
    local nvim_surround = require("nvim-surround")
    
    nvim_surround:setup()
end

return M
