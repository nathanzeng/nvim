vim.api.nvim_set_hl(0, 'StatusLine', { bg = '#2e3440', fg = '#2e3440' })
vim.api.nvim_set_hl(0, 'StatusLineNC', { bg = '#2e3440', fg = '#2e3440' })
vim.api.nvim_set_hl(0, 'statusline_branch', { fg = '#88C0D0', bg = '#4C566A' })
vim.api.nvim_set_hl(0, 'statusline_branch_invert', { fg = '#4C566A', bg = '#2e3440' })
vim.api.nvim_set_hl(0, 'inactive_statusline_branch', { fg = '#4C566A', bg = '#2e3440' })

local head = vim.g.gitsigns_head or ''

-- Without this autocmd, the branch will show up empty on initial cold-start of nvim
vim.api.nvim_create_autocmd('User', {
  group = vim.api.nvim_create_augroup('statusline_nathan', { clear = true }),
  pattern = 'GitSignsUpdate',
  callback = function()
    vim.schedule(function()
      local new_head = vim.g.gitsigns_head or ''
      if new_head ~= head then
        head = new_head
        vim.cmd('redrawstatus')
      end
    end)
  end,
})

local function git_branch_component()
  if head == '' then
    return ''
  else
    return table.concat({
      '%#statusline_branch_invert#',
      '%#statusline_branch#' .. ' ' .. head,
      '%#statusline_branch_invert#',
    })
  end
end

local function inactive()
  return '%#inactive_statusline_branch#' .. ' ' .. head
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
