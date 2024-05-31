local map = vim.keymap.set
local mapn = function(bind, cmd, opts)
  vim.keymap.set('n', bind, cmd, opts)
end
local opts = { noremap = true }
--[[ 
						*m[* *m]*
m[  or  m]		Set the |'[| or |']| mark.  Useful when an operator is
			to be simulated by multiple commands.  (does not move
			the cursor, this is not a motion command).
--]]
mapn('H', "['", opts) -- fix this (use marks.nvim)
mapn('L', "]'", opts) -- fix this (use marks.nvim)
-- buffers
mapn('<leader>1', '<cmd>BufferGoto 1<CR>', opts)
mapn('<leader>2', '<cmd>BufferGoto 2<CR>', opts)
mapn('<leader>3', '<cmd>BufferGoto 3<CR>', opts)
mapn('<leader>4', '<cmd>BufferGoto 4<CR>', opts)
mapn('<leader>5', '<cmd>BufferGoto 5<CR>', opts)
mapn('<leader>6', '<cmd>BufferGoto 6<CR>', opts)
mapn('<leader>7', '<cmd>BufferGoto 7<CR>', opts)
mapn('<leader>8', '<cmd>BufferGoto 8<CR>', opts)
mapn('<leader>9', '<cmd>BufferGoto 9<CR>', opts)
map('n', '<C-s>', '<cmd>w<CR>', { desc = 'Exit terminal mode' })
map('n', '<Tab>', '<cmd>BufferNext<CR>', opts)
map('n', '<S-Tab>', '<cmd>BufferPrevious<CR>', opts)
map('n', '<leader>n', '<cmd>BufferMoveNext<CR>', opts)
map('n', '<leader>p', '<cmd>BufferMovePrevious<CR>', opts)
map('n', '<leader>x', '<cmd>BufferClose<CR>', { desc = 'Close current buffer' })
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
mapn('gd', '<cmd>Glance definitions<CR>', { noremap = true, desc = 'Glance definitions' })
mapn('gr', '<cmd>Glance references<CR>', { noremap = true, desc = 'Glance references' })
mapn('gy', '<cmd>Glance type_definitions<CR>', { noremap = true, desc = 'Glance type definitions' })
mapn('gm', '<cmd>Glance implementations<CR>', { noremap = true, desc = 'Glance implementations' })
