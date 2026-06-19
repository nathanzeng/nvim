vim.loader.enable() -- Fast loading magic, was used by lazy.nvim as well

-- Set leader before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local hooks = function(ev)
  -- Use available |event-data|
  local name, kind = ev.data.spec.name, ev.data.kind
  -- Run build script after plugin's code has changed
  if name == 'telescope-fzf-native.nvim' and (kind == 'install' or kind == 'update') then
    -- Append `:wait()` if you need synchronous execution
    vim.system({ 'make' }, { cwd = ev.data.path })
  elseif name == 'nvim-treesitter' and kind == 'update' then
    if not ev.data.active then
      vim.cmd.packadd('nvim-treesitter')
    end
    vim.cmd('TSUpdate')
  end
end

-- If hooks need to run on install, run this before `vim.pack.add()`
-- To act on install from lockfile, run before very first `vim.pack.add()`
vim.api.nvim_create_autocmd('PackChanged', { callback = hooks })

-- Sync with the lockfile
vim.api.nvim_create_user_command('PackSync', function()
  vim.pack.update(nil, { target = 'lockfile' })
end, { desc = 'Sync plugins with the lockfile' })

require('options')

require('keymaps')

-- Enable ui2
require('vim._core.ui2').enable()
