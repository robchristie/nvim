-- Yank highlight
vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})

-- Follow buffer (window-local cwd)
vim.g.auto_lcd = vim.g.auto_lcd ~= false
vim.api.nvim_create_autocmd("BufEnter", {
    desc = "Set window-local cwd to current buffer's dir",
    group = vim.api.nvim_create_augroup("auto-lcd", { clear = true }),
    callback = function(args)
        if not vim.g.auto_lcd then
            return
        end

        if vim.bo[args.buf].buftype ~= "" then
            return
        end

        local name = vim.api.nvim_buf_get_name(args.buf)
        if name == "" then
            return
        end

        local dir = vim.fn.fnamemodify(name, ":p:h")
        if dir == "" then
            return
        end

        vim.cmd("silent! lcd " .. vim.fn.fnameescape(dir))
    end,
})

local lsp_highlight_augroup = vim.api.nvim_create_augroup('lsp-highlight', { clear = false })
local lsp_detach_augroup = vim.api.nvim_create_augroup('lsp-detach', { clear = true })

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
    callback = function(event)
        local map = function(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
        end

        -- defaults:
        -- https://neovim.io/doc/user/news-0.11.html#_defaults

        map("gl", vim.diagnostic.open_float, "Open Diagnostic Float")
        map("K", vim.lsp.buf.hover, "Hover Documentation")
        map("gs", vim.lsp.buf.signature_help, "Signature Documentation")
        map("<leader>la", vim.lsp.buf.code_action, "Code Action")
        map("<leader>lr", vim.lsp.buf.rename, "Rename all references")
        map("<leader>v", "<cmd>vsplit | lua vim.lsp.buf.definition()<cr>", "Goto Definition in Vertical Split")

        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
            -- When cursor stops moving: Highlights all instances of the symbol under the cursor
            -- When cursor moves: Clears the highlighting
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                buffer = event.buf,
                group = lsp_highlight_augroup,
                callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                buffer = event.buf,
                group = lsp_highlight_augroup,
                callback = vim.lsp.buf.clear_references,
            })

            -- When LSP detaches: Clears the highlighting
            vim.api.nvim_create_autocmd('LspDetach', {
                group = lsp_detach_augroup,
                buffer = event.buf,
                callback = function(event2)
                    vim.lsp.buf.clear_references()
                    vim.api.nvim_clear_autocmds { group = lsp_highlight_augroup, buffer = event2.buf }
                end,
            })
        end
    end,

})
