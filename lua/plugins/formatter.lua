local user_settings = require 'config.settings'

if user_settings.format_on_save then
    vim.api.nvim_create_autocmd('BufWritePre', {
        pattern = '*',
        callback = function(args)
            require('conform').format { bufnr = args.buf }
        end,
    })
end

local prettier = { 'prettierd', 'prettier' }

return {
    'stevearc/conform.nvim',
    keys = {
        {
            '<leader>lf',
            ':lua require("conform").format()<CR>',
            desc = 'Format Document',
            mode = { 'n', 'v' },
        },
    },
    config = function()
        require('conform').setup {
            formatters_by_ft = {
                css = { prettier },
                html = { prettier },
                javascript = { prettier },
                json = { prettier },
                lua = { 'stylua' },
                markdown = { prettier },
                svelte = { prettier },
                typescript = { prettier },
            },
        }
    end,
}
