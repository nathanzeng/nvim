vim.pack.add({ 'https://github.com/edeneast/nightfox.nvim' })

local Color = require('nightfox.lib.color')

local background = '#2e3440'
-- NOTE: these originally used the dim versions of the colors
-- I didn't have the energy to import the shades library
local diff_blue = Color.from_hex(background):blend(Color.from_hex('#81a1c1'), 0.35)
local diff_red = Color.from_hex(background):blend(Color.from_hex('#bf616a'), 0.30)
local diff_green = Color.from_hex(background):blend(Color.from_hex('#a3be8c'), 0.18)

local specs = {
  nordfox = {
    -- The below file shows the default values for syntax
    -- https://github.com/EdenEast/nightfox.nvim/blob/main/lua/nightfox/palette/nordfox.lua
    syntax = {
      -- Specs allow you to define a value using either a color or template. If the string does
      -- start with `#` the string will be used as the path of the palette table. Defining just
      -- a color uses the base version of that color.
      keyword = 'orange',
      number = 'magenta',
      const = 'magenta',
      builtin0 = 'orange',
    },
    diff = {
      -- add = diff_green:to_css(),
      -- delete = diff_red:to_css(),
      text = diff_blue:to_css(),
    },
    git = {
      changed = 'blue',
    },
  },
}

require('nightfox').setup({ specs = specs })
vim.cmd.colorscheme('nordfox')
