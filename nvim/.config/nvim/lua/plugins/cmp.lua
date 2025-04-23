return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "zbirenbaum/copilot-cmp",
    config = function()
      require("copilot_cmp").setup()
    end,
  },
  opts = {
    sources = {
      { name = "copilot", group_index = 1 },
      { name = "nvim_lsp" },
      { name = "luasnip" }, -- For luasnip users.
      { name = "buffer" },
    },
  },
}
