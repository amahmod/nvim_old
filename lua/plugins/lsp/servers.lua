return {
    html = {},
    emmet_ls = {},
    rust_analyzer = {
        settings = {
            diagnostics = {
                enable = true,
            },
        },
    },
    bashls = {},
    -- denols = {}, -- FIX: conflict with tsserver/typescript tools
    yamlls = {},
    dockerls = {},
    gopls = {
        settings = {
            hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
            },
        },
    },
    sqlls = {},
    svelte = {},
    volar = {},
    eslint = {},
    tailwindcss = {},
    graphql = {},
    marksman = {},
    cssls = {},
    jsonls = {},
    lua_ls = {
        settings = {
            Lua = {
                hint = {
                    enable = true,
                    showParameterName = true,
                },
                workspace = {
                    checkThirdParty = false,
                    library = vim.api.nvim_get_runtime_file('', true),
                },
                telemetry = { enable = false },
                completion = {
                    callSnippet = 'Replace',
                },
                diagnostics = {
                    globals = {
                        'vim',
                        'use',
                        'describe',
                        'it',
                        'assert',
                        'before_each',
                        'after_each',
                    },
                },
            },
        },
    },
}
