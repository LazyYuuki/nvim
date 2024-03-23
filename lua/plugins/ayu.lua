return {
  "Shatur/neovim-ayu",
  lazy = false,
  name = "ayu",
  config = function()
    require('ayu').setup({
      mirage = false, 
      overrides = {}
    })
    vim.cmd.colorscheme "ayu"
  end
}
