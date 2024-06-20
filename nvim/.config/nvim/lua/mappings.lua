require "nvchad.mappings"

local map = vim.keymap.set
local nomap = vim.keymap.del

-- Disable mappings
nomap("n", "<tab>")
nomap("n", "<S-tab>")
nomap("n", "<leader>x")

-- disable terminal mappings
nomap("n", "<leader>v")
nomap("n", "<leader>h")

-- general
map("i", "jk", "<ESC>", { desc = "general jk to escape" })

-- navigation
map("n", "<C-h>", ":TmuxNavigateLeft<cr>", {desc = "navigate left"})
map("n", "<C-l>", ":TmuxNavigateRight<cr>", {desc = "navigate right"})
map("n", "<C-k>", ":TmuxNavigateUp<cr>", {desc = "navigate up"})
map("n", "<C-j>", ":TmuxNavigateDown<cr>", {desc = "navigate down"})

-- fugitive
map("n", "<leader>gd", ":Git diff <cr>", {desc = "Git diff of the entire buffer"})
map("n", "<leader>gl", ":Git log <cr>", {desc = "Git log"})
map("n", "<leader>gs", ":Git <cr>", {desc = "Git status"})
map("n", "<leader>gbf", ":Git blame -w -M<cr>", {desc = "Git blame for the entire file"})
map("n", "<leader>gc", ":Git commit<cr>", {desc = "Git commit"})
map("n", "<leader>gp", ":Git push<cr>", {desc = "Git push"})
map("n", "<leader>ga", ":Git commit --amend<cr>", {desc = "Git amend a commit"})
map("n", "<leader>gup", ":Git up <cr>", {desc = "Git pull"})

-- tmux
map("n", "<leader>vp", ":VtrFlushCommand<cr>:VtrSendCommandToRunner!<cr>", { desc = "tmux Prompt command to execute in runner"})
map("n", "<leader>vrl", ":VtrSendCommandToRunner! <cr>", { desc = "tmux Re-run last command in runner"})
map("n", "<leader>vq", ":VtrKillRunner <cr>", { desc = "tmux Kill the runner"})

-- testing
map("n", "<leader>dn",
  function()
    require("neotest").run.run({ strategy = "dap" })
  end,
  {desc = "neotest Debug nearest test"})
map("n", "<leader>tn",
  function()
    require("neotest").run.run()
  end,
  {desc = "neotest Run nearest test"})
map("n", "<leader>tf",
  function()
    require("neotest").run.run(vim.fn.expand("%"))
  end,
  {desc = "neotest Run all tests in file"})
map("n", "<leader>df",
  function()
    require("neotest").run.run(vim.fn.expand("%"), { strategy = "dap" })
  end,
  {desc = "neotest Debug all tests in file"})
map("n", "<leader>tp", ":Neotest panel<cr>", {desc = "neotest Open test summary panel"})
map("n", "<leader>to", ":Neotest output<cr>", {desc = "neotest Show test output"})
map("n", "<leader>top", ":Neotest output-panel<cr>", {desc = "neotest Show test output panel"})

-- debugging
map("n", "<leader>db", "<cmd> DapToggleBreakpoint <CR>", {desc = "dap Add breakpoint at line"})
map("n", "<leader>dr", "<cmd> DapToggleRepl <CR>", {desc = "dap Open Debugging console"})
map("n", "<leader>dso", "<cmd> DapStepOver <CR>", {desc = "dap Step over current line"})
map("n", "<leader>dsi", "<cmd> DapStepInto <CR>", {desc = "dap Step into current line"})
map("n", "<leader>dsu", "<cmd> DapStepOut <CR>", {desc = "dap Step out of current line"})
map("n", "<leader>dx",
  function()
    require('dap').terminate() 
    require('dap').repl.close()
  end,
  {desc = "dap Terminate debugging"})
map("n", "<leader>dc",
  function()
    require('dap').continue() 
    require('dap').repl.open()
  end,
  {desc = "dap Begin or resume debugging test"})
map("n", "<leader>dl",
  function()
    require('dap').run_last() 
    require('dap').repl.open()
  end,
  {desc = "dap Debug last test"})
map("n", "<leader>dh",
  function()
    require('dap.ui.widgets').hover()
  end,
  {desc = "dap Show dap hover widget"})
map("n", "<leader>dp",
  function()
    require('dap.ui.widgets').preview()
  end,
  {desc = "dap Show dap preview widget"})
map("n", "<leader>df",
  function()
    local widgets = require('dap.ui.widgets') 
    widgets.centered_float(widgets.frames)
  end,
  {desc = "dap Show debug frames"})
map("n", "<leader>dv",
  function()
    local widgets = require('dap.ui.widgets') 
    widgets.centered_float(widgets.scopes)
  end,
  {desc = "dap Show debug scopes"})

-- M.dap_go = {
--   plugin = true,
--   n = {
--     map("n", "<leader>dgt",
--       function()
--         require('dap-go').debug_test()
--         require('dap').repl.open()
--         {desc = "neotest nd,})
--     }
--   }
-- }

-- Gopher
map("n", "<leader>gsj", "<cmd> GoTagAdd json <CR>", {desc = "gopher Add json struct tags"})
map("n", "<leader>gst", "<cmd> GoTagAdd otel <CR>", {desc = "gopher Add Open Telemetry struct tags"})
map("n", "<leader>gie", "<cmd> GoIfErr <CR>", {desc = "gopher Add Go try-catch block"})

-- Code coverage
map("n", "<leader>cl", "<cmd> Coverage <CR>", {desc = "coverage Load code coverage"})
map("n", "<leader>ct", "<cmd> CoverageToggle <CR>", {desc = "coverage Toggle code coverage display"})
map("n", "<leader>cs", "<cmd> CoverageSummary <CR>", {desc = "coverage Show code coverage summary"})

-- Obsidian
map("n", "<leader>on", ":ObsidianNew ", {desc = "obsidian Obsidian new note"})
map("n", "<leader>ot", "<cmd>ObsidianToday<cr>", {desc = "obsidian Obsidian note for today"})
map("n", "<leader>oy", "<cmd>ObsidianYesterday<cr>", {desc = "obsidian Obsidian note for yesterday"})

-- use telescope for some LSP things instead of the default (quickfix window)
map("n", "gi", "<cmd> Telescope lsp_implementations <CR>", {desc = "LSP implementations" })
map("n", "gr", "<cmd> Telescope lsp_references <CR>", {desc = "LSP references" })

-- telescope
map("n", "<leader>tw", "<cmd> Telescope whop <CR>", {desc = "telescope Whop" })
map("n", "<C-p>", "<cmd> Telescope find_files <CR>", {desc = "telescope Find files" })

-- scratch pad
map("n", "<leader>sc", "<cmd> ScratchPad <CR>", {desc = "misc Scratchpad" })

-- trouble.nvim
map("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>", {desc = "trouble Toggle diagnostics"})
map("n", "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", {desc = "trouble Toggle trouble diagnostics (current buffer)"})
map("n", "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>", {desc = "trouble Toggle Symbols"})
map("n", "<leader>cl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", {desc = "trouble LSP Definitions / references / ..."})
map("n", "<leader>xL", "<cmd>Trouble loclist toggle<cr>", {desc = "trouble Location List"})
map("n", "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", {desc = "trouble Quickfix List"})
