return {
	"saecki/crates.nvim",
	tag = "stable",
	ft = "toml",
	config = function()
		require("crates").setup({
			completion = {
				cmp = {
					enabled = true,
				},
			},
		})
		require("cmp").setup({
			sources = {
				{ name = "crates" },
			},
		})
	end,
}
