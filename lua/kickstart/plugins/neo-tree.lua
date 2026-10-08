-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

vim.pack.add {
  { src = 'https://github.com/nvim-neo-tree/neo-tree.nvim', version = vim.version.range '*' },
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/MunifTanjim/nui.nvim',
}

vim.keymap.set('n', '\\', '<Cmd>Neotree reveal<CR>', { desc = 'NeoTree reveal', silent = true })
vim.keymap.set('n', '<leader>e', '<Cmd>Neotree toggle reveal<CR>', { desc = 'File [E]xplorer', silent = true }) -- `\` is awkward on a German keyboard

require('neo-tree').setup {
  window = {
    width = 28, -- default is 40
  },
  filesystem = {
    window = {
      mappings = {
        ['\\'] = 'close_window',
      },
    },
  },
}

-- Open the tree on startup, but keep the cursor in the file (skip for git commit messages etc.)
vim.api.nvim_create_autocmd('VimEnter', {
  callback = function()
    if vim.tbl_contains({ 'gitcommit', 'gitrebase' }, vim.bo.filetype) then return end
    vim.cmd 'Neotree show'
  end,
})
