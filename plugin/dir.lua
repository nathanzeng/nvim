local api = vim.api
local TIMEOUT = 3000
local augroup = api.nvim_create_augroup('dir_nathan')
local default_numberwidth = vim.o.numberwidth
local default_statuscolumn = vim.o.statuscolumn

local function hl_line_like_yank()
  local ns = api.nvim_create_namespace('dir_nathan.yank_line')
  local row = api.nvim_win_get_cursor(0)[1] - 1

  vim.hl.range(0, ns, 'IncSearch', { row, 0 }, { row, -1 }, {
    timeout = 150,
  })
end

vim.keymap.set('n', '_', '1-', { remap = true, desc = 'Open CWD' })

-- Window-local state that depends on currently displayed buffer
api.nvim_create_autocmd('BufEnter', {
  group = augroup,
  callback = function(args)
    if vim.bo[args.buf].filetype == 'directory' then
      vim.wo.numberwidth = 5
      vim.wo.statuscolumn = "%l %{%v:lua.require'dir_icons'.directory()%}"
    else
      vim.wo.numberwidth = default_numberwidth
      vim.wo.statuscolumn = default_statuscolumn
    end
  end,
})

api.nvim_create_autocmd('FileType', {
  group = augroup,
  pattern = 'directory',
  callback = function(args)
    -- Delete dir buffers after we leave them
    vim.bo.bufhidden = 'wipe'

    -- AI gave this to me to make entries beginning with "." have comment hl
    vim.api.nvim_buf_call(args.buf, function()
      vim.cmd([[syntax match Comment /^\..*$/]])
    end)

    local dir_name = api.nvim_buf_get_name(0)

    -- Close
    vim.keymap.set('n', '<C-c>', function()
      vim.cmd.edit('#')
    end, { desc = 'Close dir buffer', buf = 0 })

    -- Don't think I need visual block mode for dir buffers
    vim.keymap.set(
      'n',
      '<C-v>',
      '<Plug>(nvim-dir-vsplit)',
      { desc = 'Open dir entry in vsplit', buf = 0 }
    )
    -- Use a to open in horizontal split
    vim.keymap.set(
      'n',
      'a',
      '<Plug>(nvim-dir-split)',
      { desc = 'Open dir entry in split', buf = 0 }
    )

    -- Add entry
    vim.keymap.set('n', 'o', function()
      vim.ui.input({ prompt = 'Add: ' }, function(input)
        if input == nil then
          return
        end
        local abs_filename = dir_name .. input

        -- Either touch or mkdir based on presence of /
        if vim.endswith(abs_filename, '/') then
          local obj = vim.system({ 'mkdir', abs_filename }, { text = true }):wait(TIMEOUT)
          if obj.code ~= 0 then
            error('System error: ' .. (obj.stderr or 'nil'))
          end
        else
          local obj = vim.system({ 'touch', abs_filename }, { text = true }):wait(TIMEOUT)
          if obj.code ~= 0 then
            error('System error: ' .. (obj.stderr or 'nil'))
          end
        end

        vim.cmd.normal({ args = { 'R' } })
        -- Brings the cursor to the newly created entry
        vim.fn.search('\\V' .. input)
      end)
    end, { desc = 'Create dir entry', buf = 0 })

    -- Delete entry
    vim.keymap.set('n', 'dd', function()
      local filename = dir_name .. api.nvim_get_current_line()

      local confirm_msg = 'Delete: ' .. filename
      local confirm = vim.fn.confirm(confirm_msg, '&yes\n&no\n&cancel')

      if confirm == 1 then
        local obj = vim.system({ 'rm', '-r', filename }, { text = true }):wait(TIMEOUT)
        if obj.code ~= 0 then
          error('System error: ' .. (obj.stderr or 'nil'))
        end

        -- TODO: files deleted from deleting a directory will still error
        -- Delete corresponding buf to prevent orphaned buf and error message
        for _, bufnr in ipairs(api.nvim_list_bufs()) do
          local name = api.nvim_buf_get_name(bufnr)
          if name == filename then
            api.nvim_buf_delete(bufnr)
          end
        end
      end

      vim.cmd.normal({ args = { 'R' } })
    end, { desc = 'Delete dir entry', buf = 0 })

    -- Yank entry
    vim.keymap.set('n', 'yy', function()
      local filename = dir_name .. api.nvim_get_current_line()

      hl_line_like_yank()
      vim.fn.setreg('+', filename)
      vim.notify('Full path yanked to clipboard')
    end, { desc = 'Yank dir entry full path to clipboard', buf = 0 })

    -- Move entry
    vim.keymap.set('n', 'm', function()
      local filename = dir_name .. api.nvim_get_current_line()

      vim.ui.input({ prompt = 'Move to: ' }, function(input)
        if input == nil then
          return
        end

        local obj = vim.system({ 'mv', filename, input }, { text = true }):wait(TIMEOUT)
        if obj.code ~= 0 then
          error('System error: ' .. (obj.stderr or 'nil'))
        end

        vim.cmd.normal({ args = { 'R' } })
      end)
    end, { desc = 'Move dir entry under cursor', buf = 0 })

    -- Rename entry
    vim.keymap.set('n', 'r', function()
      local filename = dir_name .. api.nvim_get_current_line()

      vim.ui.input({ prompt = 'Rename: ', default = api.nvim_get_current_line() }, function(input)
        if input == nil then
          return
        end

        local obj = vim.system({ 'mv', filename, dir_name .. input }, { text = true }):wait(TIMEOUT)
        if obj.code ~= 0 then
          error('System error: ' .. (obj.stderr or 'nil'))
        end

        vim.cmd.normal({ args = { 'R' } })
        -- Brings the cursor to the newly renamed entry
        vim.fn.search('\\V' .. input)
      end)
    end, { desc = 'Rename entry under cursor', buf = 0 })

    -- Copy entry
    vim.keymap.set('n', 'c', function()
      local filename = dir_name .. api.nvim_get_current_line()

      vim.ui.input({ prompt = 'Copy to: ' }, function(input)
        if input == nil then
          return
        end

        local obj = vim.system({ 'cp', '-R', filename, input }, { text = true }):wait(TIMEOUT)
        if obj.code ~= 0 then
          error('System error: ' .. (obj.stderr or 'nil'))
        end

        vim.cmd.normal({ args = { 'R' } })
      end)
    end, { desc = 'Copy dir entry under cursor', buf = 0 })

    -- Copy or move from destination ("p")
    vim.keymap.set('n', 'p', function()
      local clipboard = vim.fn.getreg('+')
      -- Trailing slash changes cp behavior on macOs (copies dir contents instead of dir)
      clipboard = clipboard:gsub('/$', '')
      local confirm = vim.fn.confirm(clipboard, '&move\n&copy')

      if confirm == 1 then
        local obj = vim.system({ 'mv', clipboard, dir_name }, { text = true }):wait(TIMEOUT)
        if obj.code ~= 0 then
          error('System error: ' .. (obj.stderr or 'nil'))
        end

        -- Bring cursor to entry
        vim.cmd.normal({ args = { 'R' } })
        local tail = clipboard:match('([^/]+)$') or clipboard
        vim.fn.search('\\V' .. tail)
      elseif confirm == 2 then
        local obj = vim.system({ 'cp', '-R', clipboard, dir_name }, { text = true }):wait(TIMEOUT)
        if obj.code ~= 0 then
          error('System error: ' .. (obj.stderr or 'nil'))
        end

        -- Bring cursor to entry
        vim.cmd.normal({ args = { 'R' } })
        local tail = clipboard:match('([^/]+)$') or clipboard
        vim.fn.search('\\V' .. tail)
      end
    end, { desc = 'Copy or move into current dir', buf = 0 })

    -- Open entry in external program
    vim.keymap.set('n', 'gx', function()
      local filename = dir_name .. api.nvim_get_current_line()
      local cmd, err = vim.ui.open(filename)

      if cmd == nil then
        error('UI open cmd not found')
      end
      cmd:wait()

      if err ~= nil then
        error(err)
      end
    end, { desc = 'Open entry in external program', buf = 0 })

    -- Telescope stuff
    vim.keymap.set('n', '<leader>ff', function()
      require('telescope.builtin').find_files({
        cwd = dir_name,
      })
    end, { desc = 'Telescope find files (scoped to dir)', buf = 0 })

    vim.keymap.set('n', '<leader>fg', function()
      require('telescope.builtin').live_grep({
        cwd = dir_name,
      })
    end, { desc = 'Telescope find grep (scoped to dir)', buf = 0 })
  end,
})

vim.api.nvim_create_autocmd('User', {
  group = augroup,
  pattern = 'DirReadPost',
  callback = function()
    -- TODO: apparently this is what causes us to open to not the first entry
    -- try vim.fn.winsaveview() and winrestview()
    -- Hide any entry named `.DS_Store`
    vim.cmd([[silent keeppatterns g/^\.DS_Store/d _]])
  end,
})
