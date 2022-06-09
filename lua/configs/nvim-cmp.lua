local M = {}

function M.config()

  local cmp_status_ok, cmp = pcall(require, 'cmp')
  if not cmp_status_ok then return end

  local snip_status_ok, luasnip = pcall(require, 'luasnip')
  if not snip_status_ok then
    vim.notify('luasnip not found')
    return
  end

  require('luasnip/loaders/from_vscode').lazy_load()

  local check_backspace = function()
    local col = vim.fn.col '.' - 1
    return col == 0 or vim.fn.getline('.'):sub(col, col):match '%s'
  end

  local has_words_before = function()
    local cursor = vim.api.nvim_win_get_cursor(0)
    return (vim.api.nvim_buf_get_lines(0, cursor[1] - 1, cursor[1], true)[1] or ''):sub(cursor[2], cursor[2])
      :match('%s')
  end

  --   פּ ﯟ   some other good icons
  local kind_icons = {
    Text = '',
    Method = 'm',
    Function = '',
    Constructor = '',
    Field = '',
    Variable = '',
    Class = '',
    Interface = '',
    Module = '',
    Property = '',
    Unit = '',
    Value = '',
    Enum = '',
    Keyword = '',
    Snippet = '',
    Color = '',
    File = '',
    Reference = '',
    Folder = '',
    EnumMember = '',
    Constant = '',
    Struct = '',
    Event = '',
    Operator = '',
    TypeParameter = '',
  }
  -- find more here: https://www.nerdfonts.com/cheat-sheet

  cmp.setup {
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body) -- For `luasnip` users.
      end,
    },
    mapping = {
      ['<C-k>'] = cmp.mapping.select_prev_item(),
      ['<C-j>'] = cmp.mapping.select_next_item(),
      ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-1), {'i', 'c'}),
      ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(1), {'i', 'c'}),
      ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), {'i', 'c'}),
      ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
      ['<C-e>'] = cmp.mapping {i = cmp.mapping.abort(), c = cmp.mapping.close()},
      -- Accept currently selected item. If none selected, `select` first item.
      -- Set `select` to `false` to only confirm explicitly selected items.
      ['<CR>'] = cmp.mapping.confirm {select = true},
      ['<C-n>'] = cmp.mapping(
        function(fallback)
          local copilot_keys = vim.fn['copilot#Accept']()
          if copilot_keys ~= '' then
            vim.api.nvim_feedkeys(copilot_keys, 'i', true)
          else
            fallback()
          end
        end
      ),
      ['<Tab>'] = cmp.mapping(
        function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expandable() then
            luasnip.expand()
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
            -- NOTE: this prevents coipilot to expand if there is any text before cursor
            -- elseif has_words_before() then
            --   print('has words before')
            --   cmp.complete()
          else
            -- local copilot_keys = vim.fn['copilot#Accept']()
            -- if copilot_keys ~= '' then
            --   vim.api.nvim_feedkeys(copilot_keys, 'i', true)
            -- else
            fallback()
            -- end
          end
        end, {'i', 's'}
      ),
      ['<S-Tab>'] = cmp.mapping(
        function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, {'i', 's'}
      ),
    },
    window = {documentation = cmp.config.window.bordered()},
    formatting = {
      fields = {'kind', 'abbr', 'menu'},
      format = function(entry, vim_item)
        -- Kind icons
        vim_item.kind = string.format('%s', kind_icons[vim_item.kind])
        -- vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
        vim_item.menu = ({
          nvim_lsp = '[LSP]',
          nvim_lua = '[NVIM_LUA]',
          luasnip = '[Snippet]',
          buffer = '[Buffer]',
          path = '[Path]',
        })[entry.source.name]
        return vim_item
      end,
    },
    sources = {},
    confirm_opts = {behavior = cmp.ConfirmBehavior.Replace, select = false},
    experimental = {ghost_text = true, native_menu = false},
  }

  -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline('/', {sources = cmp.config.sources({{name = 'buffer'}})})

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {sources = cmp.config.sources({{name = 'path'}})})

end

return M
