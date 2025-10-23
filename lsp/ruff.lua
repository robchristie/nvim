---@type vim.lsp.Config
return {
    cmd = { 'ruff', 'server' },
    filetypes = { 'python' },
    root_markers = { 'pyproject.toml', 'ruff.toml', '.ruff.toml', '.git' },
    init_options = {
        settings = {
            configurationPreference = "filesystemFirst", -- prefer pyproject.toml
            -- Or provide inline config (overrides pyproject):
            configuration = { lint = { ignore = { "F821" } } }, -- use ty
            organizeImports = true,
            fixAll = true,
            showSyntaxErrors = true,
        },
    },
}
