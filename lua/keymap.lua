local reg = require("which-key").register
local tele_builtin = require("telescope.builtin")
--[[
opts option

mode = "n", -- NORMAL mode
prefix = "", -- prefix for every mappings
buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
silent = true, -- use `silent` when creating keymaps
noremap = true, -- use `noremap` when creating keymaps
nowait = false, -- use `nowait` when creating keymaps
expr = false, -- use `expr` when creating keymaps

]]
--
reg({
  n = {
    l = { "<cmd>noh<cr>", "Turn off highlight after search" },
  },
})

reg({
  j = {
    k = { "<esc>", "Go to normal mode" },
  },
}, { mode = "i" })

reg({
  d = {
    f = { "<esc>", "Go to normal mode" },
  },
}, { mode = "v" })

reg({
  ["<"] = { "<h", "Shift left by 1 indent" },
  [">"] = { ">l", "Shift right by 1 indent" },
}, { mode = { "n", "v" } })

reg({
  t = { "<cmd>NvimTreeToggle<cr>", "Toggle nvim-tree" },
  f = {
    name = "Telescope group",
    f = { tele_builtin.find_files, "Find file" },
    g = { tele_builtin.live_grep, "Live grep" },
    t = { tele_builtin.grep_string, "Grep this string under the cursor in dir" },
    c = { tele_builtin.current_buffer_fuzzy_find, "Fuzzy find current buffer" },
    b = { tele_builtin.buffers, "Navigate buffers" },
    s = { tele_builtin.symbols, "Search symbols" },
    o = { tele_builtin.oldfiles, "List recently opened files" },
    r = { tele_builtin.registers, "List thing in the registers" },
    h = { tele_builtin.help_tags, "Search help" },
  },
}, { prefix = "<leader>" })

reg({
  ["jk"] = { [[<C-\><C-n>]], "Escape from terminal" },
}, { mode = "t" })
