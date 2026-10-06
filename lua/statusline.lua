vim.api.nvim_set_hl(0, 'StatusLine', { bg = '#2e3440', fg = '#2e3440' })
vim.api.nvim_set_hl(0, 'StatusLineNC', { bg = '#2e3440', fg = '#2e3440' })

vim.api.nvim_set_hl(0, 'statusline_branch', { fg = '#88C0D0', bg = '#4C566A' })
vim.api.nvim_set_hl(0, 'statusline_branch_invert', { fg = '#4C566A', bg = '#2e3440' })

vim.api.nvim_set_hl(0, 'inactive_statusline_branch', { fg = '#4C566A', bg = '#2e3440' })

-- TODO: the branch does not show on initial cold start of nvim
local function git_branch_component()
  local branch = vim.g.gitsigns_head or ''
  return table.concat({
    '%#statusline_branch_invert#',
    '%#statusline_branch#' .. ' ' .. branch,
    '%#statusline_branch_invert#',
  })
end

local function inactive()
  local branch = vim.g.gitsigns_head or ''
  return '%#inactive_statusline_branch#' .. ' ' .. branch
end

return {
  render = function()
    local active_win = vim.fn.win_getid()
    local status_win = tonumber(vim.g.actual_curwin)

    if status_win ~= active_win then
      return inactive()
    end

    return table.concat({
      git_branch_component(),
      '%*',
    })
  end,
}
