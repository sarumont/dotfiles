-- Keymaps are automatically loaded on the VeryLazy event, after LazyVim's own
-- (https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua),
-- so anything set here wins. Full map with rationale: docs/nvim-keymaps.md
local map = vim.keymap.set

local function unmap(modes, lhs)
  for _, mode in ipairs(type(modes) == "table" and modes or { modes }) do
    pcall(vim.keymap.del, mode, lhs)
  end
end

-- general
map("n", ";", ":", { desc = "Command mode" })
map("i", "jk", "<ESC>", { desc = "Escape" })
map("n", "<C-c>", "<cmd>%y+<cr>", { desc = "Copy whole file" })

-- insert-mode cursor movement (from NvChad)
map("i", "<C-b>", "<ESC>^i", { desc = "Line start" })
map("i", "<C-e>", "<End>", { desc = "Line end" })
map("i", "<C-h>", "<Left>", { desc = "Left" })
map("i", "<C-l>", "<Right>", { desc = "Right" })
map("i", "<C-j>", "<Down>", { desc = "Down" })
map("i", "<C-k>", "<Up>", { desc = "Up" })

-- split navigation across tmux panes (herdr panes are handled by plugins/herdr.lua)
if vim.env.HERDR_PANE_ID == nil then
  map("n", "<C-h>", "<cmd>TmuxNavigateLeft<cr>", { desc = "Navigate left" })
  map("n", "<C-j>", "<cmd>TmuxNavigateDown<cr>", { desc = "Navigate down" })
  map("n", "<C-k>", "<cmd>TmuxNavigateUp<cr>", { desc = "Navigate up" })
  map("n", "<C-l>", "<cmd>TmuxNavigateRight<cr>", { desc = "Navigate right" })
end

-- comment toggle on <leader>/ (LazyVim uses it for grep; grep is on <leader>fw / <leader>sg)
map("n", "<leader>/", "gcc", { desc = "Toggle comment", remap = true })
map("x", "<leader>/", "gc", { desc = "Toggle comment", remap = true })

-- find: NvChad-style aliases for snacks pickers
map("n", "<leader>fw", function() Snacks.picker.grep() end, { desc = "Grep (cwd)" })
map("n", "<leader>fo", function() Snacks.picker.recent() end, { desc = "Recent files" })
map("n", "<leader>fa", function() Snacks.picker.files({ hidden = true, ignored = true }) end, { desc = "Find all files" })
map("n", "<leader>fz", function() Snacks.picker.lines() end, { desc = "Search buffer" })
map("n", "<leader>fh", function() Snacks.picker.help() end, { desc = "Help pages" })
map({ "n", "x" }, "<leader>fm", function() LazyVim.format({ force = true }) end, { desc = "Format" })

-- file tree
map("n", "<C-n>", "<cmd>Neotree toggle<cr>", { desc = "Toggle file tree" })

-- treesitter: jump to enclosing block start (replaces LazyVim's [b; buffers are on <S-h>/<S-l>)
map("n", "[b", function()
  local node = vim.treesitter.get_node()
  if not node then
    return
  end
  local cursor_row = vim.api.nvim_win_get_cursor(0)[1] - 1
  local current = node:parent()
  while current do
    local start_row, start_col = current:start()
    if start_row < cursor_row then
      vim.api.nvim_win_set_cursor(0, { start_row + 1, start_col })
      return
    end
    current = current:parent()
  end
end, { desc = "Enclosing block start" })

-- git: fugitive (replaces LazyVim's status/log pickers and GitHub PRs on these keys)
map("n", "<leader>gs", "<cmd>Git<cr>", { desc = "Git status (fugitive)" })
map("n", "<leader>gl", "<cmd>Git log<cr>", { desc = "Git log (fugitive)" })
map("n", "<leader>gc", "<cmd>Git commit<cr>", { desc = "Git commit" })
map("n", "<leader>gp", "<cmd>Git push<cr>", { desc = "Git push" })
map("n", "<leader>ga", "<cmd>Git commit --amend<cr>", { desc = "Git amend" })
map("n", "<leader>gup", "<cmd>Git up<cr>", { desc = "Git up (fetch + rebase)" })
map("n", "<leader>gbf", "<cmd>Git blame -w -M<cr>", { desc = "Git blame file" })

-- git: diffview
map("n", "<leader>gd", "<cmd>DiffviewOpen<cr>", { desc = "Diff working tree" })
map("n", "<leader>gD", "<cmd>DiffviewOpen origin/main<cr>", { desc = "Diff vs origin/main" })
map("n", "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", { desc = "File history" })
map("n", "<leader>gH", "<cmd>DiffviewFileHistory<cr>", { desc = "Repo history" })
map("n", "<leader>gx", "<cmd>DiffviewClose<cr>", { desc = "Close diffview" })

-- tests: NvChad-era aliases (LazyVim: <leader>tr nearest, <leader>tt file, <leader>td debug nearest)
map("n", "<leader>tn", function() require("neotest").run.run() end, { desc = "Run nearest test" })
map("n", "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end, { desc = "Run file tests" })
map("n", "<leader>df", function()
  require("neotest").run.run({ vim.fn.expand("%"), strategy = "dap" })
end, { desc = "Debug file tests" })

-- no terminal management in nvim: tmux/herdr own that
unmap({ "n", "t" }, "<c-/>")
unmap({ "n", "t" }, "<c-_>")
unmap("n", "<leader>ft")
unmap("n", "<leader>fT")
