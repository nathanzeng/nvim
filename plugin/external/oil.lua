vim.pack.add({ 'https://github.com/nathanzeng/oil.nvim' })

require('oil').setup({
  view_options = {
    show_hidden = true,
  },
  -- These keymaps apply to oil buffers only
  keymaps = {
    -- Collides with floaterminal, was originally open file in a new tab
    ['<C-t>'] = false,
    -- Live grep in current directory
    ['<leader>fg'] = {
      function()
        require('telescope.builtin').live_grep({
          cwd = require('oil').get_current_dir(),
        })
      end,
      mode = 'n',
      --nowait to see if there is a longer key combo elsewhere
      nowait = true,
      desc = 'Live grep in the current directory',
    },
    -- Find files in current directory
    ['<leader>ff'] = {
      function()
        require('telescope.builtin').find_files({
          cwd = require('oil').get_current_dir(),
        })
      end,
      mode = 'n',
      nowait = true,
      desc = 'Find files in the current directory',
    },
    -- Use control v for opening in a vertical split so we match with telescope
    ['<C-v>'] = { 'actions.select', opts = { vertical = true, close = true } },
    ['<C-s>'] = false,
    -- Disable these two because I use them for window nav
    ['<C-h>'] = false,
    ['<C-l>'] = false,
    ['go'] = { 'actions.refresh' },
  },
})
vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Open parent directory' })
