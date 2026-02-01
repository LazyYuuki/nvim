vim.o.autoread = true
vim.o.updatetime = 200

vim.api.nvim_create_autocmd(
  { "BufEnter", "CursorHold", "CursorHoldI" },
  { command = "checktime" }
)

vim.api.nvim_create_autocmd("FileChangedShellPost", {
  callback = function(args)
    local bufnr = args.buf
    if not vim.api.nvim_buf_is_loaded(bufnr) then
      return
    end

    -- Only reload real file buffers
    local bt = vim.bo[bufnr].buftype
    if bt ~= "" then
      return
    end

    -- Don't clobber modified buffers
    if vim.bo[bufnr].modified then
      return
    end

    vim.api.nvim_buf_call(bufnr, function()
      vim.cmd("edit!")
    end)
  end,
})
