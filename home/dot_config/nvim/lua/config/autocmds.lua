-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- (LazyVim already restores the last cursor position on open.)

-- treesitter highlighting is slow and unhelpful for html
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("user_html_no_ts", { clear = true }),
  pattern = "html",
  callback = function(args)
    vim.treesitter.stop(args.buf)
  end,
})
