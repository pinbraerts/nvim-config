return {
  {
    "nanotee/zoxide.vim",
    cond = function()
      return vim.fn.executable("zoxide") ~= 0
    end,
    cmd = {
      "Z",
      "Lz",
      "Tz",
      "Zi",
      "Lzi",
      "Tzi",
    },
  },

  {
    "mikavilpas/yazi.nvim",
    cond = function()
      return vim.fn.executable("yazi") ~= 0
    end,
    cmd = { "Yazi" },
    keys = {
      {
        "<leader>fb",
        "<cmd>Yazi<cr>",
        desc = "Open yazi file manager in current working directory",
      },
      {
        "<leader>wd",
        "<cmd>Yazi cwd<cr>",
        desc = "Open yazi file manager in current working directory",
      },
    },
    opts = {
      open_for_directories = false,
      use_yazi_client_id_flag = true,
    },
  },

  {
    "aserowy/tmux.nvim",
    enable = vim.fn.executable("tmux") ~= 0,
    cond = function()
      return os.getenv("TMUX") ~= nil
    end,
    config = function()
      local tmux = require("tmux")
      tmux.setup({
        navigation = {
          enable_default_keybindings = true,
          cycle_navigation = false,
          persist_zoom = true,
        },
        copy_sync = {
          sync_clipboard = true,
        },
        resize = {
          enable_default_keybindings = false,
        },
      })
    end,
  },
}
