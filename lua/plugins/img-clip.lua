return {
  "HakonHarnes/img-clip.nvim",
  event = "VeryLazy",
  opts = {
    default = {
      dir_path = "assets",
      relative_to_current_file = true,
      prompt_for_file_name = true,
    },
  },
  keys = {
    {
      "<leader>ip",
      "<cmd>PasteImage<cr>",
      desc = "Paste clipboard image",
    },
  },
}
