return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "j-hui/fidget.nvim",
  },
  config = function()
    require("nvchad.configs.lspconfig").defaults()

    local servers = { "gopls", "kotlin_language_server" }
    vim.lsp.enable(servers)

    -- golang
    vim.lsp.config("gopls", {
      settings = {
        gopls = {
          semanticTokens = true,
          usePlaceholders = true,
          analyses = {
            unusedparams = true,
          },
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
    })
  end,
}
