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
    opts = {
      navigation = {
        enable_default_keybindings = true,
        cycle_navigation = true,
        persist_zoom = true,
      },
      copy_sync = {
        sync_clipboard = true,
      },
      resize = {
        enable_default_keybindings = false,
      },
    },
    keys = {
      {
        "<c-n>",
        function()
          require("tmux").next_window()
        end,
        desc = "Select next tmux window",
        silent = true,
        nowait = true,
      },
      {
        "<c-p>",
        function()
          require("tmux").previous_window()
        end,
        desc = "Select previous tmux window",
        silent = true,
        nowait = true,
      },
      "<c-h>",
      "<c-j>",
      "<c-k>",
      "<c-l>",
    },
  },
}
