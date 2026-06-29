-- Move by subwords in camel case and snake case
vim.pack.add({ 'https://github.com/chrisgrieser/nvim-spider' })

-- Don't like the punctuation speedup, for instance try see how it behaves on the comma
require('spider').setup({
  skipInsignificantPunctuation = false,
})

vim.keymap.set({ 'n', 'o', 'x' }, 'w', "<cmd>lua require('spider').motion('w')<CR>")
vim.keymap.set({ 'n', 'o', 'x' }, 'e', "<cmd>lua require('spider').motion('e')<CR>")
vim.keymap.set({ 'n', 'o', 'x' }, 'b', "<cmd>lua require('spider').motion('b')<CR>")
vim.keymap.set({ 'n', 'o', 'x' }, 'ge', "<cmd>lua require('spider').motion('ge')<CR>")
