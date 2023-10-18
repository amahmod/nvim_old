local map = vim.keymap.set

-- {{{ Arrow-keys resize window

map('n', '<Up>', '<cmd>resize +1<cr>', { desc = 'Resize Window' })
map('n', '<Down>', '<cmd>resize -1<cr>', { desc = 'Resize Window' })
map('n', '<Left>', '<cmd>vertical resize +1<cr>', { desc = 'Resize Window' })
map('n', '<Right>', '<cmd>vertical resize -1<cr>', { desc = 'Resize Window' })

-- }}}

-- {{{ Navigation

-- Moves through display-lines, unless count is provided
map({ 'n', 'x' }, 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ 'n', 'x' }, 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Navigation in command line
map('c', '<C-h>', '<Home>')
map('c', '<C-l>', '<End>')
map('c', '<C-f>', '<Right>')
map('c', '<C-b>', '<Left>')

-- Scroll step sideways
map('n', 'zl', 'z10l', { desc = 'Scroll right' })
map('n', 'zh', 'z10h', { desc = 'SCroll left' })

map('n', '<C-h>', '<C-w>h', { desc = 'Move to left split' })
map('n', '<C-j>', '<C-w>j', { desc = 'Move to below split' })
map('n', '<C-k>', '<C-w>k', { desc = 'Move to above split' })
map('n', '<C-l>', '<C-w>l', { desc = 'Move to right split' })

map('n', '<S-l>', '<cmd>bnext<CR>', { desc = 'Go to next buffer' })
map('n', '<S-h>', '<cmd>bprevious<CR>', { desc = 'Go to previous buffer' })

map('n', ']t', '<cmd>tabnext<CR>', { desc = 'Next Tab' })
map('n', '[t', '<cmd>tabprevious<CR>', { desc = 'Previous Tab' })

-- }}}

-- {{{ Toggle

map('n', '<leader>ts', '<cmd>set spell!<CR>', { desc = 'Toggle spell check' })

map('n', '<leader>th', function()
    vim.lsp.inlay_hint(0, nil)
end, { desc = 'Toggle Inlay Hints' })

-- Smart wrap toggle (breakindent and colorcolumn toggle as-well)
map('n', '<leader>tww', function()
    vim.opt_local.wrap = not vim.wo.wrap
    vim.opt_local.breakindent = not vim.wo.breakindent

    if vim.wo.colorcolumn == '' then
        vim.opt_local.colorcolumn = tostring(vim.bo.textwidth)
    else
        vim.opt_local.colorcolumn = ''
    end
end, { desc = 'Toggle Wrap' })

-- Toggle fold or select option from popup menu
---@return string
map('n', '<CR>', function()
    return vim.fn.pumvisible() == 1 and '<CR>' or 'za'
end, { expr = true, desc = 'Toggle Fold' })

-- Focus the current fold by closing all others
map('n', '<S-Return>', 'zMzv', { remap = true, desc = 'Focus Fold' })

-- Background dark/light toggle
map('n', '<leader>tb', function()
    if vim.o.background == 'dark' then
        vim.o.background = 'light'
    else
        vim.o.background = 'dark'
    end
end, { desc = 'Toggle background dark/light' })

map('n', '<leader>tq', function()
    require('lib.utils').toggle_quickfix()
end, { desc = '[T]oggle [Q]uickfix' })

-- }}}

-- {{{ Clipbaord

-- Yank buffer's relative path to clipboard
map('n', '<leader>yr', function()
    local path = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ':~:.')
    vim.fn.setreg('+', path)
    vim.notify(path, vim.log.levels.INFO, { title = 'Yanked relative path' })
end, { silent = true, desc = 'Yank relative path' })

-- Yank absolute path
map('n', '<leader>ya', function()
    local path = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ':p')
    vim.fn.setreg('+', path)
    vim.notify(path, vim.log.levels.INFO, { title = 'Yanked absolute path' })
end, { silent = true, desc = 'Yank absolute path' })

-- Paste in visual-mode without pushing to register
map('x', 'p', 'p:let @+=@0<CR>:let @"=@0<CR>', { silent = true, desc = 'Paste' })
map('x', 'P', 'P:let @+=@0<CR>:let @"=@0<CR>', { silent = true, desc = 'Paste In-place' })

-- }}}

-- Save and quit {{{

map('n', '<leader>w', '<cmd>w<CR>', { desc = 'Save' })
map({ 'n', 'i', 'v' }, '<C-s>', '<cmd>write<CR>', { desc = 'Save' })
map('n', '<leader>x', function()
    if require('lib.utils').has_plugin 'mini.bufremove' then
        require('mini.bufremove').delete(0, false)
    else
        vim.cmd 'bd'
    end
end, { desc = 'Close current buffer' })
map('n', '<leader>q', '<cmd>q!<CR>', { desc = 'Force quit' })
map('n', '<leader>ba', '<cmd>bufdo bd<CR>', { desc = 'close all buffers' })
map(
    'n',
    '<leader>bo',
    '<cmd>w <bar> %bd <bar> e# <bar> bd#<CR>',
    { desc = 'Close all buffers except current one' }
)

-- }}}

-- {{{ Edit

-- Start new line from any cursor position in insert-mode
map('i', '<S-Return>', '<C-o>o', { desc = 'Start Newline' })

-- Re-select blocks after indenting in visual/select mode
map('x', '<', '<gv', { desc = 'Indent Right and Re-select' })
map('x', '>', '>gv|', { desc = 'Indent Left and Re-select' })

-- Use tab for indenting in visual/select mode
map('x', '<Tab>', '>gv|', { desc = 'Indent Left' })
map('x', '<S-Tab>', '<gv', { desc = 'Indent Right' })

-- Duplicate lines without affecting PRIMARY and CLIPBOARD selections.
map('n', '<leader>dl', 'm`""Y""P``', { desc = 'Duplicate line' })
map('x', '<leader>dl', '""Y""Pgv', { desc = 'Duplicate selection' })

-- Duplicate paragraph
map('n', '<leader>dp', 'yap<S-}>p', { desc = 'Duplicate Paragraph' })

map('n', '<leader>tn', '<cmd>tabnew<CR>', { desc = '[T]ab [N]ew' })
map('n', '<leader>tc', '<cmd>tabclose<CR>', { desc = '[T]ab [C]lose' })

-- }}}

-- Search & Replace {{{

-- Switch */g* and #/g#
map('n', '*', 'g*')
map('n', 'g*', '*')
map('n', '#', 'g#')
map('n', 'g#', '#')

-- Clear search with <Esc>
map('n', '<Esc>', '<cmd>noh<CR>', { desc = 'Clear Search Highlight' })

-- }}}

-- vim:fdm=marker:fdl=0
