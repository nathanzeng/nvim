-- NOTE: not setting up leap from window or remote
vim.pack.add({ 'https://codeberg.org/andyg/leap.nvim.git' })
vim.keymap.set({ 'n', 'x', 'o' }, '\\', '<Plug>(leap)')
