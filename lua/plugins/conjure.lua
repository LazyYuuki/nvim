return { -- run code like repl
  {
    "Olical/conjure",
    ft = { "python", "lisp", "lua" }, -- etc
    lazy = true,
    init = function()
      -- Set configuration options here
      vim.g["conjure#debug"] = true
    end,
  },
}
