vim.pack.add({ 'https://github.com/lewis6991/gitsigns.nvim' })

require('gitsigns').setup({
  signs = {
    add = { text = '+' },
    change = { text = '~' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' },
  },
  on_attach = function(bufnr)
    local gitsigns = require('gitsigns')

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map('n', ']c', function()
      if vim.wo.diff then
        -- bang makes it so that when you are in a diff it executes native ]c
        -- because ]c is a mapping used by this plugin
        vim.cmd.normal({ ']c', bang = true })
      else
        gitsigns.nav_hunk('next')
      end
    end, { desc = 'Jump to next git [c]hange' })

    map('n', '[c', function()
      if vim.wo.diff then
        vim.cmd.normal({ '[c', bang = true })
      else
        gitsigns.nav_hunk('prev')
      end
    end, { desc = 'Jump to previous git [c]hange' })

    -- Visual mode
    map('x', '<leader>gs', function()
      gitsigns.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
    end, { desc = '[s]tage hunk' })
    map('x', '<leader>gr', function()
      gitsigns.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
    end, { desc = '[r]eset hunk' })

    -- normal mode
    map('n', '<leader>gs', gitsigns.stage_hunk, { desc = '[s]tage hunk' })
    map('n', '<leader>gr', gitsigns.reset_hunk, { desc = '[r]eset hunk' })
    map('n', '<leader>gS', gitsigns.stage_buffer, { desc = '[S]tage buffer' })
    map('n', '<leader>gU', gitsigns.reset_buffer_index, { desc = '[U]nstage buffer' })
    map('n', '<leader>gR', gitsigns.reset_buffer, { desc = '[R]eset buffer hunks' })
    map('n', '<leader>gp', gitsigns.preview_hunk, { desc = '[p]review hunk' })
    map('n', '<leader>gl', function()
      -- blame_line with the full commit message and hunk changes
      gitsigns.blame_line({ full = true })
    end, { desc = '[l]ine git blame' })
    -- TODO: when you want to go though the pain of a new mapping, consider
    -- changing this to gd/gD and difview to just <leader>v
    map('n', '<leader>gc', gitsigns.diffthis, { desc = '[c]hanges against index' })
    map('n', '<leader>gC', function()
      gitsigns.diffthis('@')
    end, { desc = '[C]hanges against last commit' })

    -- I found this line blame to be useless, there are more config options though
    -- map('n', '<leader>gl', gitsigns.toggle_current_line_blame, { desc = 'Toggle git blame [l]ine' })
    -- TODO: I want it to toggle off blame too, have to figure out how to delete the buffer
    map('n', '<leader>gb', gitsigns.blame, { desc = '[b]lame file' })

    -- this was like a worse version of the normal preview
    -- map('n', '<leader>tD', gitsigns.preview_hunk_inline, { desc = '[T]oggle git show [D]eleted' })
  end,
})
