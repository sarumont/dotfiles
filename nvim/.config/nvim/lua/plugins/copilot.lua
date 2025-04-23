return {
  {
    "zbirenbaum/copilot.lua",
    event = "InsertEnter",
    opts = {
      -- Possible configurable fields can be found on:
      -- https://github.com/zbirenbaum/copilot.lua#setup-and-configuration
      suggestion = {
        enabled = false,
      },
      panel = {
        enabled = false,
      },
      filetypes = {
        go = true,
        ["*"] = false, -- disable for all other filetypes and ignore default `filetypes`
      },
    },
  },
  {
    "zbirenbaum/copilot-cmp",
    lazy = true,
    config = function()
      require("copilot_cmp").setup()
    end,
  },
}
