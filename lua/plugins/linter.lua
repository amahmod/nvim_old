return {
    'mfussenegger/nvim-lint',
    enabled = true,
    event = { 'BufReadPost', 'BufNewFile' },
    config = function()
        require('lint').linters_by_ft = {
            -- markdown = { 'vale' },
            typescript = { 'eslint_d' },
            javascript = { 'eslint_d' },
            svelte = { 'eslint_d' },
        }

        vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
            callback = function()
                require('lint').try_lint()
            end,
        })
    end,
}
