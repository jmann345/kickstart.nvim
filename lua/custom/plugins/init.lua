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
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
      options = {
        theme = 'onedark_vivid',
        component_separators = { left = '|', right = '|' },
        section_separators = { left = '', right = '' },
      },
      sections = {
        lualine_b = {
          { 'branch' },
          {
            'diff',
            colored = true,
            diff_color = {
              added = { fg = '#89ca78' },
              modified = { fg = '#61afef' },
              removed = { fg = '#ef596f' },
            },
            symbols = { added = '+', modified = '~', removed = '-' },
          },
          { 'diagnostics' },
        },
      },
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
      vim.cmd [[
          :hi NvimTreeFolderIcon        guifg=#61afef ctermfg=Blue
          :hi NvimTreeFolderName        guifg=#61afef
          :hi NvimTreeEmptyFolderName   guifg=#61afef
          :hi NvimTreeOpenedFolderName  guifg=#61afef
          :hi NvimTreeSymlinkFolderName guifg=#61afef
      ]]
    end,
  },
  {
    'willothy/nvim-cokeline',
    lazy = false,
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons',
      'stevearc/resession.nvim', -- Optional, for persistent history
    },
    -- config = true,
    config = function()
      require('cokeline').setup {
        default_hl = {
          bg = function(buffer)
            if buffer.is_focused then
              return '#1f2329'
            else
              local hlgroups = require 'cokeline.hlgroups'
              return hlgroups.get_hl_attr('ColorColumn', 'bg')
            end
          end,
        },
        sidebar = {
          filetype = 'NvimTree',
          components = {
            {
              text = '  NvimTree',
              hl = { fg = '#7f8490', bg = '#31353f' },
            },
          },
        },
      }
    end,
  },
  {
    'mrcjkb/haskell-tools.nvim',
    version = '^3', -- Recommended
    ft = { 'haskell', 'lhaskell', 'cabal', 'cabalproject' },
    config = function()
      -- Assuming 'haskell-tools' is already installed and available
      local ht = require 'haskell-tools'

      -- Function to setup keymaps for Haskell
      local function set_haskell_keymaps()
        local bufnr = vim.api.nvim_get_current_buf()
        local opts = { noremap = true, silent = true, buffer = bufnr }

        -- Define your keymaps here
        vim.keymap.set('n', '<space>cl', vim.lsp.codelens.run, opts)
        vim.keymap.set('n', '<space>gh', ht.hoogle.hoogle_signature, opts)
        vim.keymap.set('n', '<space>ea', ht.lsp.buf_eval_all, opts)
        vim.keymap.set('n', '<leader>hr', ht.repl.toggle, opts)
        vim.keymap.set('n', '<leader>hf', function()
          ht.repl.toggle(vim.api.nvim_buf_get_name(0))
        end, opts)
        vim.keymap.set('n', '<leader>rq', ht.repl.quit, opts)
      end

      -- Apply the keymaps for Haskell files
      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'haskell',
        callback = set_haskell_keymaps,
      })
    end,
  },
  {
    'lervag/vimtex',
    ft = 'tex',
    init = function()
      vim.g.vimtex_view_method = 'zathura'
      vim.g.vimtex_syntax_enabled = 0
    end,
  },
  {
    'folke/flash.nvim',
    event = 'VeryLazy',
    config = function()
      require('flash').setup {
        highlight = {
          backdrop = false, -- Disable gray backdrop
        },
        modes = {
          char = {
            highlight = { backdrop = false },
            jump_labels = true,
            label = { exclude = 'hjkliardcypvsex' },
          },
        },
      }
    end,
    opts = {},
    -- stylua: ignore
    keys = {
      { "<leader>f", mode = { "n", "x", "o" }, function() require("flash").jump({search = { forward = true, wrap = false, multi_window = false },}) end, desc = "Flash" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-S>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
    },
  },
  {
    'stevearc/aerial.nvim',
    lazy = false,
    opts = {},
    -- Optional dependencies
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      require('aerial').setup {
        -- add your aerial config here
        on_attach = function(bufnr)
          -- Jump forwards/backwards with '{' and '}'
          vim.keymap.set('n', '{', '<cmd>AerialPrev<CR>', { buffer = bufnr })
          vim.keymap.set('n', '}', '<cmd>AerialNext<CR>', { buffer = bufnr })
        end,
      }
    end,
    vim.keymap.set('n', '<leader>a', '<cmd>AerialToggle!<CR>'),
    vim.keymap.set('n', '<leader>s', '<cmd>lua require("telescope").extensions.aerial.aerial()<CR>'),
  },
  {
    'rust-lang/rust.vim',
    ft = 'rust',
    init = function()
      vim.g.rustfmt_autosave = 1
    end,
  },
  {
    'mrcjkb/rustaceanvim',
    version = '^4',
    lazy = false,
  },
  {
    'saecki/crates.nvim',
    tag = 'stable',
    config = function()
      require('crates').setup()
    end,
  },
  {
    'dnlhc/glance.nvim',
    lazy = false,
    config = function()
      local glance = require 'glance'
      local actions = glance.actions
      glance.setup {
        mappings = {
          list = {
            ['K'] = actions.preview_scroll_win(2),
            ['J'] = actions.preview_scroll_win(-2),
          },
        },
      }
    end,
  },
}
