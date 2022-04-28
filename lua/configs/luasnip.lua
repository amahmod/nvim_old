local M = {}

local function prequire(...)
  local status, lib = pcall(require, ...)
  if (status) then return lib end
  return nil
end

local luasnip = prequire('luasnip')
local cmp = prequire('cmp')

local t = function(str) return vim.api.nvim_replace_termcodes(str, true, true, true) end

local check_back_space = function()
  local col = vim.fn.col('.') - 1
  if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
    return true
  else
    return false
  end
end

_G.tab_complete = function()
  if cmp and cmp.visible() then
    cmp.select_next_item()
  elseif luasnip and luasnip.expand_or_jumpable() then
    return t('<Plug>luasnip-expand-or-jump')
  elseif check_back_space() then
    return t '<Tab>'
  else
    cmp.complete()
  end
  return ''
end
_G.s_tab_complete = function()
  if cmp and cmp.visible() then
    cmp.select_prev_item()
  elseif luasnip and luasnip.jumpable(-1) then
    return t('<Plug>luasnip-jump-prev')
  else
    return t '<S-Tab>'
  end
  return ''
end

function M.config()

  vim.api.nvim_set_keymap('i', '<Tab>', 'v:lua.tab_complete()', {expr = true})
  vim.api.nvim_set_keymap('s', '<Tab>', 'v:lua.tab_complete()', {expr = true})
  vim.api.nvim_set_keymap('i', '<S-Tab>', 'v:lua.s_tab_complete()', {expr = true})
  vim.api.nvim_set_keymap('s', '<S-Tab>', 'v:lua.s_tab_complete()', {expr = true})
  vim.api.nvim_set_keymap('i', '<C-E>', '<Plug>luasnip-next-choice', {})
  vim.api.nvim_set_keymap('s', '<C-E>', '<Plug>luasnip-next-choice', {})

  local snippets_paths = function()
    local plugins = {'friendly-snippets'}
    local paths = {}
    local path
    local root_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/'
    for _, plug in ipairs(plugins) do
      path = root_path .. plug
      if vim.fn.isdirectory(path) ~= 0 then table.insert(paths, path) end
    end
    return paths
  end

  require('luasnip.loaders.from_vscode').lazy_load(
    {
      paths = snippets_paths(),
      include = nil, -- Load all languages
      exclude = {},
    }
  )
end

return M
