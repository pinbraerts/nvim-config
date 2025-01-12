local is_tty = vim.fn.has("gui_running") == 0

return {

  {
    "EdenEast/nightfox.nvim",
    opts = {
      options = {
        transparent = is_tty,
      },
      groups = {
        all = {
          WinSeparator = { fg = "#719cd6" },
          DiffAdd = { fg = "#9ece6a" },
          DiffDelete = { fg = "#bf616a" },
          DiffChange = { fg = "#e0af68" },
        },
      },
    },
    lazy = true,
  },

  {
    "rebelot/kanagawa.nvim",
    opts = {
      transparent = is_tty,
    },
    lazy = true,
  },

  {
    "catppuccin/nvim",
    name = "catppuccin",
    opts = {
      transparent_background = is_tty,
    },
    lazy = true,
  },

  {
    "folke/tokyonight.nvim",
    opts = {
      transparent = is_tty,
      styles = is_tty and {
        sidebars = "transparent",
        floats = "transparent",
      } or nil,
      lualine_bold = true,
    },
    lazy = true,
  },
}
