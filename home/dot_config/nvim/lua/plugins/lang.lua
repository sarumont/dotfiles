return {
  -- gopls: LazyVim's lang.go enables every inlay hint; keep the previous selection
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        gopls = {
          settings = {
            gopls = {
              hints = {
                assignVariableTypes = false,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = false,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
              },
            },
          },
        },
      },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        go = { "gofmt", "goimports", "goimports-reviser" },
        yaml = { "yamlfmt" },
      },
    },
  },
  {
    "mason-org/mason.nvim",
    opts = { ensure_installed = { "goimports-reviser", "yamlfmt" } },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "comment", "css", "html", "javascript", "typescript", "java",
        "cmake", "bash", "dockerfile", "terraform",
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    opts = { max_lines = 0, multiline_threshold = 20, trim_scope = "outer" },
  },
  -- Copilot only for Go (completion source in blink via the ai.copilot extra)
  {
    "zbirenbaum/copilot.lua",
    opts = { filetypes = { go = true, ["*"] = false } },
  },
  {
    "nvim-neotest/neotest",
    opts = {
      adapters = {
        ["neotest-golang"] = {
          warn_test_name_dupes = false,
          go_test_args = { "-v", "-race", "-count=1", "-cover" },
        },
      },
    },
  },
}
