return {
  {
    "michaelrommel/nvim-silicon",
    cmd = "Silicon",
    lazy = true,
    opts = {
      font = "MonaspiceNe Nerd Font Mono=26",
      background = "#87f",
      theme = "OneHalfDark",
      no_window_controls = true,
      pad_vert = 80,
      pad_horiz = 50,
      output = function()
        return os.getenv "HOME" .. "/" .. os.date "!%Y-%m-%dT%H-%M-%SZ" .. "_code.png"
      end,
      window_title = function()
        return vim.fn.fnamemodify(vim.fn.bufname(vim.fn.bufnr()), ":~:.")
      end,
    },
  },
}
