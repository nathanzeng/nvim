vim.api.nvim_set_hl(0, 'winbar_mode', { fg = '#2e3440', bg = '#88C0D0' })
vim.api.nvim_set_hl(0, 'winbar_mode_invert', { fg = '#88C0D0', bg = '#2e3440' })

vim.api.nvim_set_hl(0, 'winbar_filename', { fg = '#2e3440', bg = '#88C0D0', bold = true })
vim.api.nvim_set_hl(
  0,
  'winbar_mode_filename_invert',
  { fg = '#88C0D0', bg = '#2e3440', bold = true }
)

vim.api.nvim_set_hl(0, 'winbar_c', { fg = '#8FBCBB', bg = '#4C566A' })

-- TODO: for some reason the operating pending and replace do not work
local mode_component = function()
  -- Note: termcodes \19 and \22 are ^S and ^V
  ---- stylua: ignore
  local mode_settings = {
    ['n'] = { name = 'NORMAL', hl = 'Normal' },
    ['no'] = { name = 'OP-PENDING', hl = 'Pending' },
    ['nov'] = { name = 'OP-PENDING', hl = 'Pending' },
    ['noV'] = { name = 'OP-PENDING', hl = 'Pending' },
    ['no\22'] = { name = 'OP-PENDING', hl = 'Pending' },
    ['niI'] = { name = 'NORMAL', hl = 'Normal' },
    ['niR'] = { name = 'NORMAL', hl = 'Normal' },
    ['niV'] = { name = 'NORMAL', hl = 'Normal' },
    ['nt'] = { name = 'NORMAL', hl = 'Normal' },
    ['ntT'] = { name = 'NORMAL', hl = 'Normal' },
    ['v'] = { name = 'VISUAL', hl = 'Visual' },
    ['vs'] = { name = 'VISUAL', hl = 'Visual' },
    ['V'] = { name = 'V-LINE', hl = 'Visual' },
    ['Vs'] = { name = 'V-LINE', hl = 'Visual' },
    ['\22'] = { name = 'V-BLOCK', hl = 'Visual' },
    ['\22s'] = { name = 'V-BLOCK', hl = 'Visual' },
    ['s'] = { name = 'SELECT', hl = 'Insert' },
    ['S'] = { name = 'S-LINE', hl = 'Normal' },
    ['\19'] = { name = 'S-BLOCK', hl = 'Normal' },
    ['i'] = { name = 'INSERT', hl = 'Insert' },
    ['ic'] = { name = 'INSERT', hl = 'Insert' },
    ['ix'] = { name = 'INSERT', hl = 'Insert' },
    ['R'] = { name = 'REPLACE', hl = 'Replace' },
    ['Rc'] = { name = 'REPLACE', hl = 'Replace' },
    ['Rx'] = { name = 'REPLACE', hl = 'Replace' },
    ['Rv'] = { name = 'V-REPLACE', hl = 'Replace' },
    ['Rvc'] = { name = 'V-REPLACE', hl = 'Replace' },
    ['Rvx'] = { name = 'V-REPLACE', hl = 'Replace' },
    ['c'] = { name = 'COMMAND', hl = 'Command' },
    ['cv'] = { name = 'EX', hl = 'Command' },
    ['ce'] = { name = 'EX', hl = 'Command' },
    ['r'] = { name = 'REPLACE', hl = 'Normal' },
    ['rm'] = { name = 'MORE', hl = 'Normal' },
    ['r?'] = { name = 'CONFIRM', hl = 'Normal' },
    ['!'] = { name = 'SHELL', hl = 'Normal' },
    ['t'] = { name = 'TERMINAL', hl = 'Command' },
  }

  local mode = mode_settings[vim.fn.mode()] or {}

  return table.concat({
    '%#winbar_mode_invert#',
    '%#winbar_mode#' .. mode.name,
    '%#winbar_mode_invert#',
  })
end

local filename_component = function()
  local expr = '%t%m'

  if vim.b.nvim_dir ~= nil then
    expr = '%f'
  end

  return table.concat({
    '%#winbar_filename_invert#',
    '%#winbar_filename#' .. expr,
    '%#winbar_filename_invert#',
  })
end

local function inactive()
  return '%#winbar_c#' .. vim.fn.expand('%:p:.')
end

-- TODO: I would like to remove the colon from the diagnostics
-- likely need to tweak vim.diagnostic.status()
-- these also don't update and the exact instant that i want
local function diagnostics()
  return " %{% luaeval('(package.loaded[''vim.diagnostic''] and next(vim.diagnostic.count()) and vim.diagnostic.status() .. '' '') or '''' ') %}"
end

return {
  render = function()
    local active_win = vim.fn.win_getid()
    local status_win = tonumber(vim.g.actual_curwin)

    if status_win ~= active_win then
      return inactive()
    end

    return table.concat({
      filename_component(),
      diagnostics(),
      '%=', -- Left/right separator
      mode_component(),
    })
  end,
}
