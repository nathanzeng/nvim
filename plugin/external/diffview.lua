-- There are some great use cases in this link
-- https://www.reddit.com/r/neovim/comments/1f7jj15/how_do_you_work_without_diffviewnvim/

vim.schedule(function()
  vim.pack.add({ 'https://github.com/dlyongemallo/diffview.nvim' })

  require('diffview').setup({
    show_root_path = false, -- Whether to show repo root path
    show_help_hints = false, -- Pretty sure this is g? most places
    file_panel = {
      win_config = {
        position = 'bottom',
        height = 10,
        -- Maintain the full cursorline in the file panel
        win_opts = { cursorlineopt = 'both' },
      },
    },
    -- Keymaps
    -- TODO: we can consolidate these to avoid duplication
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
        {
          'n',
          'ge',
          function()
            require('diffview.config').actions.goto_file_edit()
          end,
          { desc = '[g]o to file [e]dit' },
        },
        {
          'n',
          '<C-n>',
          function()
            require('diffview.config').actions.select_next_entry()
          end,
          { desc = '[n]ext entry' },
        },
        {
          'n',
          '<C-p>',
          function()
            require('diffview.config').actions.select_prev_entry()
          end,
          { desc = '[p]rev entry' },
        },
      },
      -- For view, I want to copy over some of the file panel keymaps
      view = {
        {
          'n',
          'gf',
          function()
            require('diffview.config').actions.goto_file_edit_close()
          end,
          { desc = '[g]o to [f]ile' },
        },
        {
          'n',
          'ge',
          function()
            require('diffview.config').actions.goto_file_edit()
          end,
          { desc = '[g]o to file [e]dit' },
        },
        {
          'n',
          '<C-n>',
          function()
            require('diffview.config').actions.select_next_entry()
          end,
          { desc = '[n]ext entry' },
        },
        {
          'n',
          '<C-p>',
          function()
            require('diffview.config').actions.select_prev_entry()
          end,
          { desc = '[p]rev entry' },
        },
        {
          'n',
          's',
          function()
            require('diffview.config').actions.toggle_stage_entry()
          end,
          { desc = '[s]tage entry toggle' },
        },
        {
          'n',
          'S',
          function()
            require('diffview.config').actions.stage_all()
          end,
          { desc = '[S]tage all' },
        },
        {
          'n',
          'U',
          function()
            require('diffview.config').actions.unstage_all()
          end,
          { desc = '[U]nstage all' },
        },
      },
    },
  })

  vim.keymap.set('n', '<leader>v', vim.cmd.DiffviewToggle, { desc = '[v]iew git diff' })
end)
