vim.pack.add({ 'https://github.com/nvim-lualine/lualine.nvim' })

-- stylua: ignore
local colors = {
  nord1  = '#3B4252',
  nord3  = '#4C566A',
  nord5  = '#E5E9F0',
  nord6  = '#ECEFF4',
  nord7  = '#8FBCBB',
  nord8  = '#88C0D0',
  nord13 = '#EBCB8B',
}

local normalTheme = {
  a = function()
    if vim.bo.modified then
      return { fg = colors.nord1, bg = colors.nord6, gui = 'bold' }
    else
      return { fg = colors.nord1, bg = colors.nord8, gui = 'bold' }
    end
  end,
  b = { fg = colors.nord7, bg = colors.nord1 },
  c = { fg = colors.nord7, bg = colors.nord3 },
  z = { fg = colors.nord1, bg = colors.nord8, gui = 'bold' },
}

local custom_nord = {
  normal = normalTheme,
  insert = normalTheme,
  visual = normalTheme,
  replace = normalTheme,
  command = normalTheme,
  inactive = normalTheme,
}

local function cursor_pos()
  return ' '
    .. vim.fn.line('.')
    .. '/'
    .. vim.api.nvim_buf_line_count(0)
    -- nf-fa-arrows_h
    .. '   '
    .. vim.fn.col('.')
end

local function line_only()
  return ' ' .. vim.fn.line('.') .. '/' .. vim.api.nvim_buf_line_count(0)
end

local function path()
  -- Cannot do just `:h` because buffers jumped to with LSP will display full path
  local dir = vim.fn.expand('%:p:.:h')

  if dir == '.' then
    return ''
  else
    return dir
  end
end

local function dir_name()
  local global_cwd = vim.fn.getcwd(-1, -1, -1)
  local buf_cwd = vim.fn.getcwd(-1, -1, 0)
  local relpath = vim.fs.relpath(global_cwd, buf_cwd)

  if relpath == '.' then
    return '󰉋 ' .. vim.fn.fnamemodify(global_cwd, ':t')
  else
    return '󰙅 ' .. relpath .. '/'
  end
end

local function spacer()
  return ' '
end

-- Extension for dir.lua
local dir = {
  winbar = {
    lualine_a = {
      dir_name,
    },
    lualine_b = {},
    lualine_c = { spacer },
    lualine_x = {},
    lualine_y = { cursor_pos },
    lualine_z = {},
  },
  filetypes = { 'directory' },
}

require('lualine').setup({
  options = {
    theme = custom_nord,
    section_separators = { left = '', right = '' },
    component_separators = { left = '│', right = '│' },
    disabled_filetypes = { winbar = { 'qf', 'DiffviewFiles', 'dap-view', 'dap-repl' } },
  },
  winbar = {
    lualine_a = {
      {
        'filetype',
        separator = '',
        icon_only = true,
        colored = false,
        padding = { left = 1, right = 0 },
      },
      { 'filename', path = 0, file_status = false, padding = { left = 0, right = 1 } },
    },
    lualine_b = { 'diagnostics', 'diff' },
    lualine_c = { path },
    lualine_x = {},
    lualine_y = { cursor_pos },
    lualine_z = {},
  },
  inactive_winbar = {
    lualine_c = { { 'filename', path = 1 } },
    lualine_x = { line_only },
  },
  sections = {},
  inactive_sections = {},
  extensions = { dir },
})
