vim.pack.add({
  {
    src = 'https://github.com/saghen/blink.cmp',
    version = 'v1.10.2',
  },
})

require('blink.cmp').setup({
  keymap = {
    -- 'default' (recommended) for mappings similar to built-in completions
    --   <c-y> to accept ([y]es) the completion.
    --    This will auto-import if your LSP supports it.
    --    This will expand snippets if the LSP sent a snippet.
    -- 'super-tab' for tab to accept
    -- 'enter' for enter to accept
    -- 'none' for no mappings
    --
    -- For an understanding of why the 'default' preset is recommended,
    -- you will need to read `:help ins-completion`
    --
    -- No, but seriously. Please read `:help ins-completion`, it is really good!
    --
    -- All presets have the following mappings:
    -- <tab>/<s-tab>: move to right/left of your snippet expansion
    -- <c-space>: Open menu or open docs if already open
    -- <c-n>/<c-p> or <up>/<down>: Select next/previous item
    -- <c-e>: Hide menu
    -- <c-k>: Toggle signature help
    --
    -- See :h blink-cmp-config-keymap for defining your own keymap
    preset = 'default',

    -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
    --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps

    -- NOTE: remove when done training
    ['<Up>'] = false,
    ['<Down>'] = false,
  },

  completion = {
    list = {
      selection = {
        -- When `true`, inserts the completion item automatically when selecting it
        auto_insert = false,
        -- auto_insert = function(ctx) return vim.bo.filetype ~= 'markdown' end
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

  cmdline = {
    -- Do not like neovim default of 'show_and_insert_or_accept_single'
    keymap = { ['<Tab>'] = { 'show', 'select_next' } },
    completion = {
      list = {
        selection = {
          -- When `true`, inserts the completion item automatically when selecting it
          auto_insert = false,
        },
      },
    },
  },
})

-- Indent lines and text object
vim.pack.add({ 'https://github.com/saghen/blink.indent' })
require('blink.indent').setup({
  -- No need to see all the indent lines
  static = { enabled = false },
  -- Center the pipe, color all the indent lines the same
  scope = { indent_at_cursor = true, char = '┃', highlights = { 'BlinkIndent' } },
})
