local function foreground(colors)
  local result = {}
  for i, color in ipairs(colors) do
    local group = "Rainbow" .. i
    vim.cmd.highlight(group, "guifg=" .. color)
    result[i] = group
  end
  return result
end

return {

  {
    "stevearc/resession.nvim",
    enabled = false,
    config = function()
      local resession = require("resession")
      resession.setup({})
      vim.api.nvim_create_autocmd({ "VimEnter", "DirChanged" }, {
        callback = function()
          if vim.fn.argc(-1) == 0 then
            resession.load(vim.fn.getcwd(), { dir = ".session", silence_errors = true })
          end
        end,
      })
      vim.api.nvim_create_autocmd({ "VimLeavePre", "DirChangedPre" }, {
        callback = function()
          if vim.fn.argc(-1) == 0 then
            resession.save(vim.fn.getcwd(), { dir = ".session", notify = false })
          end
        end,
      })
    end,
  },

  {
    "HiPhish/rainbow-delimiters.nvim",
    config = function()
      local rd = require("rainbow-delimiters")
      require("rainbow-delimiters.setup").setup({
        strategy = {
          [""] = rd.strategy["global"],
        },
        query = {
          [""] = "rainbow-delimiters",
          latex = "rainbow-blocks",
          tex = "rainbow-blocks",
        },
        highlight = foreground({
          "#82aaff",
          "#ff966c",
          "#c3e88d",
          "#ffc777",
          "#c099ff",
          "#86e1fc",
          "#828bb8",
          "#ff757f",
          "#c8d3f5",
        }),
      })
    end,
  },

  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true,
  },

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
    "folke/trouble.nvim",
    cmd = { "Trouble" },
    config = true,
    keys = {
      {
        "<leader>te",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "[T]oggle [e]rrors",
        silent = true,
      },
    },
  },

  {
    "NvChad/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup({
        user_default_options = {
          RGB = true,
          RRGGBB = true,
          names = true,
          RRGGBBAA = true,
          rgb_fn = true,
          hsl_fn = true,
          css = true,
          css_fn = true,
          mode = "background",
        },
      })
    end,
  },

  {
    "mtdl9/vim-log-highlighting",
    ft = { "log", "txt" },
  },

  {
    "chrishrb/gx.nvim",
    keys = { { "gx", "<cmd>Browse<cr>", mode = { "n", "x" } } },
    cmd = { "Browse" },
    init = function()
      vim.g.netrw_nogx = 1
    end,
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      handler_options = {
        search_engine = "https://search.disroot.org/?q=",
      },
    },
  },

  {
    "mbbill/undotree",
    keys = {
      { "<leader>tu", "<cmd>UndotreeToggle<cr>", desc = "[T]oggle [u]ndo tree", silent = true },
    },
  },

  {
    "numToStr/Comment.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    keys = { { "gc", mode = { "n", "v" } } },
    config = true,
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
