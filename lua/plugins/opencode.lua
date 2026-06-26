local opencode_cmd = { "tokamak", "launch", "--pool", "opencode", "--port" }

local opencode_buf = nil
local opencode_win = nil
local opencode_job = nil

local function open_opencode()
  if opencode_win and vim.api.nvim_win_is_valid(opencode_win) then
    return
  end

  vim.cmd("botright vsplit")
  opencode_win = vim.api.nvim_get_current_win()

  if opencode_buf and vim.api.nvim_buf_is_valid(opencode_buf) then
    vim.api.nvim_win_set_buf(opencode_win, opencode_buf)
    vim.cmd("startinsert")
    return
  end

  opencode_buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_win_set_buf(opencode_win, opencode_buf)

  opencode_job = vim.fn.termopen(opencode_cmd, {
    cwd = vim.fn.getcwd(),
    on_exit = function()
      opencode_job = nil
      opencode_buf = nil
      opencode_win = nil
    end,
  })

  vim.cmd("startinsert")
end

local function toggle_opencode()
  if opencode_win and vim.api.nvim_win_is_valid(opencode_win) then
    vim.api.nvim_win_close(opencode_win, true)
    opencode_win = nil
    return
  end

  open_opencode()
end

return {
  "NickvanDyke/opencode.nvim",
  dependencies = {
    { "folke/snacks.nvim", opts = { input = {}, picker = {}, terminal = {} } },
  },
  init = function()
    vim.g.opencode_opts = {
      server = {
        start = function()
          open_opencode()
        end,
      },
    }
  end,
  config = function()
    vim.o.autoread = true

    vim.keymap.set({ "n", "x" }, "<C-a>", function() require("opencode").ask("@this: ") end,
      { desc = "Ask opencode…" })
    vim.keymap.set({ "n", "x" }, "<C-x>", function() require("opencode").select() end,
      { desc = "Execute opencode action…" })
    vim.keymap.set({ "n", "t" }, "<C-.>", toggle_opencode, { desc = "Toggle opencode" })

    vim.keymap.set({ "n", "x" }, "go", function() return require("opencode").operator("@this ") end,
      { desc = "Add range to opencode", expr = true })
    vim.keymap.set("n", "goo", function() return require("opencode").operator("@this ") .. "_" end,
      { desc = "Add line to opencode", expr = true })

    vim.api.nvim_create_autocmd("VimLeavePre", {
      callback = function()
        if opencode_job then
          vim.fn.jobstop(opencode_job)
        end
      end,
    })
  end,
}
