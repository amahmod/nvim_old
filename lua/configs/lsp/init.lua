local status_ok, _ = pcall(require, 'lspconfig')
if not status_ok then return end

local M = {}

local function lsp_highlight_document(client)
  -- Set autocommands conditional on server_capabilities
  if client.resolved_capabilities.document_highlight then
    vim.api.nvim_exec(
      [[
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]], false
    )
  end
end

function M.config()

  local servers = {
    'sumneko_lua',
    'cssls',
    'html',
    'emmet_ls',
    'jsonls',
    'yamlls',
    'dockerls',
    'tsserver',
    'gopls',
    'null-ls',
    'diagnosticls',
    'sqlls',
    'svelte',
    'volar',
  }

  -- Floating border
  local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
  function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
    opts = opts or {}
    opts.border = opts.border or {{' ', 'FloatBorder'}}
    return orig_util_open_floating_preview(contents, syntax, opts, ...)
  end

  local signs = {
    {name = 'DiagnosticSignError', text = ''},
    {name = 'DiagnosticSignWarn', text = ''},
    {name = 'DiagnosticSignHint', text = ''},
    {name = 'DiagnosticSignInfo', text = ''},
  }

  for _, sign in ipairs(signs) do vim.fn.sign_define(sign.name, {texthl = sign.name, text = sign.text, numhl = ''}) end

  local on_attach = function(client, bufnr)

    client.resolved_capabilities.document_formatting = false

    if (client.name == 'null-ls') then client.resolved_capabilities.document_formatting = true end

    vim.api.nvim_create_user_command('Format', vim.lsp.buf.formatting, {})
    lsp_highlight_document(client)
  end

  -- local capabilities = vim.lsp.protocol.make_client_capabilities()
  --
  -- capabilities = vim.lsp.protocol.make_client_capabilities()
  -- capabilities.textDocument.completion.completionItem.documentationFormat = {'markdown', 'plaintext'}
  -- capabilities.textDocument.completion.completionItem.snippetSupport = true
  -- capabilities.textDocument.completion.completionItem.preselectSupport = true
  -- capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
  -- capabilities.textDocument.completion.completionItem.labelDetailsSupport = true
  -- capabilities.textDocument.completion.completionItem.deprecatedSupport = true
  -- capabilities.textDocument.completion.completionItem.commitCharactersSupport = true
  -- capabilities.textDocument.completion.completionItem.tagSupport = {valueSet = {1}}
  -- capabilities.textDocument.completion.completionItem.resolveSupport = {
  --   properties = {'documentation', 'detail', 'additionalTextEdits'},
  -- }

  local status_ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
  if not status_ok then
    vim.notify('Please add \'cmp_nvim_lsp\' to plugin list')
    return
  end

  local capabilities = vim.lsp.protocol.make_client_capabilities()
  local had_cmp_nvim_lsp, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
  if had_cmp_nvim_lsp then capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities) end

  local had_lspconfig = pcall(require, 'lspconfig')
  if had_lspconfig then
    for _, server in ipairs(servers) do require('configs.lsp.servers.' .. server).setup(on_attach, capabilities) end
  end

  -- Prefix diagnostic virtual text
  vim.diagnostic.config {
    virtual_text = {source = 'always', prefix = ' ', spacing = 6},
    float = {header = false, source = 'always'},
    signs = true,
    underline = false,
    update_in_insert = false,
  }

  vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {border = 'rounded'})

  vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, {border = 'rounded'})

end

return M
