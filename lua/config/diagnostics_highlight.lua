-- lua/diagnostics_highlight.lua
local M = {}

function M.apply()
  -- ensure truecolor
  vim.o.termguicolors = true

  -- your overrides
  vim.api.nvim_set_hl(0, "DiagnosticVirtualTextError", { fg = "#ff5f5f", bg = "#3a2020", bold = true })
  vim.api.nvim_set_hl(0, "DiagnosticVirtualTextWarn",  { fg = "#ffaf00", bg = "#3a2f00", bold = true })
  vim.api.nvim_set_hl(0, "DiagnosticVirtualTextInfo",  { fg = "#5fd7ff", bg = "#203040", italic = true })
  vim.api.nvim_set_hl(0, "DiagnosticVirtualTextHint",  { fg = "#87ff5f", bg = "#203020", italic = true })
end

return M
