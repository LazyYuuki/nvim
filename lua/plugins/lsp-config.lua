return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "bashls",      -- bash
          "biome",       -- js / ts
          "clangd",      -- C/C++
          "cssls",       -- css
          "tailwindcss", -- tailwind
          "dockerls",    -- docker
          "html",
          "marksman",    -- markdown
          "ruff",        -- python linter and formatter
          "pyright",     -- python
          "svelte",
          "ts_ls",       -- js / ts
        },
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      local lsp = require("lspconfig")
      local util = require("lspconfig.util")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- bash lsp
      lsp.bashls.setup({
        capabilities = capabilities,
      })

      -- javascript lsp
      lsp.ts_ls.setup({
        capabilities = capabilities,
      })

      lsp.biome.setup({
        capabilities = capabilities,
        root_dir = util.root_pattern("~/biome.json"),
      })

      -- clang lsp
      lsp.clangd.setup({
        capabilities = capabilities,
        init_options = {
          -- Check here for reason
          -- https://github.com/clangd/coc-clangd/issues/20
          fallbackFlags = { "-std=c++17" },
        },
      })

      -- css lsp
      lsp.cssls.setup({
        capabilities = capabilities,
      })

      -- tailwind lsp
      lsp.tailwindcss.setup({
        capabilities = capabilities,
      })

      -- docker lsp
      lsp.dockerls.setup({
        capabilities = capabilities,
      })

      -- html lsp
      lsp.html.setup({
        capabilities = capabilities,
      })

      -- markdown lsp
      lsp.marksman.setup({
        capabilities = capabilities,
      })

      -- python lsp
      -- this is for linting and formatting
      lsp.ruff.setup({
        capabilities = capabilities,
        init_options = {
          settings = {
            configurationPreference = "filesystemFirst",
            fixAll = false,
          },
        },
      })

      -- this is for autocompletion
      lsp.pyright.setup({
        capabilities = capabilities,
        settings = {
          pyright = {
            disableOrganizeImports = true,
          },
          python = {
            analysis = {
              ignore = { "*" },
            },
          },
        },
      })

      -- svelte lsp
      lsp.svelte.setup({
        capabilities = capabilities,
      })

      -- Keymap setup
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          -- Enable completion triggered by <c-x><c-o>
          vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

          -- Buffer local mappings.
          -- See `:help vim.lsp.*` for documentation on any of the below functions
          local opts = { buffer = ev.buf }
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
          vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
          vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
          vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, opts)
          vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, opts)
          vim.keymap.set("n", "<space>wl", function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end, opts)
          vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, opts)
          vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
          vim.keymap.set({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, opts)
          vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
          vim.keymap.set("n", "<space>f", function()
            vim.lsp.buf.format({ async = true })
          end, opts)
        end,
      })
    end,
    opts = {
      servers = {
        tsserver = {
          tsserver = {
            on_attach = function(client)
              client.server_capabilities.documentFormattingProvider = false
              client.server_capabilities.documentLintingProvider = false
            end,
          },
        },
        biome = {},
      },
    },
  },
}
