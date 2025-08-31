return {
  {
    "mason-org/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "mason-org/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "vtsls", "vue_ls" },
        automatic_installation = true,
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local vue_language_server_path = vim.fn.stdpath("data")
          .. "/mason/packages/vue-language-server/node_modules/@vue/language-server"
      local vue_plugin = {
        name = "@vue/typescript-plugin",
        location = vue_language_server_path,
        languages = { "vue" },
        configNamespace = "typescript",
      }

      -- Lua
      vim.lsp.enable("lua_ls")

      -- JS/TS/Vue
      vim.lsp.config("vtsls", {
        capabilities = capabilities,
        settings = {
          vtsls = {
            tsserver = {
              globalPlugins = {
                vue_plugin,
              },
            },
          },
        },
        filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
      })
      vim.lsp.enable("vtsls")

      vim.lsp.config("vue_ls", {
        init_options = {
          config = {
            -- Disable LSP formatting for vue
            -- prettier(none-ls) handles all formatting
            vetur = {
              format = false,
            },
          },
        },
      })
      vim.lsp.enable("vue_ls")

      -- CSS/MD/JSON/YAML/HTML
      vim.lsp.config("cssls", { init_options = { provideFormatter = false } })
      vim.lsp.enable("cssls")
      vim.lsp.enable("markdown_oxide")
      vim.lsp.enable("jsonls")
      vim.lsp.enable("yamlls")
      vim.lsp.enable("html")

      -- key bindings
      vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
      vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, {})
      vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})
    end,
  },
}
