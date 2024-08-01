return {

  {
    "stevearc/conform.nvim",
    dependencies = "williamboman/mason.nvim",
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "black" },
        c = { "clangformat" },
        cpp = { "clangformat" },
        rust = { "rustfmt", lsp_format = "fallback" },
        fennel = { "fnlfmt" },
        javascript = { "prettierd", "prettier", stop_after_first = true },
      },
      format_on_save = {
        timeout = 500,
        lsp_format = "fallback",
      },
    },
  },

  {
    "zapling/mason-conform.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "stevearc/conform.nvim",
    },
  },
}
