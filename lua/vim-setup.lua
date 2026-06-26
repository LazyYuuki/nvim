vim.cmd("set tabstop=2")
vim.cmd("set shiftwidth=2")
vim.cmd("set softtabstop=0")
vim.cmd("set expandtab")
vim.cmd("set lcs+=space:·")
vim.cmd("set number relativenumber")
vim.cmd("set iskeyword-=_")
vim.cmd("aunmenu PopUp")

-- vim.cmd("set list")
vim.cmd("set linebreak")
vim.cmd("set wrap")

vim.cmd("runtime macros/matchit.vim")
vim.cmd("filetype plugin on")
vim.opt.cursorline = true
vim.opt.timeoutlen = 300
vim.opt.updatetime = 300

vim.g["conjure#mapping#doc_word"] = "rk"

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup('lsp_attach_disable_ruff_hover', { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client == nil then
      return
    end
    if client.name == 'ruff' then
      -- Disable hover in favor of Pyright
      client.server_capabilities.hoverProvider = false
    end
  end,
  desc = 'LSP: Disable hover capability from Ruff',
})

-- indent color scheme
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    vim.api.nvim_set_hl(0, "IblIndent", { fg = "#2d5a3f", nocombine = true })
    vim.api.nvim_set_hl(0, "MiniIndentscopeSymbol", { fg = "#39FF14", bold = true, nocombine = true })
  end,
})

-- make shift GitDiff
vim.api.nvim_create_user_command('GitDiff', function()
  -- 1. Get the current file path relative to git
  local file_path = vim.fn.expand('%')

  -- 2. Open a new vertical split window for the Git version
  vim.cmd('vertical new')
  local git_buf = vim.api.nvim_get_current_buf()

  -- 3. Configure the temporary Git window
  vim.bo[git_buf].buftype = 'nofile'
  vim.bo[git_buf].bufhidden = 'wipe'
  vim.bo[git_buf].swapfile = false

  -- 4. Safely pull the git version into this window
  local git_cmd = string.format('git show HEAD:%s', file_path)
  vim.cmd('silent read !' .. git_cmd)

  -- 5. Delete the extra blank line created by 'read'
  vim.cmd('1delete_')

  -- 6. Turn on diff mode in both windows
  vim.cmd('diffthis')
  vim.cmd('wincmd p') -- Switch back to your working file
  vim.cmd('diffthis')
end, {})
