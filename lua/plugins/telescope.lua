local function setup()
  local t = require("telescope")

  local grep_args = nil
  if vim.fn.executable("rg") ~= 0 then
    -- use defaults
  elseif vim.fn.executable("ag") ~= 0 then
    grep_args = {
      "ag",
      "--nocolor",
      "--noheading",
      "--numbers",
      "--column",
      "--smart-case",
      "--silent",
      "--vimgrep",
    }
  elseif vim.fn.executable("grep") ~= 0 then
    grep_args = {
      "grep",
      "--extended-regexp",
      "--color=never",
      "--with-filename",
      "--line-number",
      "-b", -- grep doesn't support a `--column` option :(
      "--ignore-case",
      "--recursive",
      "--no-messages",
      "--exclude-dir=*cache*",
      "--exclude-dir=*.git",
      "--exclude=.*",
      "--binary-files=without-match",
    }
  end

  t.setup({
    defaults = {
      path_display = { "smart" },
      layout_config = {
        flex = {
          flip_columns = 140,
        },
        horizontal = {
          preview_width = { 0.5, min = 80 },
          preview_cutoff = 0,
          width = 0.9,
          height = 0.9,
        },
        vertical = {
          preview_cutoff = 0,
          preview_height = 0.5,
          width = 0.9,
          height = 0.9,
        },
      },
      layout_strategy = "flex",
      mappings = {
        i = {
          ["<c-j>"] = "move_selection_next",
          ["<c-k>"] = "move_selection_previous",
        },
        n = {
          v = "toggle_selection",
          q = "close",
          j = "move_selection_next",
          k = "move_selection_previous",
          ["<c-c>"] = "close",
          ["<c-j>"] = "move_selection_next",
          ["<c-k>"] = "move_selection_previous",
        },
      },
      vimgrep_arguments = grep_args,
    },
    pickers = {
      colorscheme = { enable_preview = true },
      builtin = { include_extensions = true },
      help_tags = {
        mappings = {
          i = {
            ["<enter>"] = "select_vertical",
          },
          n = {
            ["<c-enter>"] = "select_vertical",
          },
        },
      },
      man_pages = {
        mappings = {
          i = {
            ["<enter>"] = "select_vertical",
          },
          n = {
            ["<c-enter>"] = "select_vertical",
          },
        },
      },
      git_status = {
        initial_mode = "normal",
        mappings = {
          n = {
            s = "git_staging_toggle",
            u = "git_staging_toggle",
          },
        },
      },
      find_files = {
        no_ignore = true,
        hidden = true,
      },
    },
    extensions = {
      file_browser = {
        respect_gitignore = false,
        auto_depth = 2,
        hidden = true,
      },
    },
  })
end

local mock = require("utils.lazy_mock")
local b = mock("telescope.builtin")

return {

  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = setup,
    cmd = "Telescope",
    keys = {
      { "<leader>]", b.current_buffer_fuzzy_find(), desc = "Fuzzy find" },
      { "<leader>t/", b.search_history(), desc = "Search history" },
      { "<leader>t;", b.command_history(), desc = "Command history" },
      { "<leader>h", b.help_tags(), desc = "[h]elp tags" },
      { "<leader>mp", b.man_pages(), desc = "[m]an [p]ages" },
      { "<leader>mm", b.marks(), desc = "marks" },
      { "<leader>q", b.quickfix(), desc = "[q]uickfix" },
      { "<leader>tb", b.buffers(), desc = "[b]uffers" },
      { "<leader>tc", desc = "[c]olorscheme" },
      { "<leader>cs", b.keymaps(), desc = "[C]heat [s]heet" },
      { "<leader>tl", b.jumplist(), desc = "Jump[l]is[t]" },
      { "<leader>to", b.vim_options(), desc = "[o]ptions" },
      { "<leader>tp", b.pickers(), desc = "[p]ickers" },
      { "<leader>tq", b.quickfixhistory(), desc = "[q]uckfix history" },
      { "<leader>t=", b.registers(), desc = "Registers" },
      { "<leader>tj", b.pickers(), desc = "builtin pickers" },
      { "<leader>tr", b.resume(), desc = "Reopen last picker [T]elescope [r]esume" },
      { "<leader>fd", b.find_files(), desc = "Find files (with [fd]-find)" },
      { "<leader>gf", b.git_files(), desc = "[G]it [f]iles" },
      { "<leader>rg", b.live_grep(), desc = "Live grep (with [r]ip [g]rep)" },
      { "<leader>gw", b.grep_string(), desc = "[G]rep [w]ord" },
      { "<leader>rf", b.oldfiles(), desc = "[R]ecent [f]iles" },
      { "<leader>ld", b.current_buffer_tags(), desc = "[L]SP buffer [t]ags" },
      { "<leader>lf", b.tags(), desc = "[L]SP [f]ull tags" },
      { "<leader>li", b.lsp_incoming_calls(), desc = "[L]SP [i]ncoming calls" },
      { "<leader>lo", b.lsp_outgoing_calls(), desc = "[L]SP [o]outgoing calls" },
      { "<leader>ls", b.tagstack(), desc = "[L]SP tag[s]tack" },
      { "<leader>lt", b.lsp_type_definitions(), desc = "[L]SP [t]ype definitions" },
      { "<leader>gb", b.git_branches(), desc = "[g]it [b]ranches" },
      { "<leader>gc", b.git_commits(), desc = "[g]it [c]ommits" },
      { "<leader>gC", b.git_bcommits(), desc = "[g]it [C]ommits of the buffer" },
      { "<leader>gh", b.git_stash(), desc = "[G]it stas[h]" },
      { "<leader>gl", b.git_commits(), desc = "[G]it [l]og commits" },
      { "<leader>gs", b.git_status(), desc = "[G]it [s]tatus" },
      {
        "<leader>rG",
        b.live_grep({ additional_args = { "-u" } }),
        desc = "Live grea (with [r]ip [g]rep, all files)",
      },
      {
        "<leader>gW",
        b.grep_string({ additional_args = { "-u" } }),
        desc = "[G]rep [w]ord (all files)",
      },
      {
        "<leader>tc",
        function()
          for _, colorscheme in ipairs(require("plugins.colorscheme")) do
            local name = colorscheme.name
            if name == nil then
              local index = colorscheme[1]:find("/")
              name = colorscheme[1]:sub(index + 1)
            end
            if name then
              vim.cmd("Lazy load " .. name)
            end
          end
          require("telescope.builtin").colorscheme()
        end,
        desc = "pick [c]olorscheme",
      },
    },
  },

  {
    "nvim-telescope/telescope-ui-select.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    lazy = true,
    init = function()
      vim.ui.select = function(items, opts, on_choice)
        require("telescope").load_extension("ui-select")
        vim.ui.select(items, opts, on_choice)
      end
    end,
  },

  {
    "nvim-telescope/telescope-file-browser.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("telescope").load_extension("file_browser")
    end,
    keys = { "<leader>fb", "<cmd>Telescope file_browser<cr>", desc = "[F]ile [b]rowser" },
    cond = function()
      return vim.fn.executable("yazi") == 0
    end,
  },

  {
    "nvim-telescope/telescope-symbols.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    keys = { "<leader>ts", mock("telescope.builtin").symbols(), desc = "unicode symbols picker" },
  },
}
