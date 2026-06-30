vim.keymap.set('n', '<leader>w', '<cmd>w<CR>', { desc = '[w]rite' })
vim.keymap.set('n', '<leader>x', '<cmd>xa!<CR>', { desc = 'Quit [x]a!' })
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- j and k move by screen lines when no count prefix
vim.keymap.set({ 'n', 'x' }, 'j', [[v:count == 0 ? 'gj' : 'j']], { expr = true })
vim.keymap.set({ 'n', 'x' }, 'k', [[v:count == 0 ? 'gk' : 'k']], { expr = true })
-- Better H and L
vim.keymap.set({ 'n', 'o' }, 'L', '$', { desc = 'Go to last character of line' })
vim.keymap.set('x', 'L', '$h', { desc = 'Go to last character of line (excluding EOL)' })
vim.keymap.set({ 'n', 'x', 'o' }, 'H', '^', { desc = 'Go to first non-blank character of line' })

-- Enter and Shift+Enter to get new line below and above without entering insert mode
vim.keymap.set('n', '<CR>', 'o<Esc>')
vim.keymap.set('n', '<S-CR>', 'O<Esc>')
-- Undo the keybind for qf buffers
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'qf' },
  callback = function(ev)
    vim.keymap.set('n', '<CR>', '<CR>', { buf = ev.buf })
  end,
})

-- Alternate file (last edited file)
vim.keymap.set('n', '<BS>', '<C-^>')

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- q to quit and leader q to macro
vim.keymap.set('n', 'q', '<cmd>q<CR>', { desc = '[q]uit window' })
vim.keymap.set('n', '<leader>q', 'q', { desc = 'macro' })

-- Paste and yank to system clipboard
vim.keymap.set({ 'n', 'x' }, '<leader>p', '"+p', { desc = '[p]aste from system clipboard' })
vim.keymap.set({ 'n', 'x' }, '<leader>P', '"+P', { desc = '[P]aste from system clipboard' })
vim.keymap.set({ 'n', 'x' }, '<leader>y', '"+y', { desc = '[y]ank into system clipboard' })
vim.keymap.set('n', '<leader>Y', '"+y$', { desc = '[Y]ank into system clipboard' })
-- Paste from yank register
vim.keymap.set({ 'n', 'x' }, '<leader>op', '"0p', { desc = 'Paste from yank register "0' })

-- Note: native functionality is to delete everything on the line preceding the cursor
vim.keymap.set('i', '<C-u>', '<Esc>gUiw`]a', { desc = '[u]pper case the word before cursor' })

-- Restart neovim
vim.keymap.set('n', '<leader>n', '<cmd>restart<CR>', { desc = '[n]eovim restart' })
vim.keymap.set('n', '<leader>N', '<cmd>restart!<CR>', { desc = '[N]eovim restart!' })

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
vim.keymap.set('n', '<leader>D', vim.diagnostic.setloclist, { desc = 'Diagnostic quickfix list, for buffer' })
vim.keymap.set('n', '<leader>d', function()
  vim.diagnostic.open_float()
end, { desc = '[d]iagnostic window' })

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
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.hl_op()
  end,
})

-- Copies the file and line number to clipboard
vim.keymap.set('n', '<leader>a', function()
  local location = ('%s line %s'):format(vim.fn.expand('%:.'), vim.api.nvim_win_get_cursor(0)[1])
  vim.fn.setreg('+', location)
  vim.notify('Copied to clipboard: ' .. location)
end, { desc = 'Copy file relative path and line number to clipboard' })

vim.keymap.set({ 'x', 'o' }, 'ag', 'al', { desc = 'Buffer (ggG or something like this)' })
