return {

  {
    "williamboman/mason.nvim",
    lazy = false,
    opts = {
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "⬇️",
          package_uninstalled = "✗",
        },
      },
    },
    keys = {
      { "<leader>ms", "<cmd>Mason<cr>", desc = "Open [M]a[s]on", silent = true },
    },
  },

  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = {
      ensure_installed = {
        "codelldb",
        vim.fn.executable("cargo") ~= 0 and "stylua" or nil,
      },
    },
  },
}
