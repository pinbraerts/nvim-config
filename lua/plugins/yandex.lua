local yandex = require("utils.yandex")
if not yandex.has_arcadia() then
  return {}
end

return {
  {
    dir = yandex / "junk/moonw1nd/lua/telescope-arc.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      local telescope = require("telescope")
      local t = require("telescope.builtin")
      local arc = telescope.load_extension("arc")
      local options = { silent = true, nowait = true }
      vim.keymap.set("n", "<leader>gs", function()
        if yandex.inside_arcadia() then
          arc.status()
        else
          t.git_status()
        end
      end, options)
      vim.keymap.set("n", "<leader>gf", function()
        if yandex.inside_arcadia() then
          arc.ls_files()
        else
          t.git_files()
        end
      end, options)
      vim.keymap.set("n", "<leader>gc", function()
        if yandex.inside_arcadia() then
          arc.commits()
        else
          t.git_commits()
        end
      end, options)
      vim.keymap.set("n", "<leader>gb", function()
        if yandex.inside_arcadia() then
          arc.branches()
        else
          t.git_branches()
        end
      end, options)
    end,
  },

  {
    dir = yandex / "junk/pinbraerts/intelliboba.nvim",
    dependencies = {
      "hrsh7th/nvim-cmp",
    },
  },

  {
    dir = yandex / "devtools/ide/tree-sitter-yamake",
    build = ":TSInstall yamake",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
  },
}
