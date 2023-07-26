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
        "markdown",
        "markdown_inline",
        "yaml",

        -- real languages
        "go",
        "java",
        "cmake",

        -- utils
        "bash",
        "dockerfile",
        "terraform",
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "plugins.configs.lspconfig"
      require "custom.configs.lspconfig"
    end,
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    ft = {"go", "lua"},
    opts = function()
      return require "custom.configs.null-ls"
    end,
  },
  {
    "mfussenegger/nvim-dap",
    init = function()
      require("core.utils").load_mappings("dap")
    end
  },
  {
    "nvim-neotest/neotest",
    init = function()
      require("core.utils").load_mappings("neotest")
    end,
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-go"),
        },
      })
    end,
  },

  -- Copilot
  {
    "zbirenbaum/copilot.lua",
    event = "InsertEnter",
    opts = function()
      return require "custom.configs.copilot"
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
    init = function()
      require("core.utils").load_mappings("coverage")
    end,
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
    "leoluz/nvim-dap-go",
    ft = "go",
    dependencies = "mfussenegger/nvim-dap",
    config = function(_, opts)
      require("dap-go").setup(opts)
      require("core.utils").load_mappings("dap_go")
    end
  },
  {
    "olexsmir/gopher.nvim",
    ft = "go",
    config = function(_, opts)
      require("gopher").setup(opts)
      require("core.utils").load_mappings("gopher")
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
    "phaazon/hop.nvim",
    cmd = { "HopWordBC", "HopWordAC", "HopLineBC", "HopLineAC", "HopChar2AC", "HopChar2BC" },
    config = function(_)
      require 'hop'.setup {}
    end,
  },
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
    }
  },
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'
  },
  {
    "christoomey/vim-tmux-navigator",
    lazy = false,
    init = function()
      vim.g["VtrPercentage"] = 30
    end,
  },
  {
    "christoomey/vim-tmux-runner",
    lazy = false,
  },

  -- general editing
  {
    "tpope/vim-surround",
    keys = {"cs"},
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

  -- misc
  {
    "Pocco81/TrueZen.nvim",
    cmd = { "TZAtaraxis", "TZMinimalist" },
  },

  -- notes
  {
    "epwalsh/obsidian.nvim",
    lazy = true,
    event = { "BufReadPre " .. os.getenv("OBSIDIAN_VAULT_DIR") .. "/**.md" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "hrsh7th/nvim-cmp",
      "nvim-telescope/telescope.nvim",
    },
    opts = {
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
    },
    config = function(_, opts)
      require("core.utils").load_mappings("obsidian")
      require("obsidian").setup(opts)

      -- Optional, override the 'gf' keymap to utilize Obsidian's search functionality.
      -- see also: 'follow_url_func' config option below.
      vim.keymap.set("n", "gf", function()
        if require("obsidian").util.cursor_on_markdown_link() then
          return "<cmd>ObsidianFollowLink<CR>"
        else
          return "gf"
        end
      end, { noremap = false, expr = true })
    end,
  },

  -- disabled
  {
    "NvChad/nvterm",
    enabled = false
  }
}
return plugins
