return {
  -- leader is ",", so flash must not claim "," / ";" for f/t repeats (repeat with f/t instead)
  {
    "folke/flash.nvim",
    opts = { modes = { char = { keys = { "f", "F", "t", "T" } } } },
  },
  -- signature help stays on gK; <C-k> is insert-mode cursor movement
  {
    "neovim/nvim-lspconfig",
    opts = { servers = { ["*"] = { keys = { { "<c-k>", false, mode = "i" } } } } },
  },
  {
    "saghen/blink.cmp",
    opts = { keymap = { ["<C-k>"] = false } },
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = { window = { width = 42 } },
  },
  -- treesitter highlighting off above 500KB (was a custom autocmd under NvChad)
  {
    "folke/snacks.nvim",
    opts = { bigfile = { size = 500 * 1024 } },
  },

  { "tpope/vim-surround", keys = { "cs", "ds", "ys" } },
  { "tpope/vim-repeat", event = "VeryLazy" },
  -- "+" expands (and "_" shrinks); LazyVim's <C-space> treesitter selection also works
  { "terryma/vim-expand-region", keys = { { "+", mode = { "n", "x" } }, { "_", mode = "x" } } },
  {
    "Wansmer/treesj",
    cmd = "TSJToggle",
    keys = { { "<leader>J", "<cmd>TSJToggle<cr>", desc = "Split/join" } },
    opts = { use_default_keymaps = false },
  },
  -- Boop-style buffer transforms (base64, json, hashes, ...) via vim.ui.select / snacks
  {
    "biozz/whop.nvim",
    cmd = "Whop",
    keys = { { "<leader>cw", "<cmd>Whop<cr>", desc = "Whop (transform buffer)" } },
    opts = {},
  },
}
