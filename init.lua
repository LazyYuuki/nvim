package.path = package.path .. ";/Users/yuuki/.config/nvim/?.lua"

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)
vim.opt.clipboard = "unnamedplus"

vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.filetype.add({
  extension = {
    zon = "zig",
    pcss = "scss",
    postcss = "scss",
    urdf = "xml",
    mdx = "markdown",
  },
})

require("vim-setup")
require("lazy").setup("plugins")
require("keymap")
require("agent-reload")
