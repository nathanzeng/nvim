vim.pack.add({
  {
    src = 'https://github.com/saghen/blink.cmp',
    version = 'v1.10.2',
  },
  'https://github.com/saghen/blink.indent',
})

require('blink.cmp').setup({
  keymap = {
    preset = 'default',
    -- I have ctrl-e mapped to jumping to the end of line (bash style)
    ['<C-e>'] = false,
    ['<C-h>'] = { 'hide', 'fallback' },
  },

  completion = {
    list = {
      selection = {
        -- When `true`, inserts the completion item automatically when selecting it
        auto_insert = false,
      },
    },
    menu = {
      border = 'none',
    },
  },

  sources = {
    default = { 'lsp', 'path', 'snippets' },
  },

  -- Shows a signature help window while you type arguments for a function
  signature = { enabled = true },
})

require('blink.indent').setup({
  -- No need to see all the indent lines
  static = { enabled = false },
  -- Center the pipe, color all the indent lines the same
  scope = { indent_at_cursor = true, char = '┃', highlights = { 'BlinkIndent' } },
})
