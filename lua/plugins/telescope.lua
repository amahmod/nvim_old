local custom_actions = {}

function custom_actions.send_to_qflist(prompt_bufnr)
    require('telescope.actions').send_to_qflist(prompt_bufnr)
    vim.api.nvim_command [[ botright copen ]]
end

function custom_actions.smart_send_to_qflist(prompt_bufnr)
    require('telescope.actions').smart_send_to_qflist(prompt_bufnr)
    vim.api.nvim_command [[ botright copen ]]
end

--- Scroll the results window up
---@param prompt_bufnr number: The prompt bufnr
function custom_actions.results_scrolling_up(prompt_bufnr)
    custom_actions.scroll_results(prompt_bufnr, -1)
end

--- Scroll the results window down
---@param prompt_bufnr number: The prompt bufnr
function custom_actions.results_scrolling_down(prompt_bufnr)
    custom_actions.scroll_results(prompt_bufnr, 1)
end

---@param prompt_bufnr number: The prompt bufnr
---@param direction number: 1|-1
function custom_actions.scroll_results(prompt_bufnr, direction)
    local status = require('telescope.state').get_status(prompt_bufnr)
    local default_speed = vim.api.nvim_win_get_height(status.results_win) / 2
    local speed = status.picker.layout_config.scroll_speed or default_speed

    require('telescope.actions.set').shift_selection(prompt_bufnr, math.floor(speed) * direction)
end

-- Custom pickers

local plugin_directories = function(opts)
    local actions = require 'telescope.actions'
    local utils = require 'telescope.utils'
    local dir = vim.fn.stdpath 'data' .. '/lazy'

    opts = opts or {}
    opts.cmd = vim.F.if_nil(opts.cmd, {
        vim.o.shell,
        '-c',
        'find ' .. vim.fn.shellescape(dir) .. ' -mindepth 1 -maxdepth 1 -type d',
    })

    local dir_len = dir:len()
    opts.entry_maker = function(line)
        return {
            value = line,
            ordinal = line,
            display = line:sub(dir_len + 2),
        }
    end

    require('telescope.pickers')
        .new(opts, {
            layout_config = {
                width = 0.65,
                height = 0.7,
            },
            prompt_title = '[ Plugin directories ]',
            finder = require('telescope.finders').new_table {
                results = utils.get_os_command_output(opts.cmd),
                entry_maker = opts.entry_maker,
            },
            sorter = require('telescope.sorters').get_fuzzy_file(),
            previewer = require('telescope.previewers.term_previewer').cat.new(opts),
            attach_mappings = function(prompt_bufnr)
                actions.select_default:replace(function()
                    local entry = require('telescope.actions.state').get_selected_entry()
                    actions.close(prompt_bufnr)
                    vim.cmd.tcd(entry.value)
                end)
                return true
            end,
        })
        :find()
end

-- Custom window-sizes
---@param dimensions table
---@param size integer
---@return float
local function get_matched_ratio(dimensions, size)
    for min_cols, scale in pairs(dimensions) do
        if min_cols == 'lower' or size >= min_cols then
            return math.floor(size * scale)
        end
    end
    return dimensions.lower
end

local function width_tiny(_, cols, _)
    return get_matched_ratio({ [180] = 0.27, lower = 0.37 }, cols)
end

local function width_small(_, cols, _)
    return get_matched_ratio({ [180] = 0.4, lower = 0.5 }, cols)
end

local function width_medium(_, cols, _)
    return get_matched_ratio({ [180] = 0.5, [110] = 0.6, lower = 0.75 }, cols)
end

local function width_large(_, cols, _)
    return get_matched_ratio({ [180] = 0.7, [110] = 0.8, lower = 0.85 }, cols)
end

-- Enable indent-guides in telescope preview
vim.api.nvim_create_autocmd('User', {
    pattern = 'TelescopePreviewerLoaded',
    group = vim.api.nvim_create_augroup('custom_telescope', {}),
    callback = function(args)
        if args.buf ~= vim.api.nvim_win_get_buf(0) then
            return
        end
        vim.opt_local.listchars = vim.wo.listchars .. ',tab:▏\\ '
        vim.opt_local.conceallevel = 0
        vim.opt_local.wrap = true
        vim.opt_local.list = true
        vim.opt_local.number = true
    end,
})

return {
    --  ════════════════════════════════════════════════════════════
    {
        'nvim-telescope/telescope.nvim',
        cmd = 'Telescope',
        dependencies = {
            'nvim-lua/plenary.nvim',
            -- 'olimorris/persisted.nvim',
        },
        config = function(_, opts)
            require('telescope').setup(opts)
            -- require('telescope').load_extension 'persisted'
        end,
		-- stylua: ignore start
		keys = {
			-- General pickers
			{ '<C-p>', '<cmd>Telescope find_files<CR>', desc = 'Find files' },
			{ '<leader>gf', function() require('telescope.builtin').find_files({ default_text = vim.fn.expand('<cword>'), }) end, desc = 'Find file', },

			{ '<leader>ss', '<cmd>Telescope live_grep<CR>', desc = '[S]earch [W]ord (live)' },
			{ '<leader>ss', function() require('telescope.builtin').live_grep({ default_text = require('lib.utils').get_visual_selection(), }) end, mode = 'x', desc = '[S]earch [W]ord (selection)', },
			{ '<leader>sS', function() require('telescope.builtin').live_grep({ default_text = vim.fn.expand('<cword>'), }) end, desc = '[S]earch [W]ord under cursor (live)', },
			{ '<leader>sw', '<cmd>Telescope grep_string<CR>', desc = '[S]earch/find [W]ord under cursor' },

			{ '<localleader>f', '<cmd>Telescope find_files<CR>', desc = 'Find files' },
			{ '<localleader>r', '<cmd>Telescope resume initial_mode=normal<CR>', desc = 'Resume last' },
			{ '<localleader>R', '<cmd>Telescope pickers<CR>', desc = 'Pickers' },
			{ '<localleader>b', '<cmd>Telescope buffers show_all_buffers=true<CR>', desc = 'Buffers' },

			{ '<leader>fs', '<cmd>Telescope spell_suggest<CR>', desc = '[F]ind [S]pell suggestions' },

			{ '<leader>fo', '<cmd>Telescope oldfiles<CR>', desc = 'Old files' },
			{ '<leader>fd', '<cmd>Telescope diagnostics bufnr=0<CR>', desc = '[F]ind [D]iagnostics' },
			{ '<leader>fD', '<cmd>Telescope diagnostics<CR>', desc = '[F]ind Workspace [D]iagnostics' },
			{ '<leader>fk', '<cmd>Telescope keymaps<CR>', desc = '[F]ind [K]eymaps' },
			{ '<leader>fc', '<cmd>Telescope colorscheme<CR>', desc = '[F]ind [C]olorscheme' },
			{ '<leader>ff', '<cmd>Telescope current_buffer_fuzzy_find<CR>', desc = 'Buffer find' },
			{ '<leader>:', '<cmd>Telescope commands<CR>', desc = 'Commands' },
			{ '<leader>;', '<cmd>Telescope command_history<CR>', desc = 'Command history' },
			{ '<leader>/', '<cmd>Telescope search_history<CR>', desc = 'Search history' },

			-- LSP related
			{ '<leader>ca', ':Telescope lsp_range_code_actions<CR>', mode = 'x', desc = 'Code actions' },
			{ '<leader>ds', function() require('telescope.builtin').lsp_document_symbols({ symbols = { 'Class', 'Function', 'Method', 'Constructor', 'Interface', 'Module', 'Struct', 'Trait', 'Field', 'Property', }, }) end, desc = '[D]ocument [S]ymbols', },
			{ '<leader>ws', function() require('telescope.builtin').lsp_dynamic_workspace_symbols({ symbols = { 'Class', 'Function', 'Method', 'Constructor', 'Interface', 'Module', 'Struct', 'Trait', 'Field', 'Property', }, }) end, desc = '[W]orkspace [S]ymbols', },
			{ '<leader>dS', function() require('telescope.builtin').lsp_document_symbols({ default_text = vim.fn.expand('<cword>'), }) end, desc = '[D]ocument [S]ymbols (word under cursor)', },
			{ '<leader>wS', function() require('telescope.builtin').lsp_document_symbols({ default_text = vim.fn.expand('<cword>'), }) end, desc = '[W]workspace [S]ymbols (word under cursor)', },

			-- Git
			{ '<leader>gs', '<cmd>Telescope git_status<CR>', desc = 'Git status' },
			{ '<leader>gb', '<cmd>Telescope git_branches<CR>', desc = 'Git branches' },
			{ '<leader>gc', '<cmd>Telescope git_commits<CR>', desc = 'Git commits' },
			{ '<leader>gC', '<cmd>Telescope git_bcommits<CR>', desc = 'Git buffer commits' },
			{ '<leader>gh', '<cmd>Telescope git_stash<CR>', desc = 'Git stashes' },
			{ '<leader>gc', '<cmd>Telescope git_bcommits_range<CR>', mode = { 'x' }, desc = 'Git bcommits range' },

            -- Lesser used keymaps
			{ '<leader>fh', '<cmd>Telescope help_tags<CR>', desc = 'Help Pages' },
			{ '<leader>fj', '<cmd>Telescope jumplist<CR>', desc = 'Jump list' },
			{ '<leader>fr', '<cmd>Telescope registers<CR>', desc = 'Registers' },
			{ '<leader>fm', '<cmd>Telescope marks<CR>', desc = 'Marks' },
			{ '<leader>fM', '<cmd>Telescope man_pages<CR>', desc = 'Man Pages' },
			{ '<leader>fO', '<cmd>Telescope vim_options<CR>', desc = 'Neovim options' },

            -- stylua: ignore end
		},
        opts = function()
            local transform_mod = require('telescope.actions.mt').transform_mod
            local actions = require 'telescope.actions'

            -- Transform to Telescope proper actions.
            custom_actions = transform_mod(custom_actions)

            return {
                defaults = {
                    sorting_strategy = 'ascending',
                    cache_picker = { num_pickers = 3 },

                    prompt_prefix = '  ', -- ❯  
                    selection_caret = '▍ ',
                    multi_icon = ' ',

                    path_display = { 'truncate' },
                    file_ignore_patterns = { 'node_modules' },
                    set_env = { COLORTERM = 'truecolor' },

                    layout_strategy = 'horizontal',
                    layout_config = {
                        prompt_position = 'top',
                        horizontal = {
                            height = 0.85,
                        },
                    },

                    mappings = {

                        i = {
                            ['jj'] = { '<Esc>', type = 'command' },

                            ['<Tab>'] = actions.move_selection_worse,
                            ['<S-Tab>'] = actions.move_selection_better,
                            ['<C-u>'] = actions.results_scrolling_up,
                            ['<C-d>'] = actions.results_scrolling_down,

                            ['<C-q>'] = custom_actions.smart_send_to_qflist,

                            ['<C-j>'] = actions.cycle_history_next,
                            ['<C-k>'] = actions.cycle_history_prev,

                            ['<C-n>'] = actions.move_selection_worse,
                            ['<C-p>'] = actions.move_selection_better,

                            ['<C-b>'] = actions.preview_scrolling_up,
                            ['<C-f>'] = actions.preview_scrolling_down,

                            ['<C-i>'] = function()
                                return require('telescope.builtin').find_files {
                                    no_ignore = true,
                                }
                            end, -- toggle ignore
                            ['<C-h>'] = function()
                                return require('telescope.builtin').find_files {
                                    hidden = true,
                                }
                            end, -- toggle hidden
                        },

                        n = {
                            ['q'] = actions.close,
                            ['<Esc>'] = actions.close,

                            ['<Tab>'] = actions.move_selection_worse,
                            ['<S-Tab>'] = actions.move_selection_better,
                            ['<C-u>'] = custom_actions.results_scrolling_up,
                            ['<C-d>'] = custom_actions.results_scrolling_down,

                            ['<C-b>'] = actions.preview_scrolling_up,
                            ['<C-f>'] = actions.preview_scrolling_down,

                            ['<C-j>'] = actions.cycle_history_next,
                            ['<C-k>'] = actions.cycle_history_prev,

                            ['*'] = actions.toggle_all,
                            ['u'] = actions.drop_all,
                            ['J'] = actions.toggle_selection
                                + actions.move_selection_next,
                            ['K'] = actions.toggle_selection
                                + actions.move_selection_previous,
                            [' '] = {
                                actions.toggle_selection
                                    + actions.move_selection_next,
                                type = 'action',
                                opts = { nowait = true },
                            },

                            ['sv'] = actions.select_horizontal,
                            ['sg'] = actions.select_vertical,
                            ['st'] = actions.select_tab,

                            ['w'] = custom_actions.smart_send_to_qflist,
                            ['e'] = custom_actions.send_to_qflist,

                            ['!'] = actions.edit_command_line,

                            ['t'] = function(...)
                                return require('trouble.providers.telescope').open_with_trouble(
                                    ...
                                )
                            end,
                        },
                    },
                },
                pickers = {
                    buffers = {
                        sort_lastused = true,
                        sort_mru = true,
                        show_all_buffers = true,
                        ignore_current_buffer = true,
                        layout_config = { width = width_large, height = 0.7 },
                        mappings = {
                            n = {
                                ['dd'] = actions.delete_buffer,
                            },
                        },
                    },
                    live_grep = {
                        dynamic_preview_title = true,
                    },
                    colorscheme = {
                        enable_preview = true,
                        layout_config = { preview_width = 0.7 },
                    },
                    highlights = {
                        layout_config = { preview_width = 0.7 },
                    },
                    vim_options = {
                        theme = 'dropdown',
                        layout_config = { width = width_medium, height = 0.7 },
                    },
                    command_history = {
                        theme = 'dropdown',
                        layout_config = { width = width_medium, height = 0.7 },
                    },
                    search_history = {
                        theme = 'dropdown',
                        layout_config = { width = width_small, height = 0.6 },
                    },
                    spell_suggest = {
                        theme = 'cursor',
                        layout_config = { width = width_tiny, height = 0.45 },
                    },
                    registers = {
                        theme = 'cursor',
                        layout_config = { width = 0.35, height = 0.4 },
                    },
                    oldfiles = {
                        theme = 'dropdown',
                        previewer = false,
                        layout_config = { width = width_medium, height = 0.7 },
                    },
                    lsp_definitions = {
                        layout_config = {
                            width = width_large,
                            preview_width = 0.55,
                        },
                    },
                    lsp_implementations = {
                        layout_config = {
                            width = width_large,
                            preview_width = 0.55,
                        },
                    },
                    lsp_references = {
                        layout_config = {
                            width = width_large,
                            preview_width = 0.55,
                        },
                    },
                    lsp_code_actions = {
                        theme = 'cursor',
                        previewer = false,
                        layout_config = { width = 0.3, height = 0.4 },
                    },
                    lsp_range_code_actions = {
                        theme = 'cursor',
                        previewer = false,
                        layout_config = { width = 0.3, height = 0.4 },
                    },
                },
                extensions = {
                    persisted = {
                        layout_config = { width = 0.55, height = 0.55 },
                    },
                },
            }
        end,
    },
}
