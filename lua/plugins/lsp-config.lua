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
          "bashls",        -- bash
          "biome",         -- js / ts
          "clangd",        -- C/C++
          "cssls",         -- css
          "tailwindcss",   -- tailwind
          "dockerls",      -- docker
          "gopls",         -- go
          "html",
          "jsonls",        -- json
          "lua_ls",        -- lua
          "mdx_analyzer",  -- mdx
          "marksman",      -- markdown
          "ruff",          -- python linter and formatter
          "pyright",       -- python
          "rust_analyzer", -- rust
          "sqls",          -- sql
          "svelte",
          "taplo",         -- toml
          "ts_ls",         -- js / ts
          "yamlls",        -- yaml
          "zls",           -- zig
        },
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      local util = require("lspconfig.util")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      local servers = {
        bashls = { capabilities = capabilities },
        ts_ls = { capabilities = capabilities },
        biome = { capabilities = capabilities, root_dir = util.root_pattern("~/biome.json") },
        clangd = { capabilities = capabilities, init_options = { fallbackFlags = { "-std=c++17" } } },
        cssls = { capabilities = capabilities },
        tailwindcss = { capabilities = capabilities },
        dockerls = { capabilities = capabilities },
        gopls = { capabilities = capabilities },
        html = { capabilities = capabilities },
        jsonls = { capabilities = capabilities },
        lua_ls = {
          capabilities = capabilities,
          on_init = function(client)
            local path = client.workspace_folders[1].name
            if vim.loop.fs_stat(path .. "/.luarc.json") or vim.loop.fs_stat(path .. "/.luarc.jsonc") then
              return
            end
            client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
              runtime = { version = "LuaJIT" },
              workspace = {
                checkThirdParty = false,
                library = { vim.env.VIMRUNTIME },
              },
            })
          end,
          settings = { Lua = {} },
        },
        mdx_analyzer = { capabilities = capabilities },
        marksman = { capabilities = capabilities },
        ruff = {
          capabilities = capabilities,
          init_options = {
            settings = {
              configurationPreference = "filesystemFirst",
              fixAll = false,
            },
          },
        },
        pyright = {
          capabilities = capabilities,
          settings = {
            pyright = { disableOrganizeImports = true },
            python = { analysis = { ignore = { "*" } } },
          },
        },
        rust_analyzer = {
          settings = { ["rust-analyzer"] = { diagnostics = { enable = true } } },
          capabilities = capabilities,
        },
        sqls = { capabilities = capabilities },
        svelte = { capabilities = capabilities },
        taplo = { capabilities = capabilities },
        yamlls = { capabilities = capabilities },
        zls = { capabilities = capabilities },
      }

      -- Register + Enable them all
      for name, config in pairs(servers) do
        vim.lsp.config(name, config)
        vim.lsp.enable(name)
      end


      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

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
