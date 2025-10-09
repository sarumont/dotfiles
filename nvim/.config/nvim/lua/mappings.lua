require "nvchad.mappings"

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- Telescope
map("n", "<leader>tw", ":Telescope whop<cr>", { desc = "telescope Whop" })

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

-- testing
map("n", "<leader>dn", function()
  require("neotest").run.run { strategy = "dap" }
end, { desc = "neotest Debug nearest test" })
map("n", "<leader>tn", function()
  require("neotest").run.run()
end, { desc = "neotest Run nearest test" })
map("n", "<leader>tf", function()
  require("neotest").run.run(vim.fn.expand "%")
end, { desc = "neotest Run all tests in file" })
map("n", "<leader>df", function()
  require("neotest").run.run(vim.fn.expand "%", { strategy = "dap" })
end, { desc = "neotest Debug all tests in file" })
map("n", "<leader>ts", ":Neotest summary<cr>", { desc = "neotest Open test summary panel" })
map("n", "<leader>to", ":Neotest output<cr>", { desc = "neotest Show test output" })
map("n", "<leader>top", ":Neotest output-panel<cr>", { desc = "neotest Show test output panel" })

-- debugging
map("n", "<leader>db", "<cmd> DapToggleBreakpoint <CR>", { desc = "dap Add breakpoint at line" })
map("n", "<leader>dr", "<cmd> DapToggleRepl <CR>", { desc = "dap Open Debugging console" })
map("n", "<leader>dso", "<cmd> DapStepOver <CR>", { desc = "dap Step over current line" })
map("n", "<leader>dsi", "<cmd> DapStepInto <CR>", { desc = "dap Step into current line" })
map("n", "<leader>dsu", "<cmd> DapStepOut <CR>", { desc = "dap Step out of current line" })

-- silicon.nvim
map("v", "<leader>sc", function()
  require("nvim-silicon").file()
end, { desc = "Silicon Copy code screenshot to file" })

-- editing
map("n", "<leader>J", "<cmd>TSJToggle<cr>", { desc = "general Split/Join line intelligently" })

-- Code coverage
map("n", "<leader>cl", "<cmd> Coverage <CR>", { desc = "coverage Load code coverage" })
map("n", "<leader>ct", "<cmd> CoverageToggle <CR>", { desc = "coverage Toggle code coverage display" })
map("n", "<leader>cs", "<cmd> CoverageSummary <CR>", { desc = "coverage Show code coverage summary" })
