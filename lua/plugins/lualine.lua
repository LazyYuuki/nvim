return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    require("lualine").setup({
      options = {
        theme = "ayu"
      },
      sections = {
        lualine_c = {
          {
            'filename',
            path = 1, -- 1 for relative path, 2 for absolute path
            -- Or use path = 3 for absolute path with tilde for home directory
          }
        },
      },
    })
  end
}
