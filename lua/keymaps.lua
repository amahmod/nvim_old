local opts = {noremap = true, silent = true}

local term_opts = {silent = true}

-- Shorten function name
local keymap = vim.api.nvim_set_keymap

-- Remap space as leader key
keymap('', '<Space>', '<Nop>', opts)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- General
keymap('n', 'n', 'nzzzv', opts) -- keep the cursor centered when doing 'n'
keymap('n', 'N', 'Nzzzv', opts) -- keep the cursor centered when doing 'N'
keymap('n', 'J', 'mzJ`z', opts) -- keep the cursor in same position when joining lines
keymap('n', 'cn', '*``cgn', opts) -- change next match by pressing dot (.)
keymap('n', 'cN', '*``cgN', opts) -- change previous match by pressing dot (.)
keymap('n', '<leader>vp', '`[v`]<CR>', opts) -- visually select previous pasted text
keymap('v', '<leader>p', '"_dP', opts) -- delete into black hole and past last yank
keymap('n', '<leader>Y', 'gg"+yG', opts) -- copy hole buffer
keymap('n', '<leader>V', 'ggVG', opts) -- select hole buffer
keymap('n', '<leader>D', 'gg"_dG', opts) -- delete into black hole register
keymap('v', '<leader>D', '"_d', opts) -- delete into black hole register
keymap('n', '<C-d>', '<C-d>zz', opts) -- move and center
keymap('n', '<C-u>', '<C-u>zz', opts) -- move and center
keymap('n', '<leader>ts', ':set spell!<CR>', opts) -- Toggle spell check
keymap('n', '<leader>th', ':set nohlsearch<CR>', opts) -- Toggle spell check
keymap('n', '<leader>z', ':%s/<C-R><C-W>/<C-R>0/g<CR>', opts) -- replace word under cursor with register "0" content globally

-- Better window management
keymap('n', '<C-h>', '<C-w>h', opts) -- focus left window
keymap('n', '<C-j>', '<C-w>j', opts) -- focus bottom window
keymap('n', '<C-k>', '<C-w>k', opts) -- focus top winodw
keymap('n', '<C-l>', '<C-w>l', opts) -- focus right window
keymap('n', '<leader>ws', ':sp<CR>', opts) -- split window horizontally
keymap('n', '<leader>wv', ':vs<CR>', opts) -- split window vertically
keymap('n', '<leader>wH', '<C-w>H', opts) -- Move current window the far left and use the full height of the screen
keymap('n', '<leader>wJ', '<C-w>J', opts) -- Move current window the far bottom and use the full width of the screen
keymap('n', '<leader>wK', '<C-w>K', opts) -- Move current window the far top and full width of the screen
keymap('n', '<leader>wL', '<C-w>L', opts) -- Move current window the far right and full height of the screen
keymap('n', '<leader>wc', '<C-w>c', opts) -- Close current window in the current tabview
keymap('n', '<leader>wo', '<C-w>o', opts) -- Close every window in the current tabview but the current one
keymap('n', '<leader>wR', '<C-w>R', opts) -- Rotates the windows from right to left

keymap('n', '<leader>e', ':NvimTreeToggle<CR>', opts)

-- Resize with arrows
keymap('n', '<C-Right>', ':vertical resize -2<CR>', opts) -- Increase the window to the right
keymap('n', '<C-Left>', ':vertical resize +2<CR>', opts) -- Increase the window to the left
keymap('n', '<C-Up>', ':resize +2<CR>', opts) -- Increase the window to up
keymap('n', '<C-Down>', ':resize -2<CR>', opts) -- Increase the window to down

-- Buffers
keymap('n', '<leader>s', ':w<CR>', opts) -- save buffer
keymap('n', '<leader>q', ':q!<CR>', opts) -- close buffer without saving
keymap('n', '<leader>x', ':Bdelete<CR>', opts) -- close all buffers
keymap('n', '<leader>ba', ':bufdo bd<CR>', opts) -- close all buffers
keymap('n', '<leader>bo', ':w <bar> %bd <bar> e# <bar> bd#<CR>', opts) -- close all buffers except current one
keymap('n', '<S-l>', ':bnext<CR>', opts) -- next buffer
keymap('n', '<S-h>', ':bprevious<CR>', opts) -- previous buffer

-- Visual --
-- Stay in indent mode
keymap('v', '<', '<gv', opts)
keymap('v', '>', '>gv', opts)

-- Move text up and down
-- keymap('v', 'J', ':m \'>+1<CR>gv=gv', opts) -- move line down
-- keymap('v', 'K', ':m \'<-2<CR>gv=gv', opts) -- move line up
-- keymap('v', 'p', '"_dP', opts)

-- Visual Block --
-- Move text up and down
keymap('x', 'J', ':move \'>+1<CR>gv-gv', opts)
keymap('x', 'K', ':move \'<-2<CR>gv-gv', opts)
keymap('x', '<A-j>', ':move \'>+1<CR>gv-gv', opts)
keymap('x', '<A-k>', ':move \'<-2<CR>gv-gv', opts)

-- Terminal --
-- Better terminal navigation
keymap('t', '<C-h>', '<C-\\><C-N><C-w>h', term_opts)
keymap('t', '<C-j>', '<C-\\><C-N><C-w>j', term_opts)
keymap('t', '<C-k>', '<C-\\><C-N><C-w>k', term_opts)
keymap('t', '<C-l>', '<C-\\><C-N><C-w>l', term_opts)

-- Format
keymap('n', '<leader>F', ':Format<CR>', opts)

-- Nvim-tree
keymap('n', '<leader>e', ':NvimTreeToggle<CR>', opts)

-- Fugitive
keymap('n', '<leader>gg', ':Git<CR>', opts)
-- keymap('n', '<leader>gd', ':Git diff<CR>', opts)
-- keymap('n', '<leader>gD', ':Gdiffsplit<CR>', opts)
-- keymap('n', '<leader>ge', ':Gedit<CR>', opts)
keymap('n', '<leader>gr', ':Gread<CR>', opts)
keymap('n', '<leader>gw', ':Gwrite<CR>', opts)
-- keymap('n', '<leader>gB', ':Git blame<Cr>', opts)
keymap('n', '<leader>gl', ':Git log<CR>', opts)
keymap('n', '<leader>gL', ':Gclog<CR>', opts)

-- Telescope {{{
keymap('n', '<C-p>', ':Telescope find_files<CR>', opts)
keymap('n', '<Leader>fG', ':Telescope grep_string<CR>', opts)
keymap('n', '<Leader>fg', ':Telescope live_grep<CR>', opts)
keymap('n', '<Leader>ff', ':Telescope current_buffer_fuzzy_find<CR>', opts)
keymap('n', '<Leader>fF', ':Telescope file_browser<CR>', opts)
keymap('n', '<Leader>fb', ':Telescope buffers<CR>', opts)
keymap('n', '<Leader>fo', ':Telescope oldfiles<CR>', opts)
keymap('n', '<leader>fcc', ':Telescope commands<CR>', opts)
keymap('n', '<leader>:', ':Telescope command_history<CR>', opts)
keymap('n', '<leader>/', ':Telescope search_history<CR>', opts)
keymap('n', '<Leader>fp', ':Telescope pickers<CR>', opts)
keymap('n', '<Leader>fP', ':Telescope project<CR>', opts)
keymap('n', '<Leader>fj', ':Telescope jumplist<CR>', opts)
keymap('n', '<Leader>fr', ':Telescope lsp_references<CR>', opts)
keymap('n', '<Leader>fR', ':Telescope registers<CR>', opts)
keymap('n', '<Leader>ft', ':Telescope treesitter<CR>', opts)
keymap('n', '<Leader>fT', ':Telescope current_buffer_tags<CR>', opts)
keymap('n', '<Leader>fws', ':Telescope lsp_workspace_symbols<CR>', opts)
keymap('n', '<Leader>fca', ':Telescope lsp_code_actions<CR>', opts)
keymap('n', '<Leader>fwd', ':Telescope lsp_workspace_diagnostics<CR>', opts)
keymap('n', '<Leader>fi', ':Telescope lsp_implementations<CR>', opts)
keymap('n', '<Leader>fds', ':Telescope lsp_document_symbols<CR>', opts)
keymap('n', '<Leader>fdd', ':Telescope lsp_document_diagnostics<CR>', opts)
keymap('n', '<Leader>fD', ':Telescope lsp_definitions<CR>', opts)
keymap('n', '<Leader>ftd', ':Telescope lsp_definitions<CR>', opts)
-- keymap('n', '<Leader>fgc', ':Telescope git_commits<CR>', opts)
-- keymap('n', '<Leader>fgC', ':Telescope git_bcommits<CR>', opts)
-- keymap('n', '<Leader>fgb', ':Telescope git_branches<CR>', opts)
-- keymap('n', '<Leader>fgs', ':Telescope git_status<CR>', opts)
-- keymap('n', '<Leader>fgS', ':Telescope git_stash<CR>', opts)
keymap('n', '<Leader>fR', ':Telescope resume<CR>', opts)
keymap('n', '<Leader>fs', ':Telescope symbols<CR>', opts)

-- Bufferline
keymap('n', 'H', ':BufferLineCyclePrev<CR>', opts)
keymap('n', 'L', ':BufferLineCycleNext<CR>', opts)
keymap('n', '<leader><leader>', ':BufferLinePick<CR>', opts)
keymap('n', '<leader>1', ':BufferLineGoToBuffer 1<CR>', opts)
keymap('n', '<leader>2', ':BufferLineGoToBuffer 2<CR>', opts)
keymap('n', '<leader>3', ':BufferLineGoToBuffer 3<CR>', opts)
keymap('n', '<leader>4', ':BufferLineGoToBuffer 4<CR>', opts)
keymap('n', '<leader>5', ':BufferLineGoToBuffer 5<CR>', opts)
keymap('n', '<leader>6', ':BufferLineGoToBuffer 6<CR>', opts)
keymap('n', '<leader>7', ':BufferLineGoToBuffer 7<CR>', opts)
keymap('n', '<leader>8', ':BufferLineGoToBuffer 8<CR>', opts)
keymap('n', '<leader>9', ':BufferLineGoToBuffer 9<CR>', opts)

-- CodeAction
keymap('n', '<leader>ca', ':CodeActionMenu<CR>', opts)

-- Spctree: search and replace
keymap('n', '<leader>Ss', ':lua require("spectre").open()<CR>', opts) -- search current word
keymap('n', '<leader>Sw', ':lua require("spectre").open_visual({select_word=true})<CR>', opts)
keymap('v', '<leader>S', ':lua require("spectre").open_visual()<CR>', opts) -- search in current file
keymap('n', '<leader>Sp', ':lua require("spectre").open_file_search()<CR>', opts)

-- EasiAlign
keymap('n', 'ga', ':EasyAlign<CR>', opts)
keymap('v', 'ga', ':EasyAlign<CR>', opts)
keymap('x', 'ga', ':EasyAlign<CR>', opts)
