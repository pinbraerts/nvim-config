vim.wo.foldmethod = "expr"
vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.o.foldlevel = 9999

return {
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      "nvim-treesitter/nvim-treesitter-context",
    },
    build = ":TSUpdate",
    lazy = false,
    opts = {
      ensure_installed = {},
      auto_install = true,
      sync_install = false,
      ignore_install = {},
      modules = {},
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      indent = { enable = true, disable = { "c", "cpp" } },
      incremental_selection = { enable = true },
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          include_surrounding_whitespace = function(options)
            return options.selection_mode == "V"
          end,
          keymaps = {
            ["a="] = { query = "@assignment.outer", desc = "[a]round of assignment" },
            ["="] = { query = "@assignment.lhs", desc = "[i]nside of assignment" },
            ["i="] = { query = "@assignment.rhs", desc = "[i]nside of assignment" },
            ["a,"] = { query = "@parameter.outer", desc = "[a]round argument" },
            ["i,"] = { query = "@parameter.inner", desc = "[i]nside argument" },
            ["ad"] = { query = "@function.outer", desc = "[a]round function [d]efinition" },
            ["id"] = { query = "@function.inner", desc = "[i]nside function [d]efinition" },
            ["af"] = { query = "@call.outer", desc = "[a]round [f]unction call" },
            ["if"] = { query = "@call.inner", desc = "[i]nside [f]unction call" },
            ["ac"] = { query = "@class.outer", desc = "[a]round [c]lass" },
            ["ic"] = { query = "@class.inner", desc = "[i]nside [c]lass" },
          },
          selection_modes = {
            ["@function.outer"] = "V",
            ["@class.outer"] = "V",
          },
        },
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = {
            ["]m"] = { query = "@function.outer", desc = "next [m]ethod start" },
            ["]]"] = { query = "@class.outer", desc = "next class start" },
          },
          goto_next_end = {
            ["]M"] = { query = "@function.outer", desc = "next [m]ethod end" },
            ["]["] = { query = "@class.outer", desc = "next class end" },
          },
          goto_previous_start = {
            ["[m"] = { query = "@function.outer", desc = "previous [m]ethod start" },
            ["[["] = { query = "@class.outer", desc = "previous class start" },
          },
          goto_previous_end = {
            ["[M"] = { query = "@function.outer", desc = "previous [m]ethod end" },
            ["[]"] = { query = "@class.outer", desc = "previous class end" },
          },
        },
        swap = {
          enable = true,
          swap_next = {
            ["<leader>."] = { query = "@parameter.inner", desc = "swap with next parameter" },
          },
          swap_previous = {
            ["<leader>,"] = { query = "@parameter.inner", desc = "swap with previous parameter" },
          },
        },
      },
      context = {
        enable = true,
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
    keys = {
      { "<leader>ti", "<cmd>InspectTree<cr>", desc = "[T]ree [i]nspect", silent = true },
    },
  },

  {
    "windwp/nvim-ts-autotag",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
  },

  {
    "andymass/vim-matchup",
    init = function()
      vim.g.matchup_matchparen_offscreen = { method = "popup" }
    end,
  },
}
