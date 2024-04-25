local map = vim.keymap.set
local mapn = function(bind, cmd, opts)
  vim.keymap.set('n', bind, cmd, opts)
end
local opts = { noremap = true, silent = true }
map('n', '<C-s>', '<cmd>w<CR>', { desc = 'Exit terminal mode' })
map('n', '<S-Tab>', '<Plug>(cokeline-focus-prev)', opts)
map('n', '<Tab>', '<Plug>(cokeline-focus-next)', opts)
map('n', '<Leader>p', '<Plug>(cokeline-switch-prev)', opts)
map('n', '<Leader>n', '<Plug>(cokeline-switch-next)', opts)
map('n', '<leader>x', '<cmd>bd<CR>', { desc = 'Close current buffer' })
map('n', '<leader>q', '<cmd>q<CR>', { desc = 'Quit' })
map('x', 'p', 'P', { desc = 'Disable yanking selected text in V mode' })
vim.api.nvim_set_keymap('n', '<C-n>', ':NvimTreeToggle<cr>', opts)

-- Diagnostic keymaps
map('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
map('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
map('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
map('n', '<leader>fq', vim.diagnostic.setloclist, { desc = 'Open diagnostic Quick[F]ix list' })

function CopyDiagnosticMessage()
  local diagnostics = vim.diagnostic.get(0, { lnum = vim.api.nvim_win_get_cursor(0)[1] - 1 })
  if #diagnostics == 0 then
    print 'No diagnostics to copy'
    return
  end

  local lines = {}
  for _, diagnostic in ipairs(diagnostics) do
    table.insert(lines, diagnostic.message)
  end
  local message = table.concat(lines, '\n')
  vim.fn.setreg('+', message)
  print 'Diagnostic message copied to clipboard'
end
mapn('<leader>dc', '<cmd>lua CopyDiagnosticMessage()<CR>', { desc = 'Copy diagnostic message to clipboard' })
mapn('<leader>rcu', function()
  require('crates').upgrade_all_crates()
end, { desc = 'Update crates' })
mapn('<leader>gd', '<cmd>Glance definitions<CR>', { noremap = true, desc = 'Glance definitions' })
mapn('<leader>gr', '<cmd>Glance references<CR>', { noremap = true, desc = 'Glance references' })
mapn('<leader>gy', '<cmd>Glance type_definitions<CR>', { noremap = true, desc = 'Glance type definitions' })
mapn('<leader>gm', '<cmd>Glance implementations<CR>', { noremap = true, desc = 'Glance implementations' })
