return {
  "folke/snacks.nvim",
  opts = {
    dashboard = {
      -- row = 2,
      sections = {
        {
          section = "terminal",
          cmd = "img2art ~/.config/nvim/media/wave.png --scale 0.1 --threshold 120 --alpha",
          height = 21,
          width = 70,
          indent = -5,
          padding = 1,
        },
        { section = "keys",   padding = 1 },
        {
          section = "recent_files",
          padding = 1,
        },
        { section = "startup" },
      },
    },
  },
}
