---@type vim.lsp.Config
return {
  cmd = { 'ty', 'server' },
  filetypes = { 'python' },
  root_markers = { 'ty.toml', 'pyproject.toml', '.git' },
  on_attach = function(client) client.server_capabilities.documentFormattingProvider = false end,
}
