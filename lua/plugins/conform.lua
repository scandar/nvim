return {
	"stevearc/conform.nvim",
	opts = {},
	config = function()
		local conform = require("conform")

		conform.setup({
			formatters_by_ft = {
				lua = { "stylua" },
				javascript = { "prettier" },
				typescript = { "prettier" },
				vue = { "prettier" },
				typescriptreact = { "prettier" },
				javascriptreact = { "prettier" },
				json = { "prettier" },
				css = { "prettier" },
				scss = { "prettier" },
				html = { "prettier" },
				markdown = { "prettier" },
			},
		})

		vim.keymap.set("n", "<leader>gf", conform.format, {})
		vim.api.nvim_create_autocmd("BufWritePre", {
			pattern = "*",
			callback = function(args)
				conform.format({ bufnr = args.buf })
			end,
		})
	end,
}
