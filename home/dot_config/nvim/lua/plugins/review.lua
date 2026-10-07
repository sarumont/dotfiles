return {
  "bpross/review.nvim",
  keys = {
    { "<leader>rc", function() require("review").add_comment() end, desc = "Review: add comment" },
    { "<leader>ro", function() require("review").open_review() end, desc = "Review: open .review.md" },
    { "<leader>rs", function() require("review").show_comments() end, desc = "Review: refresh comments" },
  },
  opts = {},
}
