local function setup()
  local t = require("telescope")
  local a = require("telescope.actions")

  local next = {
    a.move_selection_next,
    type = "action",
    opts = { nowait = true, silent = true },
  }
  local previous = {
    a.move_selection_previous,
    type = "action",
    opts = { nowait = true, silent = true },
  }

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
          ["<c-j>"] = next,
          ["<c-k>"] = previous,
          ["<c-l>"] = "select_vertical",
          ["<c-v>"] = "select_vertical",
          ["<c-h>"] = "select_horizontal",
        },
        n = {
          v = "toggle_selection",
          l = "select_vertical",
          h = "select_horizontal",
          q = "close",
          ["<c-c>"] = "close",
          ["<c-j>"] = next,
          ["<c-k>"] = previous,
        },
      },
      vimgrep_arguments = grep_args,
    },
    pickers = {
      pickers = {
        mappings = {
          i = {
            ["<c-l>"] = "select_default",
          },
          n = {
            l = "select_default",
          },
        },
      },
      colorscheme = {
        enable_preview = true,
      },
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

  local b = require("telescope.builtin")
  vim.keymap.set("n", "<leader>]", b.current_buffer_fuzzy_find, { desc = "Fuzzy find" })
  vim.keymap.set("n", "<leader>t/", b.search_history, { desc = "Search history" })
  vim.keymap.set("n", "<leader>t;", b.command_history, { desc = "Command history" })
  vim.keymap.set("n", "<leader>h", b.help_tags, { desc = "[H]elp tags" })
  vim.keymap.set("n", "<leader>mp", b.man_pages, { desc = "[M]an [p]ages" })
  vim.keymap.set("n", "<leader>mm", b.marks, { desc = "Marks" })
  vim.keymap.set("n", "<leader>q", b.quickfix, { desc = "[Q]uickfix" })
  vim.keymap.set("n", "<leader>tb", b.buffers, { desc = "[B]uffers" })
  vim.keymap.set("n", "<leader>tc", function()
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
    b.colorscheme()
  end, { desc = "[c]olorscheme" })
  -- vim.keymap.set('n', '<leader>te', b.diagnostics, { desc = '[e]rrors' })
  vim.keymap.set("n", "<leader>ch", b.keymaps, { desc = "[C]heat [s]heet" })
  vim.keymap.set("n", "<leader>tl", b.jumplist, { desc = "Jump[l]is[t]" })
  vim.keymap.set("n", "<leader>to", b.vim_options, { desc = "[O]ptions" })
  vim.keymap.set("n", "<leader>tp", b.pickers, { desc = "[P]ickers" })
  vim.keymap.set("n", "<leader>tq", b.quickfixhistory, { desc = "[Q]uckfix history" })
  vim.keymap.set("n", "<leader>t=", b.registers, { desc = "Registers" })
  vim.keymap.set("n", "<leader>tj", b.builtin, { desc = "Builtin pickers" })
  vim.keymap.set("n", "<leader>tr", b.resume, { desc = "Reopen last picker [T]elescope [r]esume" })

  vim.keymap.set("n", "<leader>fd", b.find_files, { desc = "Find files (with [fd])" })
  vim.keymap.set("n", "<leader>gf", b.git_files, { desc = "[G]it [f]iles" })
  vim.keymap.set("n", "<leader>rg", b.live_grep, { desc = "Live grep (with [rg])" })
  vim.keymap.set("n", "<leader>rG", function()
    b.live_grep({
      additional_args = { "-u" },
    })
  end, { desc = "Live grep (with [rg], all files)" })
  vim.keymap.set("n", "<leader>gw", b.grep_string, { desc = "[G]rep [w]ord" })
  vim.keymap.set("n", "<leader>gW", function()
    b.grep_string({
      additional_args = { "-u" },
    })
  end, { desc = "[G]rep [w]ord (all files)" })
  vim.keymap.set("n", "<leader>rf", b.oldfiles, { desc = "[R]ecent [f]iles" })

  vim.keymap.set("n", "<leader>ld", b.current_buffer_tags, { desc = "[L]SP buffer [t]ags" })
  vim.keymap.set("n", "<leader>lf", b.tags, { desc = "[L]SP [f]ull tags" })
  vim.keymap.set("n", "<leader>li", b.lsp_incoming_calls, { desc = "[L]SP [i]ncoming calls" })
  vim.keymap.set("n", "<leader>lo", b.lsp_outgoing_calls, { desc = "[L]SP [o]outgoing calls" })
  vim.keymap.set("n", "<leader>ls", b.tagstack, { desc = "[L]SP tag[s]tack" })
  vim.keymap.set("n", "<leader>lt", b.lsp_type_definitions, { desc = "[L]SP [t]ype definitions" })

  vim.keymap.set("n", "<leader>gb", b.git_branches, { desc = "[G]it [b]ranches" })
  vim.keymap.set("n", "<leader>gc", b.git_commits, { desc = "[G]it [c]ommits" })
  vim.keymap.set("n", "<leader>gC", b.git_bcommits, { desc = "[G]it [C]ommits of the buffer" })
  vim.keymap.set("n", "<leader>gh", b.git_stash, { desc = "[G]it stas[h]" })
  vim.keymap.set("n", "<leader>gl", b.git_commits, { desc = "[G]it [l]og commits" })
  vim.keymap.set("n", "<leader>gs", b.git_status, { desc = "[G]it [s]tatus" })
end

return {

  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = setup,
    cmd = "Telescope",
    keys = {
      { "<leader>]", desc = "Fuzzy find" },
      { "<leader>t/", desc = "Search history" },
      { "<leader>t;", desc = "Command history" },
      { "<leader>h", desc = "[h]elp tags" },
      { "<leader>mp", desc = "[m]an [p]ages" },
      { "<leader>mm", desc = "marks" },
      { "<leader>q", desc = "[q]uickfix" },
      { "<leader>tb", desc = "[b]uffers" },
      { "<leader>tc", desc = "[c]olorscheme" },
      { "<leader>ch", desc = "[C]heat [s]heet" },
      { "<leader>tl", desc = "Jump[l]is[t]" },
      { "<leader>to", desc = "[o]ptions" },
      { "<leader>tp", desc = "[p]ickers" },
      { "<leader>tq", desc = "[q]uckfix history" },
      { "<leader>t=", desc = "Registers" },
      { "<leader>tj", desc = "builtin pickers" },
      { "<leader>tr", desc = "Reopen last picker [T]elescope [r]esume" },
      { "<leader>fd", desc = "Find files (with [fd])" },
      { "<leader>gf", desc = "[G]it [f]iles" },
      { "<leader>rg", desc = "Live grep (with [rg])" },
      { "<leader>rG", desc = "Live grea (with [rg], all files)" },
      { "<leader>gw", desc = "[G]rep [w]ord" },
      { "<leader>gW", desc = "[G]rep [w]ord (all files)" },
      { "<leader>rf", desc = "[R]ecent [f]iles" },
      { "<leader>ld", desc = "[L]SP buffer [t]ags" },
      { "<leader>lf", desc = "[L]SP [f]ull tags" },
      { "<leader>li", desc = "[L]SP [i]ncoming calls" },
      { "<leader>lo", desc = "[L]SP [o]outgoing calls" },
      { "<leader>ls", desc = "[L]SP tag[s]tack" },
      { "<leader>lt", desc = "[L]SP [t]ype definitions" },
      { "<leader>gb", desc = "[g]it [b]ranches" },
      { "<leader>gc", desc = "[g]it [c]ommits" },
      { "<leader>gC", desc = "[g]it [C]ommits of the buffer" },
      { "<leader>gh", desc = "[G]it stas[h]" },
      { "<leader>gl", desc = "[G]it [l]og commits" },
      { "<leader>gs", desc = "[G]it [s]tatus" },
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
      local tf = require("telescope").load_extension("file_browser")
      vim.keymap.set("n", "<leader>fb", tf.file_browser, { desc = "[F]ile [b]rowser" })
    end,
    keys = { "<leader>fb", desc = "[F]ile [b]rowser" },
  },

  {
    "nvim-telescope/telescope-symbols.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      local t = require("telescope.builtin")
      vim.keymap.set("n", "<leader>ts", t.symbols, { desc = "unicode symbols picker" })
    end,
    keys = { "<leader>ts", desc = "unicode symbols picker" },
  },
}
