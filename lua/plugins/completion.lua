local function setup()
  local luasnip = require("luasnip")
  local cmp = require("cmp")
  local lspkind = require("lspkind")

  local snip_next = cmp.mapping(function(fallback)
    if cmp.visible() then
      cmp.select_next_item()
    elseif luasnip.expand_or_locally_jumpable() then
      luasnip.expand_or_jump()
    else
      fallback()
    end
  end)

  local snip_prev = cmp.mapping(function(fallback)
    if cmp.visible() then
      cmp.select_prev_item()
    elseif luasnip.locally_jumpable(-1) then
      luasnip.jump(-1)
    else
      fallback()
    end
  end)

  cmp.setup({
    formatting = {
      format = lspkind.cmp_format({
        mode = "symbol",
        maxwidth = 50,
        ellipsis_char = "...",
        symbol_map = {
          Copilot = "",
          Tabby = "",
        },
      }),
    },
    sorting = {
      comparators = {
        cmp.config.compare.offset,
        cmp.config.compare.exact,
        cmp.config.compare.recently_used,
        cmp.config.compare.kind,
        cmp.config.compare.sort_text,
        cmp.config.compare.length,
        cmp.config.compare.order,
      },
    },
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },
    sources = cmp.config.sources({
      { name = "nvim_lsp" },
      { name = "nvim_lsp_signature_help" },
      { name = "luasnip" },
      { name = "path" },
      { name = "cmp_tabby", priority = 9999 },
    }, {
      { name = "buffer" },
    }),
    mapping = cmp.mapping.preset.insert({
      ["<c-u>"] = cmp.mapping.scroll_docs(-4),
      ["<c-d>"] = cmp.mapping.scroll_docs(4),
      ["<c-n>"] = snip_next,
      ["<c-p>"] = snip_prev,
      ["<tab>"] = snip_next,
      ["<s-tab>"] = snip_prev,
      ["<c-space>"] = cmp.mapping.complete(),
      ["<c-y>"] = cmp.mapping.confirm({
        behavior = cmp.ConfirmBehavior.Replace,
        select = true,
      }),
      ["<cr>"] = cmp.mapping.confirm({
        behavior = cmp.ConfirmBehavior.Replace,
        select = true,
      }),
    }),
    experimental = {
      ghost_text = true,
    },
  })

  cmp.setup.filetype("gitcommit", {
    sources = cmp.config.sources({ { name = "git" } }, { { name = "buffer" } }),
  })

  cmp.setup.cmdline({ "/", "?" }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = "buffer" },
    },
  })

  cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }),
    matching = { disallow_symbol_nonprefix_matching = false },
  })

  vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#6CC644" })
  vim.api.nvim_set_hl(0, "CmpItemKindTabby", { fg = "#FFFF00" })
end

return {

  {
    "hrsh7th/nvim-cmp",
    event = { "CmdLineEnter", "InsertEnter" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lsp-signature-help",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "petertriho/cmp-git",
      {
        "L3MON4D3/LuaSnip",
        build = "make install_jsregexp",
      },
      "saadparwaiz1/cmp_luasnip",
      "onsails/lspkind.nvim",
      {
        "rafamadriz/friendly-snippets",
        config = function()
          require("luasnip.loaders.from_vscode").lazy_load()
        end,
      },
      {
        "pinbraerts/cmp-tabby",
        enabled = false, -- breaks on load
        config = function()
          local tabby = require("cmp_tabby.config")
          tabby:setup({
            host = "http://192.168.10.112:5345",
            max_lines = 1024,
          })
        end,
      },
    },
    config = setup,
  },
}
