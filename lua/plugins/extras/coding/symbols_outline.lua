return {
    'simrat39/symbols-outline.nvim',
    cmd = { 'SymbolsOutline', 'SymbolsOutlineOpen' },
    keys = {
        { '<leader>to', '<cmd>SymbolsOutline<CR>', desc = 'Symbols Outline' },
    },
    opts = {
        width = 20,
        autofold_depth = 1,
        keymaps = {
            hover_symbol = 'K',
            toggle_preview = 'p',
        },
    },
    init = function()
        vim.api.nvim_create_autocmd('FileType', {
            group = vim.api.nvim_create_augroup('rafi_outline', {}),
            pattern = 'Outline',
            callback = function()
                vim.opt_local.winhighlight = 'CursorLine:WildMenu'
                vim.opt_local.signcolumn = 'auto'
            end,
        })
    end,
}
