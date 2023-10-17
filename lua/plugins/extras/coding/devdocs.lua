return {
    'luckasRanarison/nvim-devdocs',
    dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-telescope/telescope.nvim',
        'nvim-treesitter/nvim-treesitter',
    },
    cmd = {
        'DevdocsFetch',
        'DevdocsOpen',
        'DevdocsInstall',
        'DevdocsUninstall',
        'DevdocsOpenFloat',
        'DevdocsOpenCurrent',
        'DevdocsOpenCurrentFloat',
        'DevdocsUpdate',
        'DevdocsUpdateAll',
    },
    config = function()
        require('nvim-devdocs').setup {
            ensure_installed = {
                'html',
                'css',
                'javascript',
                'typescript',
            },
            previewer_cmd = 'glow',
            cmd_args = { '-s', 'dark', '-w', '80' },
        }
    end,
}
