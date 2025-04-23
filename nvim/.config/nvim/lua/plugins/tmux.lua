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
    cmd = {
      "VtrSendCommandToRunner",
      "VtrFlushCommand",
      "VtrOpenRunner",
      "VtrKillRunner",
    },
  },
}
