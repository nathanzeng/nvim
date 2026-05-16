-- There are some great use cases in this link
-- https://www.reddit.com/r/neovim/comments/1f7jj15/how_do_you_work_without_diffviewnvim/

vim.schedule(function()
  vim.pack.add({ 'https://github.com/dlyongemallo/diffview.nvim' })

  require('diffview').setup({
    show_root_path = false, -- Whether to show repo root path
    show_help_hints = false,
    file_panel = {
      win_config = {
        position = 'bottom',
        height = 10,
        -- Maintain the full cursorline in the file panel
        win_opts = { cursorlineopt = 'both' },
      },
    },
    -- Keymaps
    keymaps = {
      file_panel = {
        {
          'n',
          'gf',
          function()
            require('diffview.config').actions.goto_file_edit_close()
          end,
          { desc = '[g]o to [f]ile' },
        },
      },
      view = {
        {
          'n',
          'gf',
          function()
            require('diffview.config').actions.goto_file_edit_close()
          end,
          { desc = '[g]o to [f]ile' },
        },
      },
    },
  })

  vim.keymap.set('n', '<leader>gd', vim.cmd.DiffviewToggle, { desc = '[d]iff' })
end)
