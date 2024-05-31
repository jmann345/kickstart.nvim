local function my_on_attach(bufnr)
  local api = require 'nvim-tree.api'

  local function edit_or_open()
    local node = api.tree.get_node_under_cursor()
    if node.nodes ~= nil then
      -- expand or collapse folder
      api.node.open.edit()
    else
      -- open file
      api.node.open.edit()
      -- Close the tree if file was opened
      api.tree.close()
    end
  end

  local function vsplit_preview()
    local node = api.tree.get_node_under_cursor()

    if node.nodes ~= nil then
      -- expand or collapse folder
      api.node.open.edit()
    else
      -- open file as vsplit
      api.node.open.vertical()
    end

    -- Finally refocus on tree if it was lost
    api.tree.focus()
  end

  local function opts(desc)
    return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  -- default mappings
  api.config.mappings.default_on_attach(bufnr)

  -- custom mappings
  vim.keymap.set('n', 'l', edit_or_open, opts 'Edit Or Open')
  vim.keymap.set('n', 'L', vsplit_preview, opts 'Vsplit Preview')
  vim.keymap.set('n', 'h', api.tree.close, opts 'Close')
  vim.keymap.set('n', 'H', api.tree.collapse_all, opts 'Collapse All')
  vim.keymap.set('n', '?', api.tree.toggle_help, opts 'Help')
end

return {
  {
    'navarasu/onedark.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      require('onedark').setup {
        style = 'darker',
      }
      vim.cmd.colorscheme 'onedark'
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-context',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    lazy = false,
  },
  {
    'ramilito/winbar.nvim',
    event = 'VimEnter', -- Alternatively, BufReadPre if we don't care about the empty file when starting with 'nvim'
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    lazy = false,
    config = function()
      require('winbar').setup {
        -- your configuration comes here, for example:
        icons = true,
        diagnostics = true,
        buf_modified = true,
      }
    end,
  },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
      options = {
        theme = 'onedark',
        component_separators = { left = '|', right = '|' },
        section_separators = { left = '', right = '' },
      },
      -- sections = {
      --   lualine_b = {
      --     { 'branch' },
      --     {
      --       'diff',
      --       colored = true,
      --       diff_color = {
      --         added = { fg = '#89ca78' },
      --         modified = { fg = '#61afef' },
      --         removed = { fg = '#ef596f' },
      --       },
      --       symbols = { added = '+', modified = '~', removed = '-' },
      --     },
      --     { 'diagnostics' },
      --   },
      -- },
    },
  },
  {
    'nvim-tree/nvim-tree.lua',
    version = '*',
    lazy = false,
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      require('nvim-tree').setup {
        on_attach = my_on_attach,
      }
      -- vim.cmd [[
      --     :hi NvimTreeFolderIcon        guifg=#61afef ctermfg=Blue
      --     :hi NvimTreeFolderName        guifg=#61afef
      --     :hi NvimTreeEmptyFolderName   guifg=#61afef
      --     :hi NvimTreeOpenedFolderName  guifg=#61afef
      --     :hi NvimTreeSymlinkFolderName guifg=#61afef
      -- ]]
    end,
  },
}
