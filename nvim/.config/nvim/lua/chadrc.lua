---@type ChadrcConfig 
local M = {}

M.funcs = {
  fileInfo = function()
    local filename = (vim.fn.expand "%" == "" and " Empty") or " %t "
    return "%#St_file_sep#█" .. "%#St_file_txt#" .. filename .. "%#St_sep_r#█ %#ST_EmptySpace#"
  end
}

M.base46 = {
  theme = 'onenord',
}

M.ui = {
  theme = 'onenord',
  tabufline = {
    enabled = false
  },
  statusline = {
    theme = "minimal",
    overriden_modules = function(modules)
      modules[2] = M.funcs.fileInfo()
    end,
  },
}

return M
