return {
    {
        'nvim-neo-tree/neo-tree.nvim',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
            'MunifTanjim/nui.nvim',
        },
        cmd = 'Neotree',
        keys = {
            {
                '<leader>e',
                '<cmd>Neotree toggle<CR>',
                desc = 'NeoTree Toggle',
            },
        },
        init = function()
            vim.g.neo_tree_remove_legacy_commands = 1
        end,
        opts = {
            filesystem = {
                follow_current_file = {
                    enabled = true,
                },
                hijack_netrw_behavior = 'open_current',
                filtered_items = {
                    never_show = { '.git' },
                },
            },
            event_handlers = {
                -- Close neo-tree when opening a file.
                {
                    event = 'file_opened',
                    handler = function()
                        -- require('neo-tree').close_all()
                    end,
                },
            },
            window = {
                position = 'right',
                width = 30,
                mappings = {
                    ['l'] = 'open',
                    ['h'] = 'close_node',
                    ['L'] = 'focus_preview',
                },
            },
        },
    },
}
