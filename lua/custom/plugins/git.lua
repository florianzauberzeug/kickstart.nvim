-- Reviewing branches and commits: diffview.nvim shows every changed file of a
-- range as side-by-side diffs. See `:help diffview`.
vim.pack.add { 'https://github.com/sindrets/diffview.nvim' }
require('diffview').setup {}

-- The branch the repo's remote calls its default (usually origin/main).
local function default_branch()
  local ref = vim.fn.systemlist({ 'git', 'rev-parse', '--abbrev-ref', 'origin/HEAD' })[1]
  if vim.v.shell_error ~= 0 or not ref or ref == '' then return 'origin/main' end
  return ref
end

vim.keymap.set('n', '<leader>gd', function() vim.cmd('DiffviewOpen ' .. default_branch() .. '...HEAD') end,
  { desc = 'Git [d]iff of the branch against main' })
vim.keymap.set('n', '<leader>gc', '<cmd>DiffviewOpen HEAD~1<CR>', { desc = 'Git diff of the last [c]ommit' })
vim.keymap.set('n', '<leader>gh', '<cmd>DiffviewFileHistory<CR>', { desc = 'Git commit [h]istory of the repo' })
vim.keymap.set('n', '<leader>gf', '<cmd>DiffviewFileHistory %<CR>', { desc = 'Git commit history of this [f]ile' })
vim.keymap.set('n', '<leader>gq', '<cmd>DiffviewClose<CR>', { desc = 'Git [q]uit diffview' })

-- Toggle the gitsigns in the gutter between "uncommitted changes" and "what the branch changed".
local branch_base = nil
vim.keymap.set('n', '<leader>gb', function()
  branch_base = not branch_base and default_branch() or nil
  require('gitsigns').change_base(branch_base, true)
  vim.notify(branch_base and ('Signs show changes against ' .. branch_base) or 'Signs show uncommitted changes')
end, { desc = 'Git signs against the [b]ranch base (toggle)' })

require('which-key').add { { '<leader>g', group = '[G]it' } }
