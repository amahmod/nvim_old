return {
    --  ════════════════════════════════════════════════════════════
    'danymat/neogen',
    keys = {
        {
            '<leader>dg',
            function()
                require('neogen').generate {}
            end,
            desc = 'Neogen Comment',
        },
    },
    opts = { snippet_engine = 'luasnip' },
}
