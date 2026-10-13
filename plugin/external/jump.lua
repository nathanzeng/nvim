vim.pack.add({ 'https://github.com/yorickpeterse/nvim-jump' })

require('jump').setup({
  label = 'CurSearch',
})

vim.keymap.set('n', [[\]], ',', { desc = 'Repeat latest f, t, F or T in opposite direction' })
vim.keymap.set({ 'n', 'x', 'o' }, ',', require('jump').start, {})
