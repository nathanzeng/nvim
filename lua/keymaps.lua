vim.keymap.set('n', '<leader>w', '<cmd>w<CR>', { desc = '[w]rite' })
vim.keymap.set('n', '<leader>x', '<cmd>xa!<CR>', { desc = 'Quit [x]a!' })
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Move by screen lines when no count prefix
vim.keymap.set({ 'n', 'x' }, 'j', [[v:count == 0 ? 'gj' : 'j']], { expr = true })
vim.keymap.set({ 'n', 'x' }, 'k', [[v:count == 0 ? 'gk' : 'k']], { expr = true })

-- Enter and Shift+Enter to get new line below and above without entering insert mode
vim.keymap.set('n', '<CR>', 'o<Esc>')
vim.keymap.set('n', '<S-CR>', 'O<Esc>')

-- Alternate file (last edited file)
vim.keymap.set('n', '<BS>', '<C-^>')

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- NOTE: the native functionality for q is to record a macro, removing that for now
vim.keymap.set('n', 'q', '<cmd>q<CR>', { desc = '[q]uit window' })

-- More ergonomic keymap for pasting from the yank register
vim.keymap.set({ 'n', 'x' }, '<leader>p', '"0p', { desc = '[p]aste from yank register "0' })

-- Note: native functionality is to delete everything on the line preceding the cursor
vim.keymap.set('i', '<C-u>', '<Esc>gUiw`]a', { desc = '[u]pper case the word before cursor' })

-- Restart neovim
vim.keymap.set('n', '<leader>n', '<cmd>restart<CR>', { desc = '[n]eovim restart' })

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

-- Undo my enter keybind for qf buffers
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'qf' },
  callback = function(ev)
    vim.keymap.set('n', '<CR>', '<CR>', { buf = ev.buf })
  end,
})

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
    vim.hl.on_yank()
  end,
})
