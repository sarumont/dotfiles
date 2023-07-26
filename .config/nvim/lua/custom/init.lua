vim.g.mapleader = ","

vim.cmd([[au BufReadPost * if expand('%:p') !~# '\m/\.git/' && line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif]])

-- automatically rebalance windows on vim resize
vim.cmd([[au VimResized * :wincmd =]])

vim.fn.sign_define('DapBreakpoint', {text='🔴', texthl='', linehl='', numhl=''})

-- per-window statusline
vim.opt.laststatus = 2
