vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.g.mapleader = " "
vim.opt.swapfile = false
vim.opt.scrolloff = 5
vim.opt.clipboard = "unnamedplus"
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.cursorline = true

-- Navigate vim panes better
vim.keymap.set("n", "<c-k>", ":wincmd k<CR>")
vim.keymap.set("n", "<c-j>", ":wincmd j<CR>")
vim.keymap.set("n", "<c-h>", ":wincmd h<CR>")
vim.keymap.set("n", "<c-l>", ":wincmd l<CR>")

-- Hybrid line numbers
vim.wo.number = true
vim.wo.relativenumber = true

-- Enable inline diagnostics/virtual text
vim.diagnostic.config({ virtual_text = true })

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("highlight_yank", {}),
	desc = "Hightlight selection on yank",
	pattern = "*",
	callback = function()
		vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
	end,
})

-- Copy relative file path
vim.keymap.set("n", "<leader>cf", function()
	local path = vim.fn.expand("%")
	vim.fn.setreg("+", path)
	print("Copied: " .. path)
end, { desc = "Copy relative file path" })

-- Open current file on GitHub
vim.keymap.set("n", "<leader>gh", function()
	local absolute_path = vim.fn.expand("%:p")
	local git_root = vim.fn.system("git rev-parse --show-toplevel"):gsub("\n", "")
	local line = vim.fn.line(".")
	local remote_url = vim.fn.system("git config --get remote.origin.url"):gsub("\n", "")

	if remote_url == "" then
		print("Not a git repository or no remote origin found")
		return
	end

	if git_root == "" then
		print("Not inside a git repository")
		return
	end

	-- Get relative path from git root
	local relative_path = absolute_path:gsub("^" .. git_root .. "/", "")

	-- Convert SSH URL to HTTPS if needed
	remote_url = remote_url:gsub("git@github.com:", "https://github.com/")
	remote_url = remote_url:gsub("%.git$", "")

	local branch = vim.fn.system("git branch --show-current"):gsub("\n", "")
	local github_url = remote_url .. "/blob/" .. branch .. "/" .. relative_path .. "#L" .. line

	vim.fn.system("open '" .. github_url .. "'")
	print("Opened: " .. github_url)
end, { desc = "Open current file on GitHub" })
