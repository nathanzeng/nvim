-- Default php indent is dependent upon the non-treesitter based syntax highlighting
-- Treesitter indentation is broken for php file edge cases
-- So I'm using smartindent here instead
vim.bo.indentexpr = ''
vim.bo.smartindent = true
