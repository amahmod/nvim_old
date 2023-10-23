return {
    {
        'echasnovski/mini.pairs',
        event = 'InsertEnter',
        config = true,
    },
    {
        'echasnovski/mini.bufremove',
        keys = {
            {
                '<leader>x',
                function()
                    require('mini.bufremove').delete(0, false)
                end,
                desc = 'Delete Buffer',
            },
            {
                '<leader>X',
                function()
                    require('mini.bufremove').delete(0, true)
                end,
                desc = 'Delete Buffer (Force)',
            },
        },
    },
    {
        'echasnovski/mini.align',
        keys = {
            {
                'ga',
                function()
                    require 'mini.align'
                end,
                desc = 'Align text',
                mode = 'x',
            },
            {
                'gA',
                function()
                    require 'mini.align'
                end,
                desc = 'Align text with preview',
                mode = 'x',
            },
        },
        config = true,
    },
    {
        'echasnovski/mini.comment',
        keys = 'gcc',
        config = true,
    },
    {
        'echasnovski/mini.surround',
        version = '*',
        keys = {
            'sa',
            'sd',
            'sr',
            'sf',
            'sF',
            'sh',
            'sn',
        },
        config = true,
    },
    {
        'echasnovski/mini.indentscope',
        version = '*',
        event = 'VeryLazy',
        config = true,
    },
}
