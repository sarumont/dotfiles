return {
  {
    "tpope/vim-surround",
    keys = { "cs", "ds" },
  },
  {
    "tpope/vim-repeat",
    keys = { "." },
  },
  {
    "terryma/vim-expand-region",
    keys = { "+" },
  },
  {
    "Wansmer/treesj",
    cmd = "TSJToggle",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
      use_default_keymaps = false,
    },
  },
}
