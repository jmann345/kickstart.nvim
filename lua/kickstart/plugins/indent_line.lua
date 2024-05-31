return {
  { -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help ibl`
    main = 'ibl',
    -- opts = {},
    config = function()
      -- local highlight = {
      --   'Grey',
      -- }
      -- local hooks = require 'ibl.hooks'
      -- -- create the highlight groups in the highlight setup hook, so they are reset
      -- -- every time the colorscheme changes
      -- hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
      --   vim.api.nvim_set_hl(0, 'Grey', { fg = '#5c6370' })
      -- end)
      require('ibl').setup {
        scope = {
          show_start = false,
          -- highlight = highlight,
        },
      }
    end,
  },
}
