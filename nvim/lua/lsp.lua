-- ========== settings ==========
remap_options = { noremap = true, silent = true, buffer = bufnr }
vim.keymap.set('n', 'K', vim.lsp.buf.definition, remap_options)
vim.keymap.set('n', 'gr', vim.lsp.buf.references, remap_options)

vim.diagnostic.config({
    virtual_text = false,
    virtual_lines = {
        only_current_line = false,
    },
    signs = false,
    underline = true,
})

-- ========== enable server ==========
local servers = {
    "pylsp",
    "rust_analyzer",
    "markdown_oxide",
    "bashls",
    "vimls",
    "tinymist",
}

for _, server in ipairs(servers) do
    vim.lsp.enable(server)
end
