return { -- Git but in vim
  {
    "tpope/vim-fugitive",
    cmd = {
      "G", "Git", "Gdiffsplit", "Gread", "Gwrite", "Ggrep", "GMove", "GDelete", "GBrowse",
    },
    keys = {
      { "<leader>g", "<cmd>Git<cr>", desc = "Git status" },
    },
  },
}
