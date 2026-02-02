return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "ravitemer/mcphub.nvim",
  },
  opts = {
    -- NOTE: The log_level is in `opts.opts`
    opts = {
      log_level = "DEBUG", -- or "TRACE"
    },
  },
  config = function()
    require("codecompanion").setup({
      display = {
        action_palette = {
          provider = "default",
        }
      },
      extensions = {
        mcphub = {
          callback = "mcphub.extensions.codecompanion",
          opts = {
            make_vars = true,
            make_slash_commands = true,
            show_result_in_chat = true
          }
        }
      },
      interactions = {
        chat = {
          adapter = {
            name = "opencode",
          }
        },
        inline = {
          adapter = "openai",
        },
        cmd = {
          adapter = "openai",
        },
        background = {
          adapter = {
            name = "opencode",
          }
        }
      }
    })
  end,
}
