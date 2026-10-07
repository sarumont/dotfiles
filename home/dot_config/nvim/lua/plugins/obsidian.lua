local vault = vim.fn.expand(os.getenv("OBSIDIAN_VAULT_DIR") or "~/notes")

return {
  "obsidian-nvim/obsidian.nvim",
  version = "*",
  event = {
    "BufReadPre " .. vault .. "/**.md",
    "BufNewFile " .. vault .. "/**.md",
  },
  cmd = "Obsidian",
  keys = {
    { "<C-p>", "<cmd>Obsidian quick_switch<cr>", desc = "Obsidian: quick switch" },
  },
  opts = {
    workspaces = { { name = "vault", path = vault } },
    legacy_commands = false,
    completion = { blink = true, nvim_cmp = false },
    picker = { name = "snacks.pick" },
    note_id_func = function(title)
      if title ~= nil then
        return title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
      end
      -- untitled: timestamp plus 4 random uppercase letters
      local suffix = ""
      for _ = 1, 4 do
        suffix = suffix .. string.char(math.random(65, 90))
      end
      return tostring(os.time()) .. "-" .. suffix
    end,
    daily_notes = { folder = "daily" },
    templates = { folder = "templates" },
    open_notes_in = "vsplit",
  },
}
