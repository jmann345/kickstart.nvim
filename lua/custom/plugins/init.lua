return {
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
            label = { exclude = 'hjklwoiardcypvsex' },
          },
        },
      }
    end,
    opts = {},
    -- stylua: ignore
    keys = {
      { "<leader>f", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "<leader>t", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
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
  {
    'cbochs/grapple.nvim',
    dependencies = {
      { 'nvim-tree/nvim-web-devicons' },
    },
    opts = {
      scope = 'git_branch',
      icons = true,
      quick_select = '123456789',
    },
    keys = {
      { 'M', '<cmd>Grapple toggle<cr>', desc = 'Grapple toggle tag' },
      { '<leader>m', '<cmd>Grapple toggle_tags<cr>', desc = 'Grapple open tags window' },
      { '<leader>h', '<cmd>Grapple cycle_tags prev<cr>', desc = 'Go to previous tag' },
      { '<leader>l', '<cmd>Grapple cycle_tags next<cr>', desc = 'Go to next tag' },
    },
  },
}
