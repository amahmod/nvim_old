local M = {}

local function diagnostic_goto(next, severity)
    local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
    severity = severity and vim.diagnostic.severity[severity] or nil
    return function()
        go { severity = severity }
    end
end

-- stylua: ignore start
local keymaps = {
    { 'n', 'gd', vim.lsp.buf.definition, '[G]oto [D]efinition' },
    { 'n', 'gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration' },
    { 'n', 'gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences' },
    { 'n', 'gy', vim.lsp.buf.type_definition, 'Type [D]efinition' },
    { 'n', 'gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation' },
    { 'n', 'gi', require('telescope.builtin').lsp_incoming_calls, 'Incoming calls' },
    { 'n', 'go', require('telescope.builtin').lsp_outgoing_calls, 'Outgoing calls' },
    { 'n', 'K', vim.lsp.buf.hover, 'Hover Documentation' },
    { 'n', 'gK', vim.lsp.buf.signature_help, 'Signature Documentation' },
    { 'n', '<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction' },
    { 'n', '<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame' },
    { 'i', '<C-i>', vim.lsp.buf.signature_help, 'Signature Documentation' },



	  {'n', '[d', diagnostic_goto(true), 'Next Diagnostic'},
	  {'n', ']d', diagnostic_goto(false), 'Previous Diagnostic'},
	  {'n', ']e', diagnostic_goto(true, 'ERROR'), 'Next Error'},
	  {'n', '[e', diagnostic_goto(false, 'ERROR'), 'Previous Error'},
	  {'n', ']w', diagnostic_goto(true, 'WARNING'), 'Next Warning'},
	  {'n', '[w', diagnostic_goto(false, 'WARNING'), 'Previous Warning'},
	  {'n', '<leader>df', vim.diagnostic.open_float, '[D]iagnostic [F]loat (current line)'},

    -- Lesser used LSP features
    { 'n', '<localleader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder' },
    { 'n', '<localleader>wl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, '[W]orkspace [L]ist Folders' },
    { 'n', '<localleader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder' },
}
-- stylua: ignore end

function M.on_attach(_, bufnr)
    local map = function(mode, keys, func, desc)
        if desc then
            desc = 'LSP: ' .. desc
        end

        vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = desc })
    end

    for _, keymap in ipairs(keymaps) do
        map(keymap[1], keymap[2], keymap[3], keymap[4])
    end
end

return M
