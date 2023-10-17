return {
    'akinsho/toggleterm.nvim',
    cmd = 'ToggleTerm',
    keys = {
        {
            '<C-_>',
            mode = { 'n', 't' },
            silent = true,
            function()
                local venv = vim.b['virtual_env']
                local term = require('toggleterm.terminal').Terminal:new {
                    env = venv and { VIRTUAL_ENV = venv } or nil,
                    count = vim.v.count > 0 and vim.v.count or 1,
                }
                term:toggle()
            end,
            desc = 'Toggle terminal',
        },
    },
    opts = {
        open_mapping = false,
        float_opts = {
            border = 'curved',
        },
    },
}
