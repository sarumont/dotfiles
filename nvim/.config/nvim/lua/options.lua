require "nvchad.options"

local o = vim.o
o.cursorlineopt ='both'

-- tressitter code folding
o.foldmethod = "expr"
o.foldexpr = "nvim_treesitter#foldexpr()"
