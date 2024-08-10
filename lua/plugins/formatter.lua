return {

  {
    "stevearc/conform.nvim",
    dependencies = "williamboman/mason.nvim",
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          lua = { "stylua" },
          python = { "black" },
          c = { "clangformat" },
          cpp = { "clangformat" },
          rust = { "rustfmt", lsp_format = "fallback" },
          fennel = { "fnlfmt" },
          javascript = { "prettierd", "prettier", stop_after_first = true },
        },
        format_on_save = function(bufnr)
          -- Disable with a global or buffer-local variable
          if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
            return
          end
          return { timeout_ms = 500, lsp_format = "fallback" }
        end,
      })

      vim.api.nvim_create_user_command("FormatDisable", function(args)
        if args.bang then
          vim.g.disable_autoformat = true
        else
          vim.b.disable_autoformat = true
        end
      end, {
        desc = "Disable autoformat-on-save",
        bang = true,
      })
      vim.api.nvim_create_user_command("FormatEnable", function(args)
        vim.b.disable_autoformat = false
        if args.bang then
          vim.g.disable_autoformat = false
        end
      end, {
        desc = "Re-enable autoformat-on-save",
        bang = true,
      })
    end,
  },

  {
    "zapling/mason-conform.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "stevearc/conform.nvim",
    },
  },
}
