vim.api.nvim_create_user_command('FoldEnable', function()
  vim.o.foldlevel = 99
  vim.o.foldlevelstart = 99
  vim.o.foldmethod = 'indent'
end, { desc = 'Enable indent based folding' })

vim.api.nvim_create_user_command('FoldDisable', function()
  vim.o.foldmethod = 'manual'
end, { desc = 'Enable indent based folding' })
