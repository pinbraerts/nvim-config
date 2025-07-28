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
    submodules = false,
    opts = {
      open_browser_app = "yandex-browser",
      handler_options = {
        search_engine = "yandex",
      },
      handlers = {
        rust = {
          name = "rust",
          filetype = { "toml" },
          filename = "Cargo.toml",
          handle = function(mode, line, _)
            local crate = require("gx.helper").find(line, mode, "(%w+)%s-=%s")
            if crate then
              return "https://crates.io/crates/" .. crate
            end
          end,
        },
        github_actions = {
          name = "checkout",
          filetype = { "yaml" },
          handle = function(mode, line, _)
            local action = require("gx.helper").find(line, mode, ": ([a-zA-Z-_]+/[a-zA-Z-_]+)@v%d+")
            if action and #action < 50 then
              return "https://github.com/" .. action
            end
          end,
        },
        startrek = {
          name = "startrek",
          handle = function(mode, line, _)
            local ticket = require("gx.helper").find(line, mode, "(%u+-%d+)")
            if ticket and #ticket < 20 then
              return "https://st.yandex-team.ru/" .. ticket
            end
          end,
        },
        trace_id = {
          name = "trace_id",
          handle = function(mode, line, _)
            local trace_id = require("gx.helper").find(line, mode, "X-YaTraceId: (%w+)")
            if trace_id and #trace_id < 40 then
              return "m.yandex-team.ru/projects/market/traces/" .. trace_id
            end
          end,
        },
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
    "pinbraerts/restman.nvim",
  },

  {
    "numToStr/Comment.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    keys = { { "gc", mode = { "n", "v" } } },
    config = true,
  },
}
