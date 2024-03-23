return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "bashls", -- bash
          "biome", -- js / ts
          "clangd", -- C/C++
          "cssls", -- css
          "dockerls", -- docker
          "gopls", -- go
          "html",
          "jsonls", -- json
          "lua_ls", -- lua
          "marksman", -- markdown
          "ruff_lsp", -- python
          "rust_analyzer", -- rust
          "sqls", -- sql
          "svelte",
          "taplo", -- toml
          "yamlls", -- yaml
          "zls", -- zig
        }
      })
    end
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      local lsp = require("lspconfig")

      -- bash lsp
      lsp.bashls.setup{}

      -- javascript lsp
      lsp.biome.setup{}

      -- clang lsp
      lsp.clangd.setup{}

      -- css lsp
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities.textDocument.completion.completionItem.snippetSupport = true

      lsp.cssls.setup {
        capabilities = capabilities,
      }

      -- docker lsp
      lsp.dockerls.setup{}

      -- go lsp
      lsp.gopls.setup{}

      -- html lsp
      lsp.html.setup{
        capabilities = capabilities
      }

      -- json lsp
      lsp.jsonls.setup {
        capabilities = capabilities,
      }

      -- lua lsp
      lsp.lua_ls.setup {
        on_init = function(client)
          local path = client.workspace_folders[1].name
          if vim.loop.fs_stat(path..'/.luarc.json') or vim.loop.fs_stat(path..'/.luarc.jsonc') then
            return
          end

          client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
            runtime = {
              version = 'LuaJIT'
            },
            workspace = {
              checkThirdParty = false,
              library = {
                vim.env.VIMRUNTIME
              }
            }
          })
        end,
        settings = {
          Lua = {}
        }
      }

      -- markdown lsp
      lsp.marksman.setup{}

      -- python lsp
      lsp.ruff_lsp.setup{}

      -- rust lsp
      lsp.rust_analyzer.setup{
          settings = {
            ['rust-analyzer'] = {
              diagnostics = {
                enable = false;
              }
            }
          }
      }

      -- sql lsp
      lsp.sqls.setup{}

      -- svelte lsp
      lsp.svelte.setup{}

      -- toml lsp
      lsp.taplo.setup{}

      -- yaml lsp
      lsp.yamlls.setup{}

      -- zig lsp
      lsp.zls.setup{}

      -- Keymap setup
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(ev)
          -- Enable completion triggered by <c-x><c-o>
          vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

          -- Buffer local mappings.
          -- See `:help vim.lsp.*` for documentation on any of the below functions
          local opts = { buffer = ev.buf }
          vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
          vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
          vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
          vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
          vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
          vim.keymap.set('n', '<space>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end, opts)
          vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
          vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
          vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
          vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
          vim.keymap.set('n', '<space>f', function()
            vim.lsp.buf.format { async = true }
          end, opts)
        end,
      })
    end
  }
}
