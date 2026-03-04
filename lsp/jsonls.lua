---@type vim.lsp.Config
return {
  cmd = { "vscode-json-language-server", "--stdio" },
  filetypes = { "json", "jsonc" },
  root_markers = { ".git" },
  single_file_support = true,
  init_options = {
    provideFormatter = false,
  },
  settings = {
    json = {
      validate = { enable = true },
      schemaDownload = { enable = true },
      format = { enable = false },
      schemas = (function()
        local ok, schemastore = pcall(require, "schemastore")
        if not ok then
          return nil
        end
        return schemastore.json.schemas()
      end)(),
    },
  },
}
