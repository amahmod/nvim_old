local M = {}

M.toggle_quickfix = function()
    local qf_exists = false
    for _, win in pairs(vim.fn.getwininfo()) do
        if win['quickfix'] == 1 then
            qf_exists = true
        end
    end
    if qf_exists == true then
        vim.cmd 'cclose'
        return
    end
    vim.cmd 'copen'
    -- only open if the list is not empty
    -- if not vim.tbl_isempty(vim.fn.getqflist()) then
    --   vim.cmd "copen"
    -- end
end

--- Check if a plugin is defined in lazy. Useful with lazy loading
--- when a plugin is not necessarily loaded yet.
---@param plugin string The plugin to search for.
---@return boolean available # Whether the plugin is available.
function M.has_plugin(plugin)
    local lazy_config_avail, lazy_config = pcall(require, 'lazy.core.config')
    return lazy_config_avail and lazy_config.plugins[plugin] ~= nil
end

---@param on_attach fun(client, buffer)
function M.on_attach(on_attach)
    vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(args)
            local buffer = args.buf ---@type number
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            on_attach(client, buffer)
        end,
    })
end

-- Get visually selected lines.
-- Source: https://github.com/ibhagwan/fzf-lua/blob/main/lua/fzf-lua/utils.lua
---@return string
function M.get_visual_selection()
    -- this will exit visual mode
    -- use 'gv' to reselect the text
    local _, csrow, cscol, cerow, cecol
    local mode = vim.fn.mode()
    if mode == 'v' or mode == 'V' or mode == '' then
        -- if we are in visual mode use the live position
        _, csrow, cscol, _ = unpack(vim.fn.getpos '.')
        _, cerow, cecol, _ = unpack(vim.fn.getpos 'v')
        if mode == 'V' then
            -- visual line doesn't provide columns
            cscol, cecol = 0, 999
        end
        -- exit visual mode
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'n', true)
    else
        -- otherwise, use the last known visual position
        _, csrow, cscol, _ = unpack(vim.fn.getpos "'<")
        _, cerow, cecol, _ = unpack(vim.fn.getpos "'>")
    end
    -- swap vars if needed
    if cerow < csrow then
        csrow, cerow = cerow, csrow
    end
    if cecol < cscol then
        cscol, cecol = cecol, cscol
    end
    local lines = vim.fn.getline(csrow, cerow)
    -- local n = cerow-csrow+1
    local n = #lines
    if n <= 0 or type(lines) ~= 'table' then
        return ''
    end
    lines[n] = string.sub(lines[n], 1, cecol)
    lines[1] = string.sub(lines[1], cscol)
    return table.concat(lines, '\n')
end

local root_patterns = { '.git', '/lua' }

function M.get_root()
    local cwd = vim.loop.cwd()
    if cwd == '' or cwd == nil then
        return ''
    end
    local ok, cache = pcall(vim.api.nvim_buf_get_var, 0, 'project_dir')
    if ok and cache then
        local _, last_cwd = pcall(vim.api.nvim_buf_get_var, 0, 'project_dir_last_cwd')
        if cwd == last_cwd then
            return cache
        end
    end

    local root = vim.fs.find(root_patterns, { path = cwd, upward = true })[1]
    root = root and vim.fs.dirname(root) or vim.loop.cwd() or ''
    vim.api.nvim_buf_set_var(0, 'project_dir', root)
    vim.api.nvim_buf_set_var(0, 'project_dir_last_cwd', cwd)
    return root
end

local terminals = {}

-- Opens a floating terminal (interactive by default)
---@param cmd? string[]|string
---@param opts? LazyCmdOptions|{interactive?:boolean, esc_esc?:false, ctrl_hjkl?:false}
function M.float_term(cmd, opts)
    opts = vim.tbl_deep_extend('force', {
        ft = 'lazyterm',
        size = { width = 0.9, height = 0.9 },
    }, opts or {}, { persistent = true })
    ---@cast opts LazyCmdOptions|{interactive?:boolean, esc_esc?:false, ctrl_hjkl?:false}

    local termkey = vim.inspect {
        cmd = cmd or 'shell',
        cwd = opts.cwd,
        env = opts.env,
        count = vim.v.count1,
    }

    if terminals[termkey] and terminals[termkey]:buf_valid() then
        terminals[termkey]:toggle()
    else
        terminals[termkey] = require('lazy.util').float_term(cmd, opts)
        local buf = terminals[termkey].buf
        vim.b[buf].lazyterm_cmd = cmd
        if opts.esc_esc == false then
            vim.keymap.set('t', '<esc>', '<esc>', { buffer = buf, nowait = true })
        end
        if opts.ctrl_hjkl == false then
            vim.keymap.set('t', '<c-h>', '<c-h>', { buffer = buf, nowait = true })
            vim.keymap.set('t', '<c-j>', '<c-j>', { buffer = buf, nowait = true })
            vim.keymap.set('t', '<c-k>', '<c-k>', { buffer = buf, nowait = true })
            vim.keymap.set('t', '<c-l>', '<c-l>', { buffer = buf, nowait = true })
        end

        vim.api.nvim_create_autocmd('BufEnter', {
            buffer = buf,
            callback = function()
                vim.cmd.startinsert()
            end,
        })
    end

    return terminals[termkey]
end

return M
