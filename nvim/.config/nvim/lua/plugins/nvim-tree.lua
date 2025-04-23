return {
  "nvim-tree/nvim-tree.lua",
  config = function()
    require("nvim-tree").setup {
      git = {
        enable = true,
      },
      renderer = {
        highlight_git = true,
        icons = {
          show = {
            git = true,
          },
        },
      },
      view = {
        width = 42,
      },
    }
  end,
}
