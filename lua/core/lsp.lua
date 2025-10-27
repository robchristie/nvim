vim.lsp.enable({
    "gopls",
    "lua_ls",
    "ruff",
    "ty",
    "clangd",
    "bashls",
    "yamlls",
    "tombi", --TOML
    "neocmake",
})

vim.diagnostic.config({
    virtual_lines = { current_line = true, },
    --virtual_lines = false, -- activate via function later so can toggle virtual_text
    virtual_text = false,
    --virtual_text = {
    --    spacing = 2,
    --    prefix = "●",
    --    format = function(d)
    --        local msg = d.message:gsub("%s+", " ") -- collapse whitespace/newlines
    --        local max = 40                         -- tune this
    --        return (#msg > max) and (msg:sub(1, max - 1) .. "…") or msg
    --    end,
    --},
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    float = {
        border = "rounded",
        source = true,
    },
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "󰅚 ",
            [vim.diagnostic.severity.WARN] = "󰀪 ",
            [vim.diagnostic.severity.INFO] = "󰋽 ",
            [vim.diagnostic.severity.HINT] = "󰌶 ",
        },
        numhl = {
            [vim.diagnostic.severity.ERROR] = "ErrorMsg",
            [vim.diagnostic.severity.WARN] = "WarningMsg",
        },
    },
})

-- open the float on demand (will mostly use virtual_lines)
vim.keymap.set("n", "<leader>df", function()
    local _, w = vim.diagnostic.open_float(nil,
        { focus = false, scope = "line", border = "rounded" })
    if w then
        vim.wo[w].wrap = true; vim.wo[w].linebreak = true
    end
end, { desc = "Diagnostics float (wrapped)" })

-- -- Hybrid diagnostics: virtual_text globally, virtual_lines only on current line
-- local ns = vim.api.nvim_create_namespace("diagnostics_dynamic_lines")
-- -- Update display depending on cursor location
-- local function update_diagnostics()
--   local bufnr = vim.api.nvim_get_current_buf()
--   local line = vim.api.nvim_win_get_cursor(0)[1] - 1
-- 
--   -- Clear previous custom diagnostics
--   vim.diagnostic.reset(ns, bufnr)
-- 
--   -- Get diagnostics for current line
--   local diags = vim.diagnostic.get(bufnr, { lnum = line })
--   if #diags == 0 then return end
-- 
--   -- Redraw only those diagnostics as virtual_lines
--   vim.diagnostic.set(ns, bufnr, diags, {
--     virtual_lines = { only_current_line = true },
--     virtual_text = false,
--   })
-- end
-- 
-- -- Autocmd: update when cursor on line
-- vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
--   callback = update_diagnostics,
-- })
--
vim.api.nvim_create_user_command("LspClients", function()
  local clients = vim.lsp.get_clients({bufnr=0})
  if vim.tbl_isempty(clients) then
    print("No LSP clients attached")
    return
  end
  for _, c in ipairs(clients) do
    print(("[%s] %s"):format(c.id, c.name))
    print("  cmd:", table.concat(c.cmd or {}, " "))
    print("  formatting:", c.server_capabilities.documentFormattingProvider and "✓" or "–")
    print("  code actions:", c.server_capabilities.codeActionProvider and "✓" or "–")
  end
end, {})

local function ruff_client_for_buf(bufnr)
  bufnr = bufnr or 0
  local clients = vim.lsp.get_clients({ bufnr = bufnr, name = "ruff" })
  return clients[1]
end

local function ruff_apply_organize_imports(bufnr)
  bufnr = bufnr or 0
  local client = ruff_client_for_buf(bufnr)
  if not client then
    vim.notify("Ruff client not attached", vim.log.levels.WARN)
    return
  end

  -- Use the buffer's changedtick as the LSP version
  local version = vim.api.nvim_buf_get_changedtick(bufnr)
  local params = {
    command = "ruff.applyOrganizeImports",
    arguments = {
      {
        uri = vim.uri_from_bufnr(bufnr),
        version = version,
      },
    },
  }

  client.request("workspace/executeCommand", params, function(err)
    if err then
      vim.notify("Ruff organize imports failed: " .. tostring(err.message or err), vim.log.levels.ERROR)
    end
  end, bufnr)
end

-- Keymap (optional)
vim.keymap.set("n", "<leader>oi", function() ruff_apply_organize_imports(0) end,
  { desc = "Ruff: Organize imports" })

-- Save hook (optional)
--vim.api.nvim_create_autocmd("BufWritePre", {
--  pattern = "*.py",
--  callback = function(args)
--    ruff_apply_organize_imports(args.buf)
--    vim.lsp.buf.format({
--      async = false,
--      filter = function(c) return c.name == "ruff" end,
--    })
--  end,
--})

