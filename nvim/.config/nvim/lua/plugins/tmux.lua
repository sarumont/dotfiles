return {
  {
    "christoomey/vim-tmux-navigator",
    cmd = { "TmuxNavigateLeft", "TmuxNavigateRight", "TmuxNavigateUp", "TmuxNavigateDown" },
  },
  {
    "christoomey/vim-tmux-runner",
    init = function()
      vim.g["VtrPercentage"] = 30
    end,
    cond = function()
      return vim.env.HERDR_PANE_ID == nil
    end,
    cmd = {
      "VtrSendCommandToRunner",
      "VtrFlushCommand",
      "VtrOpenRunner",
      "VtrKillRunner",
    },
  },
}
