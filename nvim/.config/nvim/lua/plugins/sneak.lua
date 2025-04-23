return {
    "justinmk/vim-sneak",
    keys = { "s", "S" },
    init = function()
      vim.g["sneak#label"] = 1
      vim.g["sneak#use_ic_scs"] = 1
    end,
  }

