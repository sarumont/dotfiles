local plugins = {

  -- code
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        -- vim
        "vim",
        "lua",

        -- web
        "html",
        "css",
        "json",
        "javascript",
        "typescript",

        -- markup
        "comment",
        "markdown",
        "markdown_inline",
        "yaml",

        -- real languages
        "go",
        "gomod",
        "gowork",
        "gosum",
        "java",
        "cmake",

        -- utils
        "bash",
        "dockerfile",
        "terraform",
      },
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = { "markdown" },
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "nvchad.configs.lspconfig"
      require "configs.lspconfig"
    end,
    opts = {
      inlay_hints = {
        enabled = false,
      },
    }
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    lazy = false,
    config = function()
      require("treesitter-context").setup({
        separator = "─",
      })
      vim.cmd([[hi TreesitterContextLineNumberBottom gui=underline]])
    end,
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    ft = {"go", "lua"},
    opts = function()
      return require "configs.null-ls"
    end,
  },
  {
    "mfussenegger/nvim-dap",
  },
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
			"nvim-lua/plenary.nvim",
      "nvim-neotest/neotest-go",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      adapters = {
        ["neotest-go"] = {
          recursive_run = true,
        },
      },
    }
  },
  {
    "folke/trouble.nvim",
    opts = {}, -- for default options, refer to the configuration section for custom setup.
    cmd = "Trouble",
    keys = {
      "<leader>xx",
      "<leader>xX",
      "<leader>cs",
      "<leader>cl",
      "<leader>xL",
      "<leader>xQ",
    },
  },

  -- Copilot
  {
    "zbirenbaum/copilot.lua",
    event = "InsertEnter",
    opts = function()
      return require "configs.copilot"
    end
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      {
        "zbirenbaum/copilot-cmp",
        config = function()
          require("copilot_cmp").setup()
        end,
      },
    },
    opts = {
      sources = {
        { name = "nvim_lsp", group_index = 2 },
        { name = "copilot",  group_index = 2 },
        { name = "luasnip",  group_index = 2 },
        { name = "buffer",   group_index = 2 },
        { name = "nvim_lua", group_index = 2 },
        { name = "path",     group_index = 2 },
      },
    },
  },

  -- golang
  {
    "andythigpen/nvim-coverage",
    ft = "go",
    config = function()
      require("coverage").setup({
        auto_reload = true,
        load_coverage_cb = function (ftype)
          vim.notify("Loaded " .. ftype .. " coverage")
        end,
        lang = {
          go = {
            coverage_file = "coverage.txt"
          }
        }
      })
    end,
  },
  {
    "nvim-neotest/neotest-go",
    ft = "go",
    dependencies = "nvim-neotest/neotest",
    config = function()
      -- get neotest namespace (api call creates or returns namespace)
      local neotest_ns = vim.api.nvim_create_namespace("neotest")
      vim.diagnostic.config({
        virtual_text = {
          format = function(diagnostic)
            local message =
            diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
            return message
          end,
        },
      }, neotest_ns)
      require("neotest").setup({
        -- your neotest config here
        adapters = {
          require("neotest-go"),
        },
      })
    end,
  },
  {
    "leoluz/nvim-dap-go",
    ft = "go",
    dependencies = "mfussenegger/nvim-dap",
    config = function(_, opts)
      require("dap-go").setup(opts)
    end
  },
  {
    "olexsmir/gopher.nvim",
    ft = "go",
    config = function(_, opts)
      require("gopher").setup(opts)
    end,
    build = function()
      vim.cmd [[silent! GoInstallDeps]]
    end,
  },

  -- plugin management
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "gopls",
        "goimports-reviser"
      }
    }
  },

  -- navigation
  {
    "justinmk/vim-sneak",
    keys = {"s", "S"},
    init = function()
      vim.g["sneak#label"] = 1
      vim.g["sneak#use_ic_scs"] = 1
    end,
  },
  {
    "nvim-tree/nvim-tree.lua",
     config = function()
      require("nvim-tree").setup({
        git = {
          enable = true,
        },
        renderer = {
          highlight_git = true,
          icons = {
            show = {
              git = true,
            },
          },
        },
        view = {
          width = 42,
        },

      })
     end,
  },
  {
    "nvim-telescope/telescope.nvim",
    opts = {
      defaults = {
        mappings = {
          i = {
            ["<C-u>"] = false
          },
        },
      }
    },
    dependencies = {
      {
        "biozz/whop.nvim",
        config = function()
          require("whop").setup({})
        end
      }
    },
    config = function()
      require("telescope").load_extension("whop")
    end,
    keys = {
      {
        "<C-p>",
        "<leader>tw",
      },
    },
    cmd = {"Telescope"}
  },
  {
    "https://git.sr.ht/~swaits/scratch.nvim",
    keys = { "<leader>sc" },
    cmd = {
      "Scratch",
      "ScratchSplit",
    },
    opts = {},
  },
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'
  },
  {
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateRight",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
    }
  },
  {
    "christoomey/vim-tmux-runner",
    init = function()
      vim.g["VtrPercentage"] = 30
    end,
    cmd = {
      "VtrSendCommandToRunner",
      "VtrFlushCommand",
      "VtrOpenRunner",
      "VtrKillRunner",
    }
  },

  -- general editing
  {
    "tpope/vim-surround",
    keys = {"cs", "ds"},
  },
  {
    "tpope/vim-repeat",
    keys = {"."},
  },
  {
    "terryma/vim-expand-region",
    keys = {"+"}
  },

  -- git
  {
    "tpope/vim-fugitive",
    cmd = {"Git"}
  },
  {
    "f-person/git-blame.nvim",
    lazy = false,
  },

  -- misc
  {
    "Pocco81/TrueZen.nvim",
    cmd = { "TZAtaraxis", "TZMinimalist" },
  },
  {
    'ruifm/gitlinker.nvim',
    dependencies = {'nvim-lua/plenary.nvim'},
    lazy = false,
    init = function()
      require("gitlinker").setup()
    end,
  },

  -- notes
  {
    "epwalsh/obsidian.nvim",
    event = {
      "BufReadPre " .. os.getenv("OBSIDIAN_VAULT_DIR") .. "/**.md",
      "BufNewFile " .. os.getenv("OBSIDIAN_VAULT_DIR") .. "/**.md",
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "hrsh7th/nvim-cmp",
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      require("obsidian").setup({
        dir = os.getenv("OBSIDIAN_VAULT_DIR"),
        note_id_func = function(title)
          if title ~= nil then
            return title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
          end
          -- If title is nil, suffix 4 random uppercase letters to the timestamp
          local suffix = ""
          for _ = 1, 4 do
            suffix = suffix .. string.char(math.random(65, 90))
          end
          return tostring(os.time()) .. "-" .. suffix
        end,

        -- drop daily notes into a subdirectory
        daily_notes = {
          folder = "daily",
        },
        templates = {
          subdir = "templates",
        },
        open_notes_in = "vsplit",
      })
      vim.keymap.set("n", "<C-p>", "<cmd>ObsidianQuickSwitch<CR>")
    end,
  },

  -- disabled
  {
    "NvChad/nvterm",
    enabled = false
  }
}
return plugins
