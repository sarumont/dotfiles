return {
  -- mapped in config/keymaps.lua (outside herdr only)
  {
    "christoomey/vim-tmux-navigator",
    cmd = { "TmuxNavigateLeft", "TmuxNavigateRight", "TmuxNavigateUp", "TmuxNavigateDown" },
  },
  {
    "christoomey/vim-tmux-runner",
    cond = function()
      return vim.env.HERDR_PANE_ID == nil
    end,
    init = function()
      vim.g.VtrPercentage = 30
    end,
    cmd = { "VtrSendCommandToRunner", "VtrFlushCommand", "VtrOpenRunner", "VtrKillRunner" },
    keys = {
      { "<leader>vp", "<cmd>VtrFlushCommand<cr><cmd>VtrSendCommandToRunner!<cr>", desc = "Runner: prompt command" },
      { "<leader>vrl", "<cmd>VtrSendCommandToRunner!<cr>", desc = "Runner: re-run last" },
      { "<leader>vq", "<cmd>VtrKillRunner<cr>", desc = "Runner: kill" },
    },
  },
}
