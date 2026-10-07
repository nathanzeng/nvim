-- 24 bit color
vim.o.termguicolors = true

-- Add line numbers and make them relative
vim.o.number = true
vim.o.relativenumber = true

-- [[ Command Line Stuff ]]
-- Don't show the mode
vim.o.showmode = false
-- Don't show this ruler thing that is line number and file progress
vim.o.ruler = false
-- Show partial command flickers j and k when scrolling
vim.o.showcmd = false

-- Sync clipboard between OS and Neovim.
vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end)

-- Only highlight the cursorline number
vim.o.cursorline = true
vim.o.cursorlineopt = 'number'

-- Enable break indent
vim.o.breakindent = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.o.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250

-- Configure how new splits should be opened
vim.o.splitright = true
vim.o.splitbelow = true

-- Show various whitespace characters
vim.o.list = true
vim.o.listchars = 'trail:·,nbsp:␣,tab:»·'

-- These will get overridden by .editorconfig
vim.o.expandtab = true -- Use spaces instead of tabs
vim.o.shiftwidth = 2 -- Size of an indent
vim.o.tabstop = 2 -- Number of spaces tabs count for

-- Do not insert comments automatically with o and O
vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('options'),
  desc = 'Do not insert comments automatically with o and O',
  pattern = '*',
  callback = function()
    vim.opt.formatoptions:remove('o')
  end,
})

-- Preview substitutions live, as you type
vim.o.inccommand = 'split'

-- Minimal number of screen lines to keep above and below the cursor
vim.o.scrolloff = 10

-- Confirm unsaved changes
vim.o.confirm = true

-- Globally set window borders to rounded
vim.o.winborder = 'rounded'

vim.o.swapfile = false

-- Defaults minus terminal (terminal state isn't preserved anyway)
vim.o.sessionoptions = 'blank,buffers,curdir,folds,help,tabpages,winsize'

-- Custom statusline
vim.o.statusline = "%{%v:lua.require'statusline'.render()%}"
