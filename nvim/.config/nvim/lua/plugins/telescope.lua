return {
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release",
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      {
        "biozz/whop.nvim",
        config = function()
          require("whop").setup {}
        end,
      },
    },
    opts = {
      defaults = {
        mappings = {
          i = {
            ["<C-u>"] = false,
          },
        },
      },
      extensions = {
        whop = {
          preview_buffer_line_limit = 1000, -- default is 1000
        },
      },
    },
  },
}
