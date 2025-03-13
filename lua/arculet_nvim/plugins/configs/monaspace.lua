local M = {}

function M.opts()
    return {
        style_map = {
            bold_italic = {
                -- NeoTree
                NeoTreeDimText = true,
                NeoTreeFileName = true,
                NeoTreeGitModified = true,
                NeoTreeGitStaged = true,
                NeoTreeGitUntracked = true,
                NeoTreeNormal = true,
                NeoTreeNormalNC = true,
                NeoTreeTabActive = true,
                NeoTreeTabInactive = true,
                NeoTreeTabSeparatorActive = true,
                NeoTreeTabSeparatorInactive = true,
            }
        }
    }
end

return M
