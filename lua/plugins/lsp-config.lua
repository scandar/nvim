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
				ensure_installed = { "lua_ls", "ts_ls" },
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			local lspconfig = require("lspconfig")
			local vue_language_server = vim.fn.stdpath("data")
				.. "/mason/packages/vue-language-server/node_modules/@vue/language-server"

			lspconfig.lua_ls.setup({
				capabilities = capabilities,
			})
			lspconfig.rust_analyzer.setup({
				capabilities = capabilities,
				on_attach = function(_, bufnr)
					vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
				end,
			})
			lspconfig.markdown_oxide.setup({
				capabilities = capabilities,
			})
			lspconfig.cssls.setup({
				capabilities = capabilities,
				init_options = { provideFormatter = false },
			})
			lspconfig.html.setup({
				capabilities = capabilities,
			})
			lspconfig.jsonls.setup({
				capabilities = capabilities,
			})
			lspconfig.ts_ls.setup({
				capabilities = capabilities,
				init_options = {
					plugins = {
						{
							name = "@vue/typescript-plugin",
							location = vue_language_server,
							languages = { "vue" },
						},
					},
				},
				filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
			})
			lspconfig.emmet_language_server.setup({
				filetypes = { "html", "css", "javascriptreact", "typescriptreact", "vue" },
				capabilities = capabilities,
			})

			vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
			vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, {})
			vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})
		end,
	},
}
