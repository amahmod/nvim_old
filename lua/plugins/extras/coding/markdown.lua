return {
    {
        'preservim/vim-markdown',
        ft = { 'markdown' },
    },
    -- markdown preview
    {
        'iamcco/markdown-preview.nvim',
        build = 'cd app && yarn install',
        ft = { 'markdown' },
        keys = {
            {
                '<leader>tp',
                '<cmd>MarkdownPreviewToggle<CR>',
                { desc = '[T]oggle markdown [P]review', noremap = true },
            },
        },
    },
    { 'ellisonleao/glow.nvim', config = true, cmd = 'Glow' },
}
