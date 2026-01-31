return {
  "andrewferrier/debugprint.nvim",
  dependencies = {
    "nvim-telescope/telescope.nvim", -- Optional: If you want to use the `:Debugprint search` command with telescope.nvim
  },
  config = function()
    require("debugprint").setup({
    })
  end,
  lazy = false,  -- Required to make line highlighting work before debugprint is first used
  version = "*", -- Remove if you DON'T want to use the stable version
}
