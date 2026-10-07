-- Options are automatically loaded before lazy.nvim startup
-- Default options: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
vim.g.mapleader = ","
vim.g.maplocalleader = "\\"

-- OSC 52 + wl-copy clipboard for tmux/herdr/SSH sessions (from Omarchy)
require("config.remote_clipboard").setup()

vim.opt.relativenumber = false
vim.opt.cursorlineopt = "both"

-- format on save (conform, with LSP fallback)
vim.g.autoformat = true
