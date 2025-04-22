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
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require "nvchad.configs.gitsigns"
      require "configs.gitsigns"
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    lazy = false,
    config = function()
      require("treesitter-context").setup {
        separator = "─",
      }
      vim.cmd [[hi TreesitterContextLineNumberBottom gui=underline]]
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    init = function()
      textobjects = {
        move = {
          enable = true,
          set_jumps = true, -- whether to set jumps in the jumplist
          goto_next_start = {
            ["]m"] = "@function.outer",
            ["]]"] = { query = "@class.outer", desc = "Next class start" },
            --
            -- You can use regex matching (i.e. lua pattern) and/or pass a list in a "query" key to group multiple queries.
            ["]o"] = "@loop.*",
            -- ["]o"] = { query = { "@loop.inner", "@loop.outer" } }
            --
            -- You can pass a query group to use query from `queries/<lang>/<query_group>.scm file in your runtime path.
            -- Below example nvim-treesitter's `locals.scm` and `folds.scm`. They also provide highlights.scm and indent.scm.
            ["]s"] = { query = "@local.scope", query_group = "locals", desc = "Next scope" },
            ["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
          },
          goto_next_end = {
            ["]M"] = "@function.outer",
            ["]["] = "@class.outer",
          },
          goto_previous_start = {
            ["[m"] = "@function.outer",
            ["[["] = "@class.outer",
          },
          goto_previous_end = {
            ["[M"] = "@function.outer",
            ["[]"] = "@class.outer",
          },
          -- Below will go to either the start or the end, whichever is closer.
          -- Use if you want more granular movements
          -- Make it even more gradual by adding multiple queries and regex.
          goto_next = {
            ["]d"] = "@conditional.outer",
          },
          goto_previous = {
            ["[d"] = "@conditional.outer",
          },
        },
      }
    end,
  },
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    opts = require "configs.conform",
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
    },
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
    end,
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
        { name = "copilot", group_index = 2 },
        { name = "luasnip", group_index = 2 },
        { name = "buffer", group_index = 2 },
        { name = "nvim_lua", group_index = 2 },
        { name = "path", group_index = 2 },
      },
    },
  },

  -- Avante
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = false,
    version = false, -- set this if you want to always pull the latest change
    opts = {
      provider = "copilot",
    },
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = "make",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
      "zbirenbaum/copilot.lua",
      {
        -- support for image pasting
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = true,
          },
        },
      },
      {
        -- Make sure to set this up properly if you have lazy=true
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
  },

  -- golang
  {
    "andythigpen/nvim-coverage",
    ft = "go",
    keys = { "<leader>cl", "<leader>ct", "<leader>cs" },
    config = function()
      require("coverage").setup {
        auto_reload = true,
        load_coverage_cb = function(ftype)
          vim.notify("Loaded " .. ftype .. " coverage")
        end,
        lang = {
          go = {
            coverage_file = "coverage.txt",
          },
        },
      }
    end,
  },
  {
    "nvim-neotest/neotest-go",
    ft = "go",
    dependencies = "nvim-neotest/neotest",
    config = function()
      -- get neotest namespace (api call creates or returns namespace)
      local neotest_ns = vim.api.nvim_create_namespace "neotest"
      vim.diagnostic.config({
        virtual_text = {
          format = function(diagnostic)
            local message = diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
            return message
          end,
        },
      }, neotest_ns)
      require("neotest").setup {
        -- your neotest config here
        adapters = {
          require "neotest-go",
        },
      }
    end,
  },
  {
    "leoluz/nvim-dap-go",
    ft = "go",
    dependencies = "mfussenegger/nvim-dap",
    config = function(_, opts)
      require("dap-go").setup(opts)
    end,
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
        "goimports-reviser",
        "prettier",
        "stylua",
        "yamlfmt",
        "yamllint",
      },
    },
  },

  -- navigation
  {
    "justinmk/vim-sneak",
    keys = { "s", "S" },
    init = function()
      vim.g["sneak#label"] = 1
      vim.g["sneak#use_ic_scs"] = 1
    end,
  },
  {
    "nvim-tree/nvim-tree.lua",
    config = function()
      require("nvim-tree").setup {
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
      }
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    opts = {
      defaults = {
        mappings = {
          i = {
            ["<C-u>"] = false,
          },
        },
      },
    },
    dependencies = {
      {
        "biozz/whop.nvim",
        config = function()
          require("whop").setup {
            commands = {
              {
                name = "JWT Decode",
                cmd = [[%!jq -r -R 'split(".") | .[0],.[1] | @base64d | fromjson']],
              },
            },
          }
        end,
      },
    },
    keys = {
      {
        "<C-p>",
        "<leader>tw",
      },
    },
    cmd = { "Telescope" },
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
    build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release",
  },
  {
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateRight",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
    },
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
    },
  },

  -- general editing
  {
    "tpope/vim-surround",
    keys = { "cs", "ds" },
  },
  {
    "tpope/vim-repeat",
    keys = { "." },
  },
  {
    "terryma/vim-expand-region",
    keys = { "+" },
  },

  -- git
  {
    "tpope/vim-fugitive",
    cmd = { "Git" },
  },

  -- misc
  {
    "Pocco81/TrueZen.nvim",
    cmd = { "TZAtaraxis", "TZMinimalist" },
  },
  {
    "ruifm/gitlinker.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    lazy = false,
    init = function()
      require("gitlinker").setup()
    end,
  },

  -- notes
  {
    "epwalsh/obsidian.nvim",
    event = {
      "BufReadPre " .. os.getenv "OBSIDIAN_VAULT_DIR" .. "/**.md",
      "BufNewFile " .. os.getenv "OBSIDIAN_VAULT_DIR" .. "/**.md",
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "hrsh7th/nvim-cmp",
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      require("obsidian").setup {
        dir = os.getenv "OBSIDIAN_VAULT_DIR",
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
      }
      vim.keymap.set("n", "<C-p>", "<cmd>ObsidianQuickSwitch<CR>")
    end,
  },

  -- sex appeal
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      -- add any options here
    },
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      "rcarriga/nvim-notify",
    },
    config = function()
      require("noice").setup {
        lsp = {
          -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
          },
        },
        -- you can enable a preset for easier configuration
        presets = {
          bottom_search = true, -- use a classic bottom cmdline for search
          command_palette = true, -- position the cmdline and popupmenu together
          long_message_to_split = true, -- long messages will be sent to a split
          inc_rename = false, -- enables an input dialog for inc-rename.nvim
          lsp_doc_border = false, -- add a border to hover docs and signature help
        },
      }
    end,
  },

  -- disabled
  {
    "NvChad/nvterm",
    enabled = false,
  },
}
return plugins
