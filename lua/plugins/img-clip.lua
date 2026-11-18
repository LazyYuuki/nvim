return {
  "HakonHarnes/img-clip.nvim",
  event = "VeryLazy",
  opts = {
    default = {
      dir_path = "assets",
      relative_to_current_file = true,
      prompt_for_file_name = true,
      -- pngpaste writes a bogus gAMA chunk that washes images out in browsers.
      process_cmd = "python3 " .. vim.fn.stdpath("config") .. "/scripts/png-strip-gamma.py",
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
