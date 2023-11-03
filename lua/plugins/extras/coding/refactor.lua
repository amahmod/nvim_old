return {
    'ThePrimeagen/refactoring.nvim',
    event = { 'BufReadPost', 'BufNewFile' },
    config = function()
        require('refactoring').setup {}

        -- stylua: ignore start
        vim.keymap.set({ 'n', 'x' }, '<leader>rr', function() require('refactoring').select_refactor() end, { desc = "Select [R]efactor Type"})
        vim.keymap.set('x', '<leader>rf', ':Refactor extract ', { desc = '[R]efactor to [F]unction' })
        vim.keymap.set('x', '<leader>rF', ':Refactor extract_to_file ', { desc = '[R]efactor to [F]ile'})
        vim.keymap.set('x', '<leader>rv', ':Refactor extract_var ', { desc = '[R]efactor [V]ariable' })
        vim.keymap.set({ 'n', 'x' }, '<leader>rV', ':Refactor inline_var', { desc = '[R]efactor inline [V]ariable' })
        vim.keymap.set('n', '<leader>rif', ':Refactor inline_func', { desc = '[R]efactor [I]nline [F]unction' })
        vim.keymap.set('n', '<leader>rb', ':Refactor extract_block', { desc = '[R]efactor [B]lock' })
        vim.keymap.set('n', '<leader>rB', ':Refactor extract_block_to_file' , { desc = '[R]efactor [B]lock to file' })
        vim.keymap.set({ 'x', 'n' }, '<leader>rpv', function() require('refactoring').debug.print_var() end, { desc = '[R]efactor [P]rint [V]ariable' })
        -- Supports both visual and normal mode
    end,
}
