local state = { floating = { buf = -1, win = -1 } }

-- Pass in width height and buf
local function create_floating_window(opts)
  opts = opts or {}

  -- Get current editor dimensions
  local ui = vim.api.nvim_list_uis()[1]
  local total_width = ui.width
  local total_height = ui.height

  -- Width and height, or set default
  local width = opts.width or math.floor(total_width * 0.65)
  local height = opts.height or math.floor(total_height * 0.65)

  -- Window position: centered horizontally, slightly above center vertically
  local row = math.floor((total_height - height) * 0.4)
  local col = math.floor((total_width - width) / 2)

  local buf = nil
  if vim.api.nvim_buf_is_valid(opts.buf) then
    buf = opts.buf
  else
    buf = vim.api.nvim_create_buf(false, true)
  end

  -- Floating window options
  local window_opts = {
    style = 'minimal',
    relative = 'editor',
    width = width,
    height = height,
    row = row,
    col = col,
    border = 'bold',
    title = '  Terminal ',
    title_pos = 'center',
  }

  -- Open the window
  local window_id = vim.api.nvim_open_win(buf, true, window_opts)

  -- Set window background to the same as normal
  vim.wo[window_id].winhl = 'Normal:normal'

  return { buf = buf, win = window_id }
end

local toggleTerminal = function()
  if not vim.api.nvim_win_is_valid(state.floating.win) then
    state.floating = create_floating_window({ buf = state.floating.buf })
    if vim.bo[state.floating.buf].buftype ~= 'terminal' then
      vim.cmd.terminal()
    end
  else
    vim.api.nvim_win_hide(state.floating.win)
  end
end

vim.keymap.set({ 'n', 't' }, '<C-s>', toggleTerminal, { desc = '[s]hell' })

-- Autocommand to enter insert mode in terminals
vim.api.nvim_create_autocmd({ 'BufEnter', 'TermOpen' }, {
  group = vim.api.nvim_create_augroup('floaterminal', { clear = true }),
  desc = 'Automatically enter Insert mode in terminals',
  pattern = '*',
  callback = function()
    if vim.bo.buftype == 'terminal' then
      vim.cmd('startinsert')
    end
  end,
})
