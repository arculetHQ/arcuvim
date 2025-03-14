local M = {}

require("arcuvim.core.options")
require("arcuvim.core.keymaps")

vim.defer_fn(function()
    require("arcuvim.core.python").setup()
end, 0)

return M
