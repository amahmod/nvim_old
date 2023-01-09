return {
    -- lspconfig
    {
        'neovim/nvim-lspconfig',
        event = 'BufReadPre',
        dependencies = {
            'mason.nvim',
            'williamboman/mason-lspconfig.nvim',
            'hrsh7th/cmp-nvim-lsp',
        },
        opts = {
            servers = {
                html = {},
                emmet_ls = {},
                yamlls = {},
                dockerls = {},
                tsserver = {},
                gopls = {},
                diagnosticls = {},
                sqlls = {},
                svelte = {},
                volar = {},
                eslint = {},
                tailwindcss = {},
                graphql = {},
                rust_analyzer = {},
                marksman = {},
                cssls = {},
                jsonls = {},
                sumneko_lua = {
                    settings = {
                        Lua = {
                            workspace = {
                                checkThirdParty = false,
                            },
                            completion = {
                                callSnippet = 'Replace',
                            },
                        },
                    },
                },
            },
            -- you can do any additional lsp server setup here
            -- return true if you don't want this server to be setup with lspconfig
            ---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
            setup = {
                -- example to setup with typescript.nvim
                -- tsserver = function(_, opts)
                --   require("typescript").setup({ server = opts })
                --   return true
                -- end,
                -- Specify * to use this function as a fallback for any server
                -- ["*"] = function(server, opts) end,
            },
        },
        config = function(plugin, opts)
            if plugin.servers then
                require('amahmod.util').deprecate(
                    'lspconfig.servers',
                    'lspconfig.opts.servers'
                )
            end
            if plugin.setup_server then
                require('amahmod.util').deprecate(
                    'lspconfig.setup_server',
                    'lspconfig.opts.setup[SERVER]'
                )
            end

            -- setup formatting and keymaps
            require('amahmod.util').on_attach(function(client, buffer)
                require('amahmod.plugins.lsp.format').on_attach(client, buffer)
                require('amahmod.plugins.lsp.keymaps').on_attach(client, buffer)
            end)

            -- diagnostics
            for name, icon in
                pairs(require('amahmod.configs.settings').icons.diagnostics)
            do
                name = 'DiagnosticSign' .. name
                vim.fn.sign_define(
                    name,
                    { text = icon, texthl = name, numhl = '' }
                )
            end
            vim.diagnostic.config {
                underline = true,
                update_in_insert = false,
                virtual_text = {
                    spacing = 4,
                    prefix = '●',
                    source = 'always',
                },
                severity_sort = true,
                float = { header = false, source = 'always' },
            }

            local servers = opts.servers
            local capabilities = require('cmp_nvim_lsp').default_capabilities(
                vim.lsp.protocol.make_client_capabilities()
            )

            require('mason-lspconfig').setup {
                ensure_installed = vim.tbl_keys(servers),
            }
            require('mason-lspconfig').setup_handlers {
                function(server)
                    local server_opts = servers[server] or {}
                    server_opts.capabilities = capabilities
                    if opts.setup[server] then
                        if opts.setup[server](server, server_opts) then
                            return
                        end
                    elseif opts.setup['*'] then
                        if opts.setup['*'](server, server_opts) then
                            return
                        end
                    end
                    require('lspconfig')[server].setup(server_opts)
                end,
            }
        end,
    },

    -- formatters
    {
        'jose-elias-alvarez/null-ls.nvim',
        event = 'BufReadPre',
        dependencies = { 'mason.nvim' },
        opts = function()
            local nls = require 'null-ls'
            return {
                sources = {
                    -- nls.builtins.formatting.prettierd,
                    -- formatting
                    nls.builtins.formatting.stylua,
                    nls.builtins.formatting.shfmt,
                    nls.builtins.formatting.prettierd.with {
                        extra_filetypes = { 'svelte' },
                    },

                    -- code actions
                    nls.builtins.code_actions.gitsigns,

                    -- diagnostic
                    nls.builtins.diagnostics.yamllint,
                },
            }
        end,
    },

    -- cmdline tools and lsp servers
    {

        'williamboman/mason.nvim',
        cmd = 'Mason',
        keys = { { '<leader>cm', '<cmd>Mason<cr>', desc = 'Mason' } },
        opts = {
            ensure_installed = {
                'stylua',
                'shellcheck',
                'shfmt',
            },
        },
        ---@param opts MasonSettings | {ensure_installed: string[]}
        config = function(plugin, opts)
            if plugin.ensure_installed then
                require('amahmod.util').deprecate(
                    'treesitter.ensure_installed',
                    'treesitter.opts.ensure_installed'
                )
            end
            require('mason').setup(opts)
            local mr = require 'mason-registry'
            for _, tool in ipairs(opts.ensure_installed) do
                local p = mr.get_package(tool)
                if not p:is_installed() then
                    p:install()
                end
            end
        end,
    },
}
