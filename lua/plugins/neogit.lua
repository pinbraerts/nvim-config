return {

  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "sindrets/diffview.nvim",
        cmd = {
          "DiffviewOpen",
          "DiffviewFileHistory",
          "DiffviewClose",
          "DiffviewToggleFiles",
          "DiffviewFocusFiles",
          "DiffviewRefresh",
          "DiffviewLog",
        },
      },
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      local neogit = require("neogit")
      neogit.setup({})
      vim.keymap.set("n", "\\gc", function()
        neogit.open({ "commit" })
      end, { desc = "[G]it [c]ommit" })
      vim.keymap.set(
        "n",
        "\\gf",
        neogit.action("fetch", "fetch_upstream"),
        { desc = "[G]it [f]etch" }
      )
      vim.keymap.set(
        "n",
        "\\gF",
        neogit.action("fetch", "fetch_all_remotes", { "--all", "--prune" }),
        { desc = "[G]it [F]etch all and prune" }
      )
      vim.keymap.set("n", "\\gp", neogit.action("push", "to_upstream"), { desc = "[G]it [P]ush" })
      vim.keymap.set(
        "n",
        "\\gP",
        neogit.action("push", "to_upstream", { "--force-with-lease" }),
        { desc = "[G]it [P]ush force with lease" }
      )
      -- vim.keymap.set('n', '\\gu', neogit.action('submodule', 'update', { 'update' }), { desc = '[G]it [u]pdate submodules', })
      -- vim.keymap.set('n', '\\gU', neogit.action('submodule', 'update', { 'update', '--init', '--recursive' }), { desc = '[G]it [U]pdate submodules recursive init', })
      vim.keymap.set("n", "\\gl", neogit.action("pull", "from_upstream"), { desc = "[G]it pu[l]l" })
      vim.keymap.set(
        "n",
        "\\gL",
        neogit.action(
          "pull",
          "from_upstream",
          { "--no-rebase", { desc = "[G]it pu[l]l no rebase" } }
        )
      )
    end,
    cmd = { "Neogit" },
    keys = {
      { "\\gc", desc = "[G]it [c]ommit" },
      { "\\gf", desc = "[G]it [f]etch" },
      { "\\gF", desc = "[G]it [F]etch all and prune" },
      { "\\gp", desc = "[G]it [p]ush" },
      { "\\gP", desc = "[G]it [P]ush force with lease" },
      -- { '\\gu', desc = '[G]it [u]pdate submodules' },
      -- { '\\gU', desc = '[G]it [U]pdate submodules recursive init' },
      { "\\gl", desc = "[G]it pu[l]l" },
      { "\\gL", desc = "[G]it pu[l]l no rebase" },
    },
  },
}
