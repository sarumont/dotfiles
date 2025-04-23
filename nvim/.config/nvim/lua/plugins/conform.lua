return {
  "stevearc/conform.nvim",
  event = "BufWritePre",
  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
      go = { "gofmt", "goimports", "goimports-reviser" },
      yaml = { "yamlfmt" },
    },

    format_after_save = {
      async = true,
      lsp_fallback = true,
    },
  },
}
