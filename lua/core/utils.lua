local M = {}

M.user_terminals = {}

function M.add_cmp_source(source, priority)
  if type(priority) ~= 'number' then priority = 1000 end
  local cmp_avail, cmp = pcall(require, 'cmp')
  if cmp_avail then
    local config = cmp.get_config()
    table.insert(config.sources, {name = source, priority = priority})
    cmp.setup(config)
  end
end

-- term_details can be either a string for just a command or
-- a complete table to provide full access to configuration when calling Terminal:new()
function M.toggle_term_cmd(term_details)
  if type(term_details) == 'string' then term_details = {cmd = term_details, hidden = true} end
  local cmd = term_details.cmd
  if M.user_terminals[cmd] == nil then
    M.user_terminals[cmd] = require('toggleterm.terminal').Terminal:new(term_details)
  end
  M.user_terminals[cmd]:toggle()
end

M.toggle_qf = function()
  local qf_exists = false
  for _, win in pairs(vim.fn.getwininfo()) do if win['quickfix'] == 1 then qf_exists = true end end
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

return M
