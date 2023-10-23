return {
    -----------------------------------------------------------------------------
    -- Vimscript syntax/indent plugins
    { 'chrisbra/csv.vim', ft = 'csv' },
    { 'mustache/vim-mustache-handlebars', ft = { 'mustache', 'handlebars' } },
    { 'lifepillar/pgsql.vim', ft = 'pgsql' },
    { 'MTDL9/vim-log-highlighting', ft = 'log' },

    -----------------------------------------------------------------------------
    {
        'nvim-treesitter/nvim-treesitter',
        event = 'VeryLazy',
        build = ':TSUpdate',
        dependencies = {
            'nvim-treesitter/nvim-treesitter-textobjects',
            {
                'nvim-treesitter/nvim-treesitter-context',
                opts = { enable = true, max_lines = 3 },
            },
            { 'windwp/nvim-ts-autotag', event = 'InsertEnter' },
            { 'andymass/vim-matchup' },
        },
        cmd = {
            'TSUpdate',
            'TSInstall',
            'TSInstallInfo',
            'TSModuleInfo',
            'TSConfigInfo',
            'TSUpdateSync',
        },
        keys = {
            { 'v', desc = 'Increment selection', mode = 'x' },
            { 'V', desc = 'Shrink selection', mode = 'x' },
        },
        ---@type TSConfig
        ---@diagnostic disable-next-line: missing-fields
        opts = {
            matchup = {
                enable = true,
                disable = { 'c', 'ruby' },
            },
            autotag = {
                enable = true,
                enable_rename = true,
                enable_close = true,
                enable_close_on_slash = true,
            },
            highlight = { enable = true },
            indent = { enable = true },
            refactor = {
                highlight_definitions = { enable = true },
                highlight_current_scope = { enable = true },
            },
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = false,
                    node_incremental = 'v',
                    scope_incremental = false,
                    node_decremental = 'V',
                },
            },

            -- See: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
            textobjects = {
                select = {
                    enable = true,
                    lookahead = true,
                    keymaps = {
                        ['af'] = '@function.outer',
                        ['if'] = '@function.inner',
                        ['ac'] = '@class.outer',
                        ['ic'] = '@class.inner',
                        ['a,'] = '@parameter.outer',
                        ['i,'] = '@parameter.inner',
                    },
                },
                move = {
                    enable = true,
                    set_jumps = true,
                    goto_next_start = {
                        ['],'] = '@parameter.inner',
                    },
                    goto_previous_start = {
                        ['[,'] = '@parameter.inner',
                    },
                },
                swap = {
                    enable = true,
                    swap_next = {
                        ['>,'] = '@parameter.inner',
                    },
                    swap_previous = {
                        ['<,'] = '@parameter.inner',
                    },
                },
            },

            -- https://github.com/nvim-treesitter/nvim-treesitter#supported-languages
            ensure_installed = {
                'bash',
                'comment',
                'css',
                'cue',
                'diff',
                'fish',
                'fennel',
                'git_config',
                'git_rebase',
                'gitcommit',
                'gitignore',
                'gitattributes',
                'graphql',
                'hcl',
                'html',
                'http',
                'java',
                'javascript',
                'jsdoc',
                'kotlin',
                'lua',
                'luadoc',
                'luap',
                'make',
                'markdown',
                'markdown_inline',
                'nix',
                'perl',
                'php',
                'pug',
                'regex',
                'ruby',
                'rust',
                'scala',
                'scss',
                'sql',
                'svelte',
                'terraform',
                'todotxt',
                'toml',
                'tsx',
                'typescript',
                'vim',
                'vimdoc',
                'vue',
                'zig',
            },
        },
        config = function(_, opts)
            require('nvim-treesitter.configs').setup(opts)
        end,
    },
}
