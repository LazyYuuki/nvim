return { -- it is for status line the one at the bottom
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  opts = {
    options = {
      theme = "ayu"
    },
    sections = {
      lualine_c = {
        {
          'filename',
          path = 3, -- 1 for relative path, 2 for absolute path
          -- Or use path = 3 for absolute path with tilde for home directory
        }
      },
    },
  },
}
