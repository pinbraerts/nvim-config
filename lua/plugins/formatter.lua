local yandex = require("utils.yandex")

local function make_ya_style(...)
  return {
    command = "ya",
    args = { "style", "--stdin-filename", "$FILENAME", ... },
    condition = yandex.inside_arcadia,
    stdin = true,
  }
end

return {

  {
    "stevearc/conform.nvim",
    dependencies = "williamboman/mason.nvim",
    opts = {
      formatters = {
        ya_style = make_ya_style(),
        ya_style_py = make_ya_style("--py"),
        ya_style_yaml = make_ya_style("--yaml"),
        rekson = { command = "rekson" },
        query = {
          command = vim.fs.joinpath(
            vim.fn.stdpath("data"),
            "lazy/nvim-treesitter/scripts/format-queries.lua"
          ),
          args = {
            "$FILENAME",
          },
          stdin = false,
        },
        jq = {
          args = {
            "--sort-keys",
          },
        },
      },
      formatters_by_ft = {
        lua = { "stylua" },
        -- python = { "ya_style_py", lsp_format = "never" },
        rust = { "rustfmt", lsp_format = "fallback" },
        fennel = { "fnlfmt" },
        javascript = { "prettierd", "prettier", stop_after_first = true },
        markdown = { "prettierd", "prettier", stop_after_first = true },
        -- yaml = { "yamlfmt", "ya_style_yaml" },
        json = { "rekson", "jq" },
        query = { "query" },
        cpp = { "ya_style" },
        xml = { "xmlformatter" },
        html = { "prettierd", "prettier", stop_after_first = true },
        go = { "gofmt" },
        ["_"] = { "trim_whitespace" },
      },
      format_on_save = function(bufnr)
        -- Disable with a global or buffer-local variable
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end
        return { timeout_ms = 2000, lsp_format = "fallback" }
      end,
    },
    init = function()
      vim.api.nvim_create_user_command("Format", function(args)
        require("conform").format({
          async = true,
          quiet = not args.bang,
        })
      end, {
        desc = "Format current buffer",
        bang = true,
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

      vim.api.nvim_clear_autocmds({
        group = "RemoveTrailingWhitespaces",
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
