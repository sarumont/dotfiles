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

  -- go
  {
    "dreamsofcode-io/nvim-dap-go",
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
    "christoomey/vim-tmux-navigator",
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

  -- disabled
  {
    "NvChad/nvterm",
    enabled = false
  }
}
return plugins
