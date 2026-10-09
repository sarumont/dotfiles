-- Options are automatically loaded before lazy.nvim startup
-- Default options: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
vim.g.mapleader = ","
vim.g.maplocalleader = "\\"

local nvim_python = vim.fn.expand("~/.local/share/nvim-python/bin/python")
if vim.fn.executable(nvim_python) == 1 then
  vim.g.python3_host_prog = nvim_python
end

-- OSC 52 + wl-copy clipboard for tmux/herdr/SSH sessions (from Omarchy)
require("config.remote_clipboard").setup()

vim.opt.relativenumber = false
vim.opt.cursorlineopt = "both"

-- format on save (conform, with LSP fallback)
vim.g.autoformat = true
