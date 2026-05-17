vim.pack.add({ 'https://github.com/nvim-mini/mini.nvim' })

-- Based off looking at Mini Max, this stuff doesn't need to load on first draw
vim.schedule(function()
  -- Better Around/Inside textobjects
  --
  -- Examples:
  --  - va)  - [V]isually select [A]round [)]paren
  --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
  --  - ci'  - [C]hange [I]nside [']quote
  require('mini.ai').setup({ n_lines = 500 })

  -- Add/delete/replace surroundings (brackets, quotes, etc.)
  --
  -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
  -- - sd'   - [S]urround [D]elete [']quotes
  -- - sr)'  - [S]urround [R]eplace [)] [']
  require('mini.surround').setup()

  require('mini.bufremove').setup()
  -- Don't delete the window when deleting the buffer (splits)
  vim.keymap.set('n', '<leader>bd', function()
    MiniBufremove.delete()
  end, { desc = '[b]uffer [d]elete' })

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
require('mini.icons').setup()
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
  -- For some reason, the lua lsp on neovim repo kept reloading
  -- lsp_progress = {
  --   enable = false,
  -- },
})
vim.notify = MiniNotify.make_notify()
