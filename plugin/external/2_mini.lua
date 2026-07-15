vim.pack.add({ 'https://github.com/nvim-mini/mini.nvim' })

-- Based off looking at Mini Max, this stuff doesn't need to load on first draw
vim.schedule(function()
  require('mini.ai').setup({ n_lines = 500 })
  -- These neovim defaults conflict with mini.ai
  vim.keymap.set({ 'x', 'o' }, 'ag', 'al', { desc = 'Buffer (ggG or something like this)' })
  vim.keymap.set({ 'x', 'o' }, 'ir', 'il', { desc = '[r]ow (line)' })

  require('mini.surround').setup()

  -- Don't delete the window when deleting the buffer (splits)
  require('mini.bufremove').setup()

  vim.keymap.set('n', '<leader>bd', function()
    MiniBufremove.delete()
  end, { desc = '[b]uffer [d]elete' })

  vim.keymap.set('n', '<leader>bw', function()
    MiniBufremove.wipeout()
  end, { desc = '[b]uffer [w]ipeout' })

  -- Highlight hex colors
  local hipatterns = require('mini.hipatterns')
  hipatterns.setup({
    highlighters = {
      fixme = { pattern = ' FIXME:', group = 'MiniHipatternsFixme' },
      fixme_line = { pattern = ' FIXME:().*()', group = 'DiagnosticError' },
      hack = { pattern = ' HACK:', group = 'MiniHipatternsFixme' },
      hack_line = { pattern = ' HACK:().*()', group = 'DiagnosticError' },
      todo = { pattern = ' TODO:', group = 'MiniHipatternsHack' },
      todo_line = { pattern = ' TODO:().*()', group = 'DiagnosticWarn' },
      note = { pattern = ' NOTE:', group = 'MiniHipatternsTodo' },
      note_line = { pattern = ' NOTE:().*()', group = 'DiagnosticHint' },
      hex_color = hipatterns.gen_highlighter.hex_color(),
    },
  })

  local miniclue = require('mini.clue')
  miniclue.setup({
    window = {
      config = { width = 50 },
    },
    triggers = {
      -- Leader triggers
      { mode = { 'n', 'x' }, keys = '<Leader>' },

      -- `[` and `]` keys
      { mode = 'n', keys = '[' },
      { mode = 'n', keys = ']' },

      -- Built-in completion
      { mode = 'i', keys = '<C-x>' },

      -- `g` key
      { mode = { 'n', 'x' }, keys = 'g' },

      -- Marks
      { mode = { 'n', 'x' }, keys = "'" },
      { mode = { 'n', 'x' }, keys = '`' },

      -- Registers
      { mode = { 'n', 'x' }, keys = '"' },
      { mode = { 'i', 'c' }, keys = '<C-r>' },

      -- Window commands
      { mode = 'n', keys = '<C-w>' },

      -- `z` key
      { mode = { 'n', 'x' }, keys = 'z' },
    },

    clues = {
      { mode = 'n', keys = '<Leader>l', desc = 'LSP' },
      { mode = 'n', keys = '<Leader>f', desc = '[f]ind' },
      { mode = 'n', keys = '<Leader>r', desc = '[r]un debug' },
      miniclue.gen_clues.square_brackets(),
      miniclue.gen_clues.builtin_completion(),
      miniclue.gen_clues.g(),
      miniclue.gen_clues.marks(),
      miniclue.gen_clues.registers(),
      miniclue.gen_clues.windows(),
      miniclue.gen_clues.z(),
    },
  })
end)

-- Icons and mock the nvim-tree one
require('mini.icons').setup({
  filetype = {
    php = { glyph = '󰟆' },
  },
})
MiniIcons.mock_nvim_web_devicons()

-- LSP and custom notifications
require('mini.notify').setup({
  -- Bottom right corner
  window = {
    winblend = 0,
    config = {
      anchor = 'SE',
      col = vim.o.columns,
      row = vim.o.lines - vim.o.cmdheight,
    },
  },
})
-- Nightfox defaults to having floating windows darker
vim.api.nvim_set_hl(0, 'MiniNotifyNormal', { link = 'Normal' })
vim.notify = MiniNotify.make_notify()

require('mini.move').setup({
  -- Module mappings. Use `''` (empty string) to disable one.
  mappings = {
    -- Move visual selection in Visual mode. Defaults are Alt (Meta) + hjkl.
    left = '<C-h>',
    right = '<C-l>',
    down = '<C-j>',
    up = '<C-k>',

    -- Move current line in Normal mode
    line_left = '',
    line_right = '',
    line_down = '',
    line_up = '',
  },
})
