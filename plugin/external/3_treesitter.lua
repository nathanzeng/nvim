vim.pack.add({ 'https://github.com/nvim-treesitter/nvim-treesitter' })

-- Using a fork that has support for \ and directive stuff
vim.api.nvim_create_autocmd('User', {
  pattern = 'TSUpdate',
  callback = function()
    require('nvim-treesitter.parsers').graphql = {
      install_info = {
        url = 'https://github.com/11bit/tree-sitter-graphql',
        revision = '951bde9fb3145b5f676204231e35f8b21d21f7b3',
      },
    }
  end,
})

local filetypes = {
  'bash',
  'c',
  'diff',
  'html',
  'lua',
  'luadoc',
  'markdown',
  'markdown_inline',
  'query',
  'vim',
  'vimdoc',
  'vue',
  'typescript',
  'javascript',
  'tsx',
  'jsx',
  'css',
  'php',
  'phpdoc',
  'json',
  'gitcommit',
  'gitignore',
  'git_rebase',
  'yaml',
  'graphql',
  'xml',
}
-- Force install on following line was neccesary when migrating from lazy
require('nvim-treesitter').install(filetypes)

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('treesitter', { clear = true }),
  pattern = filetypes,
  callback = function(args)
    vim.treesitter.start()
    -- Treesitter based indentation for filetypes outside blacklist
    if args.match ~= 'php' then
      vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end,
})

-- Incremental selection
vim.keymap.set({ 'n', 'x', 'o' }, '<up>', function()
  if vim.treesitter.get_parser(nil, nil, { error = false }) then
    vim.treesitter.select('parent', vim.v.count1)
  else
    vim.lsp.buf.selection_range(vim.v.count1)
  end
end, { desc = 'Select parent (outer) node' })

vim.keymap.set({ 'n', 'x', 'o' }, '<down>', function()
  if vim.treesitter.get_parser(nil, nil, { error = false }) then
    vim.treesitter.select('child', vim.v.count1)
  else
    vim.lsp.buf.selection_range(-vim.v.count1)
  end
end, { desc = 'Select child (inner) node' })
