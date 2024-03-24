vim.g.mapleader = " "

vim.keymap.set("i", "jk", "<esc>")
vim.keymap.set("n", "<leader>tt", ":NvimTreeToggle<Cr>") -- toggle nvim-tree
vim.keymap.set({ "n", "v" }, "<", "<h") -- shift left
vim.keymap.set({ "n", "v" }, ">", ">l") -- shift right
vim.keymap.set("t", "jk", [[<C-\><C-n>]]) -- go to normal mode from insert mode in terminal
