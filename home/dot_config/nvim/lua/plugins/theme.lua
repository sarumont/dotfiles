-- Non-Omarchy colorscheme. On Omarchy this path is a symlink managed by
-- omarchy-theme-set (ignored by chezmoi there).
return {
  { "rmehri01/onenord.nvim", priority = 1000 },
  {
    "LazyVim/LazyVim",
    opts = { colorscheme = "onenord" },
  },
}
