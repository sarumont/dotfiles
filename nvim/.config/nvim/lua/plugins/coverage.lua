return {

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
}
