local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    go = { "gofmt", "goimports", "goimports-reviser" },
    yaml = { "yamlfmt" },
    markdown = { "markdownfmt" },
  },

  format_after_save = {
    -- format_on_save = {
    -- These options will be passed to conform.format()
    -- timeout_ms = 2000,
    async = true,
    lsp_fallback = true,
  },
}

return options
