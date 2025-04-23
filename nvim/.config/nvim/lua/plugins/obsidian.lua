return {
  "obsidian-nvim/obsidian.nvim",
  event = {
    "BufReadPre " .. os.getenv "OBSIDIAN_VAULT_DIR" .. "/**.md",
    "BufNewFile " .. os.getenv "OBSIDIAN_VAULT_DIR" .. "/**.md",
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "hrsh7th/nvim-cmp",
    "nvim-telescope/telescope.nvim",
  },
  config = function()
    require("obsidian").setup {
      dir = os.getenv "OBSIDIAN_VAULT_DIR",
      note_id_func = function(title)
        if title ~= nil then
          return title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
        end
        -- If title is nil, suffix 4 random uppercase letters to the timestamp
        local suffix = ""
        for _ = 1, 4 do
          suffix = suffix .. string.char(math.random(65, 90))
        end
        return tostring(os.time()) .. "-" .. suffix
      end,

      -- drop daily notes into a subdirectory
      daily_notes = {
        folder = "daily",
      },
      templates = {
        subdir = "templates",
      },
      open_notes_in = "vsplit",
    }
    vim.keymap.set("n", "<C-p>", "<cmd>ObsidianQuickSwitch<CR>")
  end,
}
