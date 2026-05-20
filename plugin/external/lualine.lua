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
}

local custom_nord = {
  normal = normalTheme,
  insert = normalTheme,
  visual = normalTheme,
  replace = normalTheme,
  command = normalTheme,
  inactive = {
    c = { fg = colors.nord7, bg = colors.nord3 },
  },
}

local function progress()
  return ' ' .. vim.fn.line('.') .. '/' .. vim.api.nvim_buf_line_count(0)
end

local function column()
  -- nf-fa-arrows_h
  return ' ' .. vim.fn.col('.')
end

local function truncateToFirstChar(min_width)
  return function(str)
    if vim.fn.winwidth(0) < min_width then
      return str:sub(1, 1)
    end
    return str
  end
end

-- Extension for oil
local oil = {
  winbar = {
    lualine_a = {
      function()
        local oil = require('oil')
        -- Directory relative to current working directory
        local directory = vim.fn.fnamemodify(oil.get_current_dir(), ':.')

        if directory == '' then
          -- Only the tail (final directory) of the cwd
          return '󰉋 ' .. vim.fn.fnamemodify(vim.fn.getcwd(), ':t')
        else
          return '󰙅 ' .. directory
        end
      end,
    },
    lualine_b = { { 'branch', icon = '' } },
    lualine_x = {},
    lualine_y = { progress, column },
    lualine_z = { 'mode' },
  },
  filetypes = { 'oil' },
}

local function path()
  -- Cannot do just `:h` because buffers jumped to with LSP will display full path
  local dir = vim.fn.expand('%:p:.:h')

  if dir == '.' then
    return ''
  else
    return dir
  end
end

require('lualine').setup({
  options = {
    theme = custom_nord,
    section_separators = { left = '', right = '' },
    component_separators = { left = '│', right = '│' },
    -- TODO: would be nice if I could do this for the diffed files in the diffview too
    disabled_filetypes = { winbar = { 'qf', 'DiffviewFiles', 'dap-view', 'dap-repl' } },
  },
  winbar = {
    lualine_a = {
      { 'filetype', separator = '', icon_only = true, colored = false, padding = { left = 1, right = 0 } },
      { 'filename', path = 0, file_status = false, padding = { left = 0, right = 1 } },
    },
    lualine_b = { 'diagnostics', 'diff', { 'branch', icon = '' } },
    lualine_c = { path },
    lualine_x = {},
    lualine_y = { progress, column },
    lualine_z = { { 'mode', fmt = truncateToFirstChar(101) } },
  },
  inactive_winbar = {
    lualine_c = { { 'filename', path = 1 } },
    lualine_x = { progress },
  },
  sections = {},
  inactive_sections = {},
  extensions = { oil },
})
