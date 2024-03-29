local M = {}

M.copilot = {
  -- Possible configurable fields can be found on:
  -- https://github.com/zbirenbaum/copilot.lua#setup-and-configuration
  suggestion = {
    enabled = false
  },
  panel = {
    enabled = false
  },
  filetypes = {
    go = true,
    ["*"] = false, -- disable for all other filetypes and ignore default `filetypes`
  }
}

return M
