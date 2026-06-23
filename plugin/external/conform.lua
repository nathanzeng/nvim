-- Autoformat
vim.schedule(function()
  vim.pack.add({
    'https://github.com/stevearc/conform.nvim',
  })

  require('conform').setup({
    -- notify_on_error = false,
    format_on_save = function(bufnr)
      -- My custom command for disabling autosave
      if vim.g.disable_autoformat then
        return
      end

      -- Disable "format_on_save lsp_fallback" for languages that don't
      -- have a well standardized coding style. You can add additional
      -- languages here or re-enable it for the disabled ones.
      local disable_filetypes = { c = true, cpp = true }
      if disable_filetypes[vim.bo[bufnr].filetype] then
        return nil
      else
        return {
          timeout_ms = 5000,
          -- lsp_format = 'fallback',
        }
      end
    end,
    -- Formatters by file type
    -- Conform can also run multiple formatters sequentially
    -- You can use 'stop_after_first' to run the first available formatter from the list
    -- NOTE: Apparently prettierd is a faster version of prettier
    formatters_by_ft = {
      lua = { 'stylua' },
      javascript = { 'prettierd', 'prettier', stop_after_first = true },
      typescript = { 'prettierd', 'prettier', stop_after_first = true },
      typescriptreact = { 'prettierd', 'prettier', stop_after_first = true },
      javascriptreact = { 'prettierd', 'prettier', stop_after_first = true },
      vue = { 'prettierd', 'prettier', stop_after_first = true },
      php = { 'prettierd', 'prettier', stop_after_first = true },
      graphql = { 'prettierd', 'prettier', stop_after_first = true },
      html = { 'prettierd', 'prettier', stop_after_first = true },
      json = { 'prettierd', 'prettier', stop_after_first = true },
    },
  })

  -- Sometimes I want to be able to save without formatting
  vim.api.nvim_create_user_command('ConformDisableAuto', function()
    vim.g.disable_autoformat = true
  end, {
    desc = 'Disable autoformat-on-save',
  })

  vim.api.nvim_create_user_command('ConformEnableAuto', function()
    vim.g.disable_autoformat = false
  end, {
    desc = 'Re-enable autoformat-on-save',
  })
end)
