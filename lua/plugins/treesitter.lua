return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter.configs").setup({
      ensure_installed = {
        "c",
        "css",
        "scss",
        "go",
        "html",
        "javascript",
        "typescript",
        "json",
        "lua",
        "ocaml",
        "python",
        "rust",
        "vim",
        "vimdoc",
        "zig",
        "svelte",
        "commonlisp",
      },
      highlight = {
        enable = true,
        disable = function(lang, buf)
          local max_filesize = 100 * 1024 -- 100 KB
          local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
          if ok and stats and stats.size > max_filesize then
            return true
          end
        end,
      },
      indent = { enable = true },
    })
  end,
}
