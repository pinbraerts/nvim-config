return {
  {
    "mhartington/formatter.nvim",
    config = function()
      require("formatter").setup({
        filetype = {
          fennel = {
            function()
              return {
                exe = "fnlfmt",
                args = { "-" },
                stdin = true,
                no_append = true,
              }
            end,
          },
          lua = { require("formatter.filetypes.lua").stylua },
          c = { require("formatter.filetypes.c").clangformat },
          cpp = { require("formatter.filetypes.cpp").clangformat },
          rust = { require("formatter.filetypes.rust").rustfmt },
          python = { require("formatter.filetypes.python").black },
          ["*"] = { require("formatter.filetypes.any").remove_trailing_whitespace },
        },
      })
      vim.api.nvim_create_autocmd("BufWritePost", {
        group = vim.api.nvim_create_augroup("__formatter__", { clear = true }),
        command = "FormatWrite",
      })
    end,
  },
}
