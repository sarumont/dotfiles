require "nvchad.options"

local o = vim.o

o.cursorlineopt = 'both' -- to enable cursorline!
o.laststatus = 2

vim.fn.sign_define('DapBreakpoint', {text='🔴', texthl='', linehl='', numhl=''})

-- automatically rebalance windows on vim resize
vim.cmd([[au VimResized * :wincmd =]])

vim.cmd([[au BufReadPost * if expand('%:p') !~# '\m/\.git/' && line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif]])
