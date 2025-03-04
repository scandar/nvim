return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
    -- {"3rd/image.nvim", opts = {}}, -- Optional image support in preview window: See `# Preview Mode` for more information
  },
  config = function()
    require("neo-tree").setup({
      buffers = {
        follow_current_file = {
          enabled = true,
        },
      },
    })
    vim.keymap.set("n", "<leader>e", ":Neotree filesystem reveal left toggle<CR>")
  end,
}
