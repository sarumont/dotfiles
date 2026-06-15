return {
  "bpross/review.nvim",
  lazy = false,
  config = function()
    require("review").setup()
  end,
  keys = {
    {
      "<leader>rc",
      function()
        require("review").add_comment()
      end,
      desc = "Add review comment",
    },
    {
      "<leader>ro",
      function()
        require("review").open_review()
      end,
      desc = "Open .review.md",
    },
    {
      "<leader>rs",
      function()
        require("review").show_comments()
      end,
      desc = "Refresh review comments",
    },
  },
}
