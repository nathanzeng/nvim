vim.keymap.set('n', '<leader>w', '<cmd>w<CR>', { desc = '[w]rite' })
vim.keymap.set('n', '<leader>x', '<cmd>qa<CR>', { desc = 'Quit' })
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- j and k move by screen lines when no count prefix
vim.keymap.set({ 'n', 'x' }, 'j', [[v:count == 0 ? 'gj' : 'j']], { expr = true })
vim.keymap.set({ 'n', 'x' }, 'k', [[v:count == 0 ? 'gk' : 'k']], { expr = true })

-- Better H and L
vim.keymap.set({ 'n', 'o' }, 'L', '$', { desc = 'Go to last character of line' })
vim.keymap.set('x', 'L', '$h', { desc = 'Go to last character of line (excluding EOL)' })
vim.keymap.set({ 'n', 'x', 'o' }, 'H', '^', { desc = 'Go to first non-blank character of line' })

-- Bash style keymaps (these do override native maps)
vim.keymap.set('i', '<C-e>', '<Esc>A', { desc = 'Go to end of line' })
vim.keymap.set('i', '<C-a>', '<Esc>I', { desc = 'Go to beginning of line' })

-- Enter and Shift+Enter to get new line below and above without entering insert mode
vim.keymap.set('n', '<CR>', 'o<Esc>')
vim.keymap.set('n', '<S-CR>', 'O<Esc>')

-- Revert the <CR> mapping in a couple places
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'qf' },
  callback = function()
    vim.keymap.set('n', '<CR>', '<CR>', { buffer = true })
  end,
})
vim.api.nvim_create_autocmd('CmdwinEnter', {
  pattern = { '*' },
  callback = function()
    vim.keymap.set('n', '<CR>', '<CR>', { buffer = true })
  end,
})

-- Alternate file (last edited file)
vim.keymap.set('n', '<BS>', '<C-^>')

-- Clear highlights on search when pressing <Esc> in normal mode
-- See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- TODO: would be nice if there was a plug mapping for this
vim.keymap.set(
  'n',
  '<C-c>',
  '<Cmd>nohlsearch<Bar>diffupdate'
    .. '<Bar>call nvim_buf_clear_namespace(0, nvim_create_namespace("nvim.multicursor"), 0, -1)'
    .. '<Bar>normal! <C-L><CR>',
  { desc = ':help CTRL-L-default' }
)

-- q to quit
vim.keymap.set('n', 'q', function()
  local ok, err = pcall(vim.cmd.hide)
  if ok then
    return
  end

  if err:match('E444') then
    local confirm = vim.fn.confirm('Exit Neovim?', '&yes\n&no')
    if confirm == 1 then
      vim.cmd.quit()
    end
  else
    error(err)
  end
end)

-- Leader q get normal q
vim.keymap.set('n', '<leader>q', 'q', { desc = 'macro' })

-- Paste does not clobber default register with deleted text (visual mode)
-- See `:h v_P` and `:h v_p`
vim.keymap.set('x', 'p', 'P')
vim.keymap.set('x', 'P', 'p')
-- Paste from yank register
vim.keymap.set({ 'n', 'x' }, '<leader>op', '"0p', { desc = 'Paste from yank register "0' })

vim.keymap.set('i', '<C-l>', '<Esc>gUiw`]a', { desc = 'Caps [l]ock the word before cursor' })

-- Restart neovim
vim.keymap.set('n', '<leader>rr', '<cmd>restart<CR>', { desc = '[r]estart' })
vim.keymap.set('n', '<leader>rb', '<cmd>restart!<CR>', { desc = '[r]estart! [b]ang' })

-- Window movement
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Resize windows
vim.keymap.set('n', '<C-left>', '<C-w><', { desc = 'Decrease window width' })
vim.keymap.set('n', '<C-right>', '<C-w>>', { desc = 'Increase window width' })
vim.keymap.set('n', '<C-up>', '<C-w>-', { desc = 'Decrease window height' })
vim.keymap.set('n', '<C-down>', '<C-w>+', { desc = 'Increase window height' })

-- [[ Diagnostics ]]
vim.keymap.set(
  'n',
  '<leader>E',
  vim.diagnostic.setloclist,
  { desc = 'Diagnostic quickfix list, for buffer' }
)
vim.keymap.set('n', '<leader>e', function()
  vim.diagnostic.open_float()
end, { desc = '[e]rror diagnostic window' })
vim.keymap.set('n', ']e', ']d', { desc = 'Jump to next [e]rror diagnostic', remap = true })
vim.keymap.set('n', '[e', '[d', { desc = 'Jump to next [e]rror diagnostic', remap = true })

-- [[ Spell Check ]]
local function toggle_spell_check()
  vim.o.spell = not vim.o.spell
  if vim.o.spell then
    vim.notify('Spell check enabled')
  else
    vim.notify('Spell check disabled')
  end
end

-- NOTE: I'm making this z for now so I remember z= for the suggestions, may want to remap
vim.keymap.set('n', '<leader>z', toggle_spell_check, { desc = 'Toggle spell check' })
-- Treate camel cased as separate words
vim.o.spelloptions = 'camel'

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank'),
  callback = function()
    vim.hl.hl_op()
  end,
})

-- Copies the filename (with path relative to cwd)
vim.keymap.set('n', '<leader>af', function()
  local filename = vim.fn.expand('%:~')
  vim.fn.setreg('+', filename)
  vim.notify('Copied to clipboard: ' .. filename)
end, { desc = 'Copy file relative path to clipboard' })

-- Copies the filename (with path relative to cwd) and line number to clipboard
vim.keymap.set('n', '<leader>al', function()
  local location = ('%s line %s'):format(vim.fn.expand('%:~'), vim.api.nvim_win_get_cursor(0)[1])
  vim.fn.setreg('+', location)
  vim.notify('Copied to clipboard: ' .. location)
end, { desc = 'Copy file relative path and line number to clipboard' })

-- QOL to reselect the selection after indent/dedent
vim.keymap.set('x', '>', '>gv', { desc = 'Indent visual selection' })
vim.keymap.set('x', '<', '<gv', { desc = 'Dedent visual selection' })

-- Need to recursively map since matchit plugin extends % functionality
vim.keymap.set({ 'n', 'x', 'o' }, 'M', '%', { remap = true, desc = '[M]atch it' })
