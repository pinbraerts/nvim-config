local yandex = require("utils.yandex")

local function make_tt_format(...)
  return {
    command = "ya",
    args = { "tool", "tt", "format", "-", "--stdin-filename", "$FILENAME", "--formatters", ... },
    condition = yandex.inside_arcadia,
    tmpfile_format = "/tmp/conform/$RANDOM.$FILENAME",
  }
end

return {

  {
    "stevearc/conform.nvim",
    dependencies = "williamboman/mason.nvim",
    opts = {
      formatters = {
        tt_format_python = make_tt_format("initfmt", "ruff"),
        tt_format_yaml = make_tt_format("yamlfmt"),
        tt_format_json = make_tt_format("jsonfmt"),
        tt_format_cpp = make_tt_format("clang-format"),
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
        python = { "tt_format_python", lsp_format = "never" },
        rust = { "rustfmt", lsp_format = "fallback" },
        fennel = { "fnlfmt" },
        javascript = { "prettierd", "prettier", stop_after_first = true },
        markdown = { "prettierd", "prettier", stop_after_first = true },
        yaml = { "yamlfmt", "tt_format_yaml" },
        json = { "rekson", "jq" },
        query = { "query" },
        cpp = { "tt_format_cpp" },
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
        return { timeout_ms = 500, lsp_format = "fallback" }
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
