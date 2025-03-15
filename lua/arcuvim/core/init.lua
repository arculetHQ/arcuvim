local M = {}

require("arcuvim.core.options")
require("arcuvim.core.keymaps")
require("arcuvim.core.autocmd")

vim.defer_fn(function()
    require("arcuvim.core.python").setup()
end, 0)

return M
