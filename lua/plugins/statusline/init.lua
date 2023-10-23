return {
    'nvim-lualine/lualine.nvim',
    dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-tree/nvim-web-devicons',
    },
    event = 'VeryLazy',
    init = function()
        vim.g.qf_disable_statusline = true
    end,
    config = function()
        -- require 'plugins.statusline.rafi'
        require 'plugins.statusline.evil_line'
    end,
}
