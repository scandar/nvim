return {
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
    },
    config = function()
      local cmp = require("cmp")
      require("luasnip.loaders.from_vscode").lazy_load()

      local function is_in_start_tag()
        local ts_utils = require("nvim-treesitter.ts_utils")
        local node = ts_utils.get_node_at_cursor()
        if not node then
          return false
        end
        local node_to_check = { "start_tag", "self_closing_tag", "directive_attribute" }
        return vim.tbl_contains(node_to_check, node:type())
      end

      cmp.setup({
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        }),
        sources = cmp.config.sources({
          {
            name = "nvim_lsp",
            -- Vue component props/events completion
            entry_filter = function(entry, ctx)
              -- Use a buffer-local variable to cache the result of the Treesitter check
              local bufnr = ctx.bufnr
              local cached_is_in_start_tag = vim.b[bufnr]._vue_ts_cached_is_in_start_tag
              if cached_is_in_start_tag == nil then
                vim.b[bufnr]._vue_ts_cached_is_in_start_tag = is_in_start_tag()
              end
              -- If not in start tag, return true
              if vim.b[bufnr]._vue_ts_cached_is_in_start_tag == false then
                return true
              end
              --- Check if the buffer type is 'vue'
              if ctx.filetype ~= "vue" then
                return true
              end

              local cursor_before_line = ctx.cursor_before_line
              -- For events
              if cursor_before_line:sub(-1) == "@" then
                return entry.completion_item.label:match("^@")
                -- For props also exclude events with `:on-` prefix
              elseif cursor_before_line:sub(-1) == ":" then
                return entry.completion_item.label:match("^:")
                    and not entry.completion_item.label:match("^:on%-")
              else
                return true
              end
            end,
          },
          { name = "luasnip" }, -- For luasnip users.
        }, {
          { name = "buffer" },
        }),
      })
      -- Clear the cache when the menu is closed
      cmp.event:on("menu_closed", function()
        local bufnr = vim.api.nvim_get_current_buf()
        vim.b[bufnr]._vue_ts_cached_is_in_start_tag = nil
      end)
    end,
  },
}
