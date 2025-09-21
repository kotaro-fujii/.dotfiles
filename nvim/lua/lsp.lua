-- ========== settings ==========
remap_options = { noremap = true, silent = true, buffer = bufnr }
vim.keymap.set('n', 'K', vim.lsp.buf.definition, opts)
vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)

vim.diagnostic.config({
    virtual_text = {
        prefix = "++++",
        spacing = 8,
    },
    signs = false,
    underline = true,
})

-- ========== enable server ==========
local servers = {
    "pylsp",
    "rust_analyzer",
    "markdown_oxide",
}

for _, server in ipairs(servers) do
    vim.lsp.enable(server)
end
