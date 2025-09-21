-- remap function
local function on_attach(client, bufnr)
  local opts = { noremap = true, silent = true, buffer = bufnr }

  vim.keymap.set('n', 'K', vim.lsp.buf.definition, opts)
  -- vim.keymap.set('n', 'H', vim.lsp.buf.hover, opts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
end

vim.diagnostic.config({
  virtual_text = {
    prefix = "++++",
    spacing = 8,
  },
  signs = false,
  underline = true,
})

-- enable server
vim.lsp.enable('pylsp')
