return {
  {
    "andythigpen/nvim-coverage",
    ft = "go",
    keys = {
      { "<leader>tcl", "<cmd>Coverage<cr>", desc = "Coverage: load" },
      { "<leader>tct", "<cmd>CoverageToggle<cr>", desc = "Coverage: toggle" },
      { "<leader>tcs", "<cmd>CoverageSummary<cr>", desc = "Coverage: summary" },
    },
    opts = {
      auto_reload = true,
      load_coverage_cb = function(ftype)
        vim.notify("Loaded " .. ftype .. " coverage")
      end,
      lang = { go = { coverage_file = "coverage.txt" } },
    },
  },
  {
    "folke/which-key.nvim",
    opts = { spec = { { "<leader>tc", group = "coverage" } } },
  },
}
