return {
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.6",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        cond = function()
          return vim.fn.executable("make") == 1
        end,
      },
    },
    opts = {
      defaults = {
        layout_config = {
          horizontal = {
            preview_cutoff = 0,
          },
        },
      },
    },
  },
  {
    "nvim-telescope/telescope-ui-select.nvim",
    config = function()
      local tele = require("telescope")
      tele.setup({
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown({}),
          },
        },
      })

      tele.load_extension("ui-select")
    end,
  },
}
