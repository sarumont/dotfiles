require "nvchad.mappings"

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- navigation
map("n", "<C-h>", ":TmuxNavigateLeft<cr>", { desc = "navigate left" })
map("n", "<C-l>", ":TmuxNavigateRight<cr>", { desc = "navigate right" })
map("n", "<C-k>", ":TmuxNavigateUp<cr>", { desc = "navigate up" })
map("n", "<C-j>", ":TmuxNavigateDown<cr>", { desc = "navigate down" })

-- tmux runner
map(
  "n",
  "<leader>vp",
  ":VtrFlushCommand<cr>:VtrSendCommandToRunner!<cr>",
  { desc = "tmux Prompt command to execute in runner" }
)
map("n", "<leader>vrl", ":VtrSendCommandToRunner! <cr>", { desc = "tmux Re-run last command in runner" })
map("n", "<leader>vq", ":VtrKillRunner <cr>", { desc = "tmux Kill the runner" })

map("n", "<leader>jc", function()
  require("treesitter-context").go_to_context(vim.v.count1)
end, { desc = "navigate to the top of the context", silent = true })
