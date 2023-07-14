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
    ["<leader>dr"] = {
      "<cmd> DapToggleRepl <CR>",
      "Open Debugging console"
    },
    ["<leader>dso"] = {
      "<cmd> DapStepOver <CR>",
      "Step over current line"
    },
    ["<leader>dsi"] = {
      "<cmd> DapStepInto <CR>",
      "Step into current line"
    },
    ["<leader>dsu"] = {
      "<cmd> DapStepOut <CR>",
      "Step out of current line"
    },
    ["<leader>dx"] = {
      function()
        require('dap').terminate()
        require('dap').repl.close()
      end,
      "Terminate debugging"
    },
    ["<leader>dc"] = {
      function()
        require('dap').continue()
        require('dap').repl.open()
      end,
      "Begin or resume debugging test"
    },
    ["<leader>dl"] = {
      function()
        require('dap').run_last()
        require('dap').repl.open()
      end,
      "Debug last test"
    },
    ["<leader>dh"] = {
      function()
        require('dap.ui.widgets').hover()
      end,
      "Show dap hover widget"
    },
    ["<leader>dp"] = {
      function()
        require('dap.ui.widgets').preview()
      end,
      "Show dap preview widget"
    },
    ["<leader>df"] = {
      function()
        local widgets = require('dap.ui.widgets')
        widgets.centered_float(widgets.frames)
      end,
      "Show debug frames"
    },
    ["<leader>dv"] = {
      function()
        local widgets = require('dap.ui.widgets')
        widgets.centered_float(widgets.scopes)
      end,
      "Show debug scopes"
    }
  }
}

M.dap_go = {
  plugin = true,
  n = {
    ["<leader>dgt"] = {
      function()
        require('dap-go').debug_test()
        require('dap').repl.open()
      end,
      "Debug go test"
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
    ["<leader>gst"] = {
      "<cmd> GoTagAdd otel <CR>",
      "Add Open Telemetry struct tags"
    },
    ["<leader>gie"] = {
      "<cmd> GoIfErr <CR>",
      "Add Go try-catch block"
    }
  }
}

M.vtr = {
  n = {

-- Before using this command, attaching to a tmux runner pane via VtrOpenRunner
-- or VtrAttachToPane is required. If you would like VTR to create a runner pane
-- if it doesn't exist while issuing a command, a bang version can be used:
-- VtrSendCommandToRunner!.

    ["<leader>vp"] = {
      "<cmd> VtrFlushCommand <cr><cmd> VtrSendCommandToRunner! <cr>",
      "Prompt command to execute in tmux runner"
    },
    ["<leader>vrl"] = {
      "<cmd> VtrSendCommandToRunner! <cr>",
      "Re-run last command in tmux runner"
    },
    ["<leader>vq"] = {
      "<cmd> VtrKillRunner <cr>",
      "Kill the tmux runner"
    }
  }
}

M.coverage = {
  plugin = true,
  n = {
    ["<leader>cl"] = {
      "<cmd> Coverage <CR>",
      "Load code coverage"
    },
    ["<leader>ct"] = {
      "<cmd> CoverageToggle <CR>",
      "Toggle code coverage display"
    },
    ["<leader>cs"] = {
      "<cmd> CoverageSummary <CR>",
      "Show code coverage summary"
    }
  }
}

M.obsidian = {
  plugin = true,
  n = {
     ["<C-p>"] = {
      "<cmd>ObsidianQuickSwitch<CR>",
      "Obsidian quick switch"
    },
     ["<leader>on"] = {
      ":ObsidianNew ",
      "Obsidian new note"
    },
  }
}

-- use telescope for some LSP things instead of the default (quickfix window)
M.lspoveride = {
   n = {
      ["gi"] = { "<cmd> Telescope lsp_implementations <CR>", "LSP implementations" },
      ["gr"] = { "<cmd> Telescope lsp_references <CR>", "LSP references" },
   },
}

return M
