local add = require("which-key").add
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

add({
  { "gx", "<esc>:URLOpenUnderCursor<cr>", desc = "Open link under cursor" },
})

add({
  { "<leader>nl", "<cmd>noh<cr>",            desc = "Turn off highlight after search" },
  { "jk",         "<esc>",                   desc = "Go to normal mode",              mode = "i" },
  { "df",         "<esc>",                   desc = "Go to normal mode",              mode = "v" },
  { "<leader>t",  "<cmd>NvimTreeToggle<cr>", desc = "Toggle nvim-tree" },
  { "<leader>of", vim.diagnostic.open_float, desc = "Open diagnostic in float window" },
  { "jk",         [[<C-\><C-n>]],            desc = "Escape from terminal",           mode = "t" },
})

add({
  mode = { "n", "v" },
  { "<", "<h", desc = "Shift left by 1 indent" },
  { ">", ">l", desc = "Shift right by 1 indent" },
})

add({
  { "<leader>oc", function() require("agentic").toggle() end,                           desc = "Toggle Agentic Chat" },
  { "<leader>oa", function() require("agentic").add_selection_or_file_to_context() end, desc = "Add file to Agentic Context" },
  { "<leader>on", function() require("agentic").new_session() end,                      desc = "New Agentic Session" },
})

add({
  { "<leader>ff", tele_builtin.find_files,                desc = "Find files" },
  { "<leader>fg", tele_builtin.live_grep,                 desc = "Live grep" },
  { "<leader>ft", tele_builtin.grep_string,               desc = "Grep this string under the cursor in dir" },
  { "<leader>fc", tele_builtin.current_buffer_fuzzy_find, desc = "Fuzzy find current buffer" },
  { "<leader>fb", tele_builtin.buffers,                   desc = "Navigate buffers" },
  { "<leader>fs", tele_builtin.symbols,                   desc = "Search symbols" },
  { "<leader>fo", tele_builtin.oldfiles,                  desc = "List recently opened files" },
  { "<leader>fr", tele_builtin.registers,                 desc = "List thing in the registers" },
  { "<leader>fh", tele_builtin.help_tags,                 desc = "Search help" },
})
