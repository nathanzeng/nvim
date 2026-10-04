vim.api.nvim_set_hl(0, 'StatusLine', { bg = '#2e3440', fg = '#2e3440' })
vim.api.nvim_set_hl(0, 'StatusLineNC', { bg = '#2e3440', fg = '#2e3440' })

vim.api.nvim_set_hl(0, 'statusline_mode', { fg = '#88C0D0', bg = '#4C566A' })
vim.api.nvim_set_hl(0, 'statusline_mode_invert', { fg = '#4C566A', bg = '#2e3440' })

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
    '%#statusline_mode_invert#',
    '%#statusline_mode#' .. mode.name,
    '%#statusline_mode_invert#',
  })
end

local function inactive()
  return ''
end

local function git_branch_component()
  local branch = vim.g.gitsigns_head or ''
  return table.concat({
    '%#statusline_mode_invert#',
    '%#statusline_mode#' .. ' ' .. branch,
    '%#statusline_mode_invert#',
  })
end

return {
  render = function()
    local active_win = vim.fn.win_getid()
    local status_win = tonumber(vim.g.actual_curwin)

    if status_win ~= active_win then
      return inactive()
    end

    return table.concat({
      mode_component(),
      ' ',
      git_branch_component(),
      '%*',
    })
  end,
}
