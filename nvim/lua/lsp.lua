-- ========== functions ==========
-- toggle representation of diagnostics
local function toggle_diagnostics()
  local config = vim.diagnostic.config()

  if config.virtual_text == false then
    vim.diagnostic.config({
      virtual_text = {
        prefix = "+",
        spacing = 8,
      },
      virtual_lines = false,
    })
  elseif config.virtual_lines == false then
    vim.diagnostic.config({
      virtual_text = false,
      virtual_lines = {
        only_current_line = false,
      },
    })
  else
    vim.diagnostic.config({
      virtual_text = false,
      virtual_lines = false,
    })
  end
end

-- enable servers
local function enable_servers()
    local servers = {
        "pyright",
        "rust_analyzer",
        "markdown_oxide",
        "bashls",
        "vimls",
        "tinymist",
    }

    for _, server in ipairs(servers) do
        vim.lsp.enable(server)
    end
end

-- ========== settings ==========
remap_options = { noremap = true, silent = true, buffer = bufnr }
vim.keymap.set('n', 'K', vim.lsp.buf.definition, remap_options)
vim.keymap.set('n', 'gr', vim.lsp.buf.references, remap_options)
vim.keymap.set('n', '<C-t>', toggle_diagnostics, remap_options)
vim.keymap.set('n', '<leader>p', enable_servers, remap_options)

vim.diagnostic.config({
    virtual_text = false,
    virtual_lines = {
        only_current_line = false,
    },
    signs = false,
    underline = true,
})
enable_servers()
