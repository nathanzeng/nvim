vim.schedule(function()
  vim.pack.add({
    'https://github.com/nvim-lua/plenary.nvim',
    'https://github.com/nvim-telescope/telescope-ui-select.nvim',
    'https://github.com/nvim-telescope/telescope-fzf-native.nvim',
    'https://github.com/nvim-telescope/telescope.nvim',
  })

  -- Two important keymaps to use while in Telescope are:
  --  - Insert mode: <c-/>
  --  - Normal mode: ?
  --
  -- This opens a window that shows you all of the keymaps for the current
  -- Telescope picker. This is really useful to discover what Telescope can
  -- do as well as how to actually do it!
  require('telescope').setup({
    defaults = {
      mappings = {
        i = {
          ['<C-y>'] = 'select_default',
        },
      },

      -- I want to be able to see hidden files but not the ones in .git/ (the git refs and such)
      file_ignore_patterns = { '%.git/' },
      -- The following fields make the default layout have the prompt at the top
      layout_config = {
        prompt_position = 'top',
      },
      sorting_strategy = 'ascending',
      path_display = {
        'filename_first',
      },
    },
    pickers = {
      find_files = { hidden = true },
      help_tags = {
        mappings = {
          -- Open the help tags vertically
          i = { ['<CR>'] = 'select_vertical', ['<C-y>'] = 'select_vertical' },
        },
      },
      buffers = {
        sort_mru = true,
        ignore_current_buffer = true,
        disable_coordinates = true,
        mappings = {
          -- The default <M-d> conflicts with what I use for ghostty (on Linux)
          i = { ['<C-x>'] = 'delete_buffer' },
        },
      },
    },
    extensions = {
      ['ui-select'] = {
        require('telescope.themes').get_dropdown(),
        mappings = {
          i = {
            ['<C-y>'] = 'select_default',
          },
        },
      },
    },
  })

  -- Enable Telescope extensions if they are installed
  pcall(require('telescope').load_extension, 'fzf')
  pcall(require('telescope').load_extension, 'ui-select')

  -- See `:help telescope.builtin`
  local builtin = require('telescope.builtin')
  vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = '[f]ind [H]elp' })
  vim.keymap.set('n', '<leader>fk', builtin.keymaps, { desc = '[f]ind [K]eymaps' })
  vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = '[f]ind [F]iles' })
  vim.keymap.set('n', '<leader>fs', builtin.builtin, { desc = '[f]ind [S]elect Telescope' })
  vim.keymap.set('n', '<leader>fw', builtin.grep_string, { desc = '[f]ind current [W]ord' })
  vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = '[f]ind by [G]rep' })
  vim.keymap.set('n', '<leader>fd', builtin.diagnostics, { desc = '[f]ind [d]iagnostic errors' })
  vim.keymap.set('n', '<leader>fr', builtin.resume, { desc = '[f]ind [R]esume' })
  vim.keymap.set('n', '<leader>f.', builtin.oldfiles, { desc = '[f]ind Recent Files ("." for repeat)' })
  vim.keymap.set('n', '<leader><leader>', function()
    -- Use dropdown theme for current buffers, no preview necessary
    builtin.buffers(require('telescope.themes').get_dropdown({ previewer = false }))
  end, { desc = '[ ] Find existing buffers' })
  vim.keymap.set('n', '<leader>fd', builtin.git_status, { desc = '[f]ind git [d]iff' })

  -- Slightly advanced example of overriding default behavior and theme
  vim.keymap.set('n', '<leader>/', function()
    -- You can pass additional configuration to Telescope to change the theme, layout, etc.
    builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown({
      winblend = 10,
      previewer = false,
    }))
  end, { desc = '[/] Fuzzily search in current buffer' })

  -- It's also possible to pass additional configuration options.
  --  See `:help telescope.builtin.live_grep()` for information about particular keys
  vim.keymap.set('n', '<leader>f/', function()
    builtin.live_grep({
      grep_open_files = true,
      prompt_title = 'Live Grep in Open Files',
    })
  end, { desc = '[f]ind [/] in Open Files' })

  -- Shortcut for searching your Neovim configuration files
  vim.keymap.set('n', '<leader>fn', function()
    builtin.find_files({ cwd = vim.fn.stdpath('config') })
  end, { desc = '[f]ind [N]eovim files' })

  -- Shortcut for finding .env that shows gitignored and hidden files
  vim.keymap.set('n', '<leader>fe', function()
    builtin.find_files({ hidden = true, search_file = '.env', prompt_title = 'Find .env' })
  end, { desc = '[f]ind [e]nv' })
end)
