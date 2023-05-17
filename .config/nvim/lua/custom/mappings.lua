local M = {}

M.general = {
  n = {
     ["<C-h>"] = {":TmuxNavigateLeft<CR>", "navigate left"},
     ["<C-l>"] = {":TmuxNavigateRight<CR>", "navigate right"},
     ["<C-k>"] = {":TmuxNavigateUp<CR>", "navigate up"},
     ["<C-j>"] = {":TmuxNavigateDown<CR>", "navigate down"},
  },
}

M.telescope = {
  n = {
     ["<C-p>"] = {":Telescope find_files <CR>", "Telescope Files"}
  },
}

M.hop = {
  n = {
     ["<leader><leader>b"] = {":HopWordBC <CR>", "Hop Word Before Cursor"},
     ["<leader><leader>w"] = {":HopWordAC <CR>", "Hop Word After Cursor"},
     ["<leader><leader>j"] = {":HopLineBC <CR>", "Hop Line Before Cursor"},
     ["<leader><leader>k"] = {":HopLineAC <CR>", "Hop Line After Cursor"},
  },
  v = {
     ["<leader><leader>b"] = {":HopWordBC <CR>", "Hop Word Before Cursor"},
     ["<leader><leader>w"] = {":HopWordAC <CR>", "Hop Word After Cursor"},
     ["<leader><leader>j"] = {":HopLineBC <CR>", "Hop Line Before Cursor"},
     ["<leader><leader>k"] = {":HopLineAC <CR>", "Hop Line After Cursor"},
  },
}

M.fugitive = {
  n = {
     ["<leader>gd"] = {":Git diff <cr>", "Git diff of the entire buffer"},
     ["<leader>gl"] = {":Git log <cr>", "Git log"},
     ["<leader>gs"] = {":Git <cr>", "Git status"},
     ["<leader>gbf"] = {":Git blame -w -M<cr>", "Git blame for the entire file"},
     ["<leader>gc"] = {":Git commit<cr>", "Start a git commit"},
     ["<leader>gp"] = {":Git push<cr>", "Git push"},
     ["<leader>ga"] = {":Git commit --amend<cr>", "Amend a git commit"},
     ["<leader>gup"] = {":Git up <cr>", "Git pull"},
  }
}

M.dap = {
  plugin = true,
  n = {
    ["<leader>db"] = {
      "<cmd> DapToggleBreakpoint <CR>",
      "Add breakpoint at line"
    },
    ["<leader>dus"] = {
      function ()
        local widgets = require('dap.ui.widgets');
        local sidebar = widgets.sidebar(widgets.scopes);
        sidebar.open();
      end,
      "Open debugging sidebar"
    }
  }
}

M.dap_go = {
  plugin = true,
  n = {
    ["<leader>dgt"] = {
      function()
        require('dap-go').debug_test()
      end,
      "Debug go test"
    },
    ["<leader>dgl"] = {
      function()
        require('dap-go').debug_last()
      end,
      "Debug last go test"
    }
  }
}

M.gopher = {
  plugin = true,
  n = {
    ["<leader>gsj"] = {
      "<cmd> GoTagAdd json <CR>",
      "Add json struct tags"
    },
    ["<leader>gsy"] = {
      "<cmd> GoTagAdd yaml <CR>",
      "Add yaml struct tags"
    }
  }
}

return M

