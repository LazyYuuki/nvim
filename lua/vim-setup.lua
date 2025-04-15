vim.cmd("set tabstop=2")
vim.cmd("set shiftwidth=2")
vim.cmd("set softtabstop=0")
vim.cmd("set expandtab")
vim.cmd("set lcs+=space:·")
vim.cmd("set number relativenumber")
vim.cmd("set iskeyword-=_")

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
