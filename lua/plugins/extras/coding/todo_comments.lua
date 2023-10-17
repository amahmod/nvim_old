return {
    'folke/todo-comments.nvim',
    cmd = { 'TodoTrouble', 'TodoTelescope' },
    event = { 'BufReadPost', 'BufNewFile' },
    keys = {
        {
            ']T',
            function()
                require('todo-comments').jump_next()
            end,
            desc = 'Next todo comment',
        },
        {
            '[T',
            function()
                require('todo-comments').jump_prev()
            end,
            desc = 'Previous todo comment',
        },
    },
    config = true,
}
