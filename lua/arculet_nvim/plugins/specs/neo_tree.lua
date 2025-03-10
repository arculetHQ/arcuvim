return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
        "MunifTanjim/nui.nvim",
        {"3rd/image.nvim", opts = {}}, -- Optional image support in preview window: See `# Preview Mode` for more information
        {
            "s1n7ax/nvim-window-picker", -- for open_with_window_picker keymaps
            version = "2.*",
            config = function()
                require("arculet_nvim.plugins.configs.nvim_window_picker").setup() 
            end,
        },
    },
    config = function()
        require("arculet_nvim.plugins.configs.neo_tree").setup()
    end
    }
}
