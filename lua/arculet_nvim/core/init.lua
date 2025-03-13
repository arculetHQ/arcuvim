local M = {}

require("arculet_nvim.core.options")
require("arculet_nvim.core.keymaps")

vim.defer_fn(function()
    require("arculet_nvim.core.python").setup()
end, 0)

return M
