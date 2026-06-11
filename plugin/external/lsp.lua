-- Main LSP Configuration
vim.pack.add({
  'https://github.com/mason-org/mason.nvim',
  'https://github.com/neovim/nvim-lspconfig',
})
require('mason').setup()

--  This function gets run when an LSP attaches to a particular buffer.
--    That is to say, every time a new file is opened that is associated with
--    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
--    function will be executed to configure the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
  callback = function(event)
    -- In this case, we create a function that lets us more easily define mappings specific
    -- for LSP related items. It sets the mode, buffer and description for us each time.
    local map = function(keys, func, desc, mode)
      mode = mode or 'n'
      vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
    end

    -- Rename the variable under your cursor.
    --  Most Language Servers support renaming across files, etc.
    map('<leader>ln', vim.lsp.buf.rename, 're[n]ame')

    -- Execute a code action, usually your cursor needs to be on top of an error
    -- or a suggestion from your LSP for this to activate.
    map('<leader>la', vim.lsp.buf.code_action, 'code [a]ction', { 'n', 'x' })

    -- Find references for the word under your cursor.
    map('<leader>lr', require('telescope.builtin').lsp_references, '[r]eferences')

    -- Jump to the implementation of the word under your cursor.
    --  Useful when your language has ways of declaring types without an actual implementation.
    map('<leader>li', require('telescope.builtin').lsp_implementations, '[i]mplementation')

    -- Jump to the definition of the word under your cursor.
    --  This is where a variable was first declared, or where a function is defined, etc.
    --  To jump back, press <C-t>.
    map('<leader>ld', require('telescope.builtin').lsp_definitions, '[d]efinition')

    -- WARN: This is not Goto Definition, this is Goto Declaration.
    --  For example, in C this would take you to the header.
    map('<leader>lD', vim.lsp.buf.declaration, '[D]eclaration')

    -- Fuzzy find all the symbols in your current document.
    --  Symbols are things like variables, functions, types, etc.
    map('<leader>lO', require('telescope.builtin').lsp_document_symbols, 'Open Document Symbols')

    -- Fuzzy find all the symbols in your current workspace.
    --  Similar to document symbols, except searches over your entire project.
    map('<leader>lW', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Open Workspace Symbols')

    -- Jump to the type of the word under your cursor.
    --  Useful when you're not sure what type a variable is and you want to see
    --  the definition of its *type*, not where it was *defined*.
    map('<leader>lt', require('telescope.builtin').lsp_type_definitions, '[t]ype definition')

    -- The following two autocommands are used to highlight references of the
    -- word under your cursor when your cursor rests there for a little while.
    --    See `:help CursorHold` for information about when this is executed
    --
    -- When you move your cursor, the highlights will be cleared (the second autocommand).
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client:supports_method('textDocument/documentHighlight', event.buf) then
      local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.document_highlight,
      })

      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.clear_references,
      })

      vim.api.nvim_create_autocmd('LspDetach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
        callback = function(event2)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds({ group = 'kickstart-lsp-highlight', buffer = event2.buf })
        end,
      })
    end

    -- Toggle inlay hints if the language server you are using supports them
    if client and client:supports_method('textDocument/inlayHint', event.buf) then
      map('<leader>lh', function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
      end, 'Toggle inlay [h]ints')
    end
  end,
})

-- Diagnostic Config
-- See :help vim.diagnostic.Opts
vim.diagnostic.config({
  severity_sort = true,
  float = { border = 'rounded', source = 'if_many' },
  underline = { severity = vim.diagnostic.severity.ERROR },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '󰅚 ',
      [vim.diagnostic.severity.WARN] = '󰀪 ',
      [vim.diagnostic.severity.INFO] = '󰋽 ',
      [vim.diagnostic.severity.HINT] = '󰌶 ',
    },
  },
  virtual_text = {
    source = 'if_many',
    spacing = 2,
    format = function(diagnostic)
      local diagnostic_message = {
        [vim.diagnostic.severity.ERROR] = diagnostic.message,
        [vim.diagnostic.severity.WARN] = diagnostic.message,
        [vim.diagnostic.severity.INFO] = diagnostic.message,
        [vim.diagnostic.severity.HINT] = diagnostic.message,
      }
      return diagnostic_message[diagnostic.severity]
    end,
  },
  jump = {
    wrap = false,
    on_jump = function()
      -- Open as float while jumping
      vim.diagnostic.open_float({ focus = false })
    end,
  },
})

--  Add any additional override configuration in the following tables. Available keys are:
--  - cmd (table): Override the default command used to start the server
--  - filetypes (table): Override the default list of associated filetypes for the server
--  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
--  - settings (table): Override the default settings passed when initializing the server.
--        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/

local vue_language_server_path = vim.fn.expand('$MASON/packages')
  .. '/vue-language-server'
  .. '/node_modules/@vue/language-server'

local servers = {
  -- NOTE: Some languages (like typescript) have entire language plugins that can be useful:
  --    https://github.com/pmizio/typescript-tools.nvim
  --    vts_ls and the above thing are both options
  --    I tried vts_ls and it sometimes has duplicate definitons in imports where ts_ls jumps to definition correctly
  --    Keep an eye on go typescript too
  --
  -- But for many setups, the LSP (`ts_ls`) will work just fine
  ts_ls = {
    init_options = {
      plugins = {
        {
          name = '@vue/typescript-plugin',
          location = vue_language_server_path,
          languages = { 'vue' },
        },
      },
    },
    filetypes = {
      'typescript',
      'javascript',
      'javascriptreact',
      'typescriptreact',
      'vue',
    },
  },
  -- tsgo = {},

  -- https://github.com/vuejs/language-tools/wiki/Neovim
  -- vtsls = {
  --   settings = {
  --     vtsls = {
  --       tsserver = {
  --         globalPlugins = {
  --           {
  --             name = '@vue/typescript-plugin',
  --             location = vue_language_server_path,
  --             languages = { 'vue' },
  --             configNamespace = 'typescript',
  --           },
  --         },
  --       },
  --     },
  --   },
  --   filetypes = {
  --     'typescript',
  --     'javascript',
  --     'javascriptreact',
  --     'typescriptreact',
  --     'vue',
  --   },
  -- },
  vue_ls = {},

  -- If you decide the no type info available thing is too noisy, can turn off here
  -- https://www.reddit.com/r/neovim/comments/1tyzqgz/php_intelephense_neovim_lua_config_issue/
  intelephense = {
    -- init_options = {
    --   clearCache = true,
    -- },
    root_markers = { 'composer.json' }, -- Makes sure that global doesn't reach to parent
    settings = {
      intelephense = {
        files = {
          -- Maximum maxSize
          maxSize = 5000000,
          exclude = {
            '**/.git/**',
            '**/.svn/**',
            '**/.hg/**',
            '**/CVS/**',
            '**/.DS_Store/**',
            '**/node_modules/**',
            '**/bower_components/**',
            '**/vendor/**/{Tests,tests}/**',
            '**/.history/**',
            '**/vendor/**/vendor/**',
            -- Below are my editions, above are just defaults
            'global/**',
            '**/vendor/composer/**',
            '**/vendor/_laravel_idea/**',
          },
        },
        -- NOTE: uncoment below and use `:lua vim.lsp.codelens.enable()`
        -- codeLens = {
        --   references = { enable = true },
        --   implementations = { enable = true },
        --   usages = { enable = true },
        --   overrides = { enable = true },
        --   parent = { enable = true },
        -- },
      },
    },
  },
  -- TODO: uncommenting the following sometimes gets it to work in vue files in redpoint
  -- but it is extremely slow and crashes the other lsps too
  -- there is a thought to try making a graphql.config.yml in the mobile directory
  graphql = {
    -- cmd = { 'graphql-lsp', 'server', '--method', 'stream' },
    --
    -- -- Attach to Vue + JS/TS
    -- filetypes = {
    --   'graphql',
    --   'javascript',
    --   'javascriptreact',
    --   'typescript',
    --   'typescriptreact',
    --   'vue',
    -- },
    --
    -- root_markers = { 'graphql.config.yml', '.git' },
    --
    -- settings = {
    --   graphql = {
    --     -- This is what PhpStorm does automatically
    --     validate = true,
    --     schemaValidation = 'error',
    --
    --     -- Enable embedded GraphQL
    --     tagName = 'graphql',
    --   },
    -- },
  },
  eslint = {},

  stylua = {},
  -- NOTE: copied straight from 'lsp-config-all' in neovim help
  lua_ls = {
    on_init = function(client)
      if client.workspace_folders then
        local path = client.workspace_folders[1].name
        if
          path ~= vim.fn.stdpath('config')
          and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc'))
        then
          return
        end
      end

      client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
        runtime = {
          -- Tell the language server which version of Lua you're using (most
          -- likely LuaJIT in the case of Neovim)
          version = 'LuaJIT',
          -- Tell the language server how to find Lua modules same way as Neovim
          -- (see `:h lua-module-load`)
          path = {
            'lua/?.lua',
            'lua/?/init.lua',
          },
        },
        -- Make the server aware of Neovim runtime files
        workspace = {
          checkThirdParty = false,
          library = {
            vim.env.VIMRUNTIME,
            -- Depending on the usage, you might want to add additional paths
            -- here.
            -- '${3rd}/love2d/library',
          },
          -- Or pull in all of 'runtimepath'.
          -- NOTE: this is a lot slower and will cause issues when working on
          -- your own configuration.
          -- See https://github.com/neovim/nvim-lspconfig/issues/3189
          -- library = vim.api.nvim_get_runtime_file('', true),
        },
      })
    end,
    settings = {
      Lua = {},
    },
  },

  -- i think this maps to json-lsp in mason? the gh links don't match tho
  jsonls = {},
}

-- Now setup those configurations
for name, server in pairs(servers) do
  vim.lsp.config(name, server)
  vim.lsp.enable(name)
end

-- I need this line so that vue custom components get a different color from <div>
-- https://github.com/vuejs/language-tools/wiki/Neovim
vim.api.nvim_set_hl(0, '@lsp.type.component', { link = '@type' })
