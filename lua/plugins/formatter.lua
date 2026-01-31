return { -- conform is a formatter plugin
  {
    "stevearc/conform.nvim",
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          cpp = { "clang-format" },
          go = { "gofmt" },
          javascript = { "biome" },
          typescript = { "biome" },
          lua = { "stylua" },
          python = { "ruff_format", "ruff_fix" },
          rust = { "rustfmt" },
          toml = { "taplo" },
          zig = { "zigfmt" },
        },
        format_on_save = {
          timeout_ms = 500,
          lsp_fallback = true,
        },
      })
    end,
  },
  {
    "zapling/mason-conform.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "stevearc/conform.nvim",
    },
  },
}
