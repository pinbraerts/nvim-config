local function setup()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  local cmp_capabilities = require("cmp_nvim_lsp").default_capabilities()
  capabilities = vim.tbl_extend("force", capabilities, cmp_capabilities)
  local lspconfig = require("lspconfig")
  local schemas = require("schemastore")

  local servers = {
    clangd = {
      cmd = { "clangd", "--header-insertion=never" },
    },

    jsonls = {
      settings = {
        json = {
          schemas = schemas.json.schemas(),
          validate = { enable = true },
        },
      },
    },

    yamlls = {
      settings = {
        yaml = {
          hover = true,
          completion = true,
          validate = true,
          schemaStore = {
            enable = false,
            url = "",
          },
          schemas = schemas.yaml.schemas(),
        },
      },
    },

    pylsp = {
      settings = {
        pylsp = {
          configurationSources = { "pycodestyle" },
          plugins = {
            mccabe = { enabled = false },
            pyflakes = { enabled = false },
            flake8 = { enabled = false },
            rope_autoimport = { enabled = false },
          },
        },
      },
    },

    lua_ls = {
      settings = {
        Lua = {
          completion = {
            callSnippet = "Replace",
          },
          runtime = {
            version = "LuaJIT",
          },
          diagnostics = {
            globals = { "vim" },
          },
          workspace = {
            library = vim.api.nvim_get_runtime_file("", true),
            checkThirdParty = false,
          },
          library = {
            [vim.fn.expand("$VIMRUNTIME/lua")] = true,
            [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
            [vim.fn.stdpath("config") .. "/lua"] = true,
          },
          telemetry = { enable = false },
        },
      },
    },

    texlab = {
      settings = {
        texlab = {
          build = {
            executable = "tectonic",
            args = {
              "-X",
              "compile",
              "%f",
              "--synctex",
              "--keep-logs",
              "--keep-intermediates",
            },
            forwardSearchAfter = true,
            onSave = true,
          },
          forwardSearch = {
            onSave = true,
            executable = "zathura",
            args = {
              "--synctex-forward",
              "%l:1:%f",
              "%p",
            },
          },
        },
      },
    },
  }

  local function setup_server(name)
    local server = servers[name] or {}
    server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
    server.single_file_support = true
    lspconfig[name].setup(server)
  end

  require("mason-lspconfig").setup({
    handlers = {
      setup_server,
      rust_analyzer = function() end,
    },
  })

  local configured_servers = require("lspconfig.util").available_servers()
  for name, _ in pairs(servers) do
    if not vim.tbl_contains(configured_servers, name) and vim.fn.executable(name) ~= 0 then
      setup_server(name)
    end
  end

  local t = require("telescope.builtin")
  local group = vim.api.nvim_create_augroup("lsp-config-attach", { clear = true })
  vim.api.nvim_create_autocmd("LspAttach", {
    group = group,
    callback = function(event)
      local client = vim.lsp.get_client_by_id(event.data.client_id)
      if client == nil then
        return
      end
      local server_capabilities = client.server_capabilities
      if server_capabilities == nil then
        return
      end
      local buffer = event.buf
      vim.opt_local.signcolumn = "yes"
      if server_capabilities.completionProvider then
        vim.bo[buffer].omnifunc = "v:lua.vim.lsp.omnifunc"
      end
      if server_capabilities.definitionProvider then
        vim.bo[buffer].tagfunc = "v:lua.vim.lsp.tagfunc"
        vim.keymap.set(
          "n",
          "<c-]>",
          vim.lsp.buf.definition,
          { buffer = buffer, desc = "LSP go to definition" }
        )
      end
      if server_capabilities.declarationProvider then
        -- vim.keymap.set('n', '<c-[>', vim.lsp.buf.declaration, { buffer = buffer, desc = 'LSP go to declaration' })
        vim.keymap.set(
          "n",
          "<leader>l[",
          t.lsp_definitions,
          { buffer = buffer, desc = "[L]SP list declarations" }
        )
      end
      if server_capabilities.implementationProvider then
        vim.keymap.set(
          "n",
          "<c-p>",
          vim.lsp.buf.implementation,
          { buffer = buffer, desc = "LSP go to implementation" }
        )
      end
      if server_capabilities.documentSymbolProvider then
        vim.keymap.set(
          "n",
          "<leader>ld",
          t.lsp_document_symbols,
          { buffer = buffer, desc = "[L]SP document symbols" }
        )
      end
      if server_capabilities.workspaceSymbolProvider then
        vim.keymap.set(
          "n",
          "<leader>ls",
          t.lsp_workspace_symbols,
          { desc = "[L]SP workspace symbols" }
        )
        vim.keymap.set(
          "n",
          "<leader>lf",
          t.lsp_dynamic_workspace_symbols,
          { desc = "[L]SP dynamic workspace symbols" }
        )
      end
      if server_capabilities.referencesProvider then
        vim.keymap.set(
          "n",
          "<leader>]",
          t.lsp_references,
          { buffer = buffer, desc = "[L]SP references" }
        )
      end
      if server_capabilities.codeActionProvider then
        vim.keymap.set("n", "<leader>ll", function()
          vim.lsp.buf.code_action({
            filter = function(action)
              return action.isPreferred
            end,
            apply = true,
          })
        end, { buffer = buffer, desc = "LSP apply code action" })
      end
      require("lsp-inlayhints").on_attach(client, buffer)
    end,
  })
end

vim.g.rustaceanvim = {
  dap = {
    autoload_configurations = true,
  },
  inlay_hints = {
    highlight = "NonText",
  },
}

return {

  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "b0o/schemastore.nvim",
      { "j-hui/fidget.nvim", opts = {} },
      "nvim-telescope/telescope.nvim",
      { "lvimuser/lsp-inlayhints.nvim", opts = {} },
    },
    lazy = false,
    config = setup,
    keys = {
      {
        "gh",
        "<cmd>ClangdSwitchSourceHeader<cr>",
        desc = "[G]o to header",
        silent = true,
      },
      {
        "<leader>lr",
        vim.lsp.buf.rename,
        desc = "[L]SP rename",
      },
      {
        "<leader>la",
        vim.lsp.buf.code_action,
        desc = "[L]SP code [a]ction",
      },
    },
  },

  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "luvit-meta/library", words = { "vim%.uv" } },
        "lazy.nvim",
        { path = "LazyVim", words = { "LazyVim" } },
        { path = "wezterm-types", words = { "wezterm" } },
        { path = "xmake-luals-addon/library", files = { "xmake.lua" } },
        { path = "busted/library", words = { "describe" } },
        { path = "luassert/library", words = { "assert" } },
      },
    },
  },

  { "Bilal2453/luvit-meta", lazy = true },
  { "justinsgithub/wezterm-types", lazy = true },
  { "LuaCATS/luassert", lazy = true },
  { "LuaCATS/busted", lazy = true },

  {
    "mrcjkb/rustaceanvim",
    version = "^4",
    ft = { "rust" },
    lazy = false,
  },

  {
    "p00f/clangd_extensions.nvim",
    opts = {
      memory_usage = {
        border = "none",
      },
      symbol_info = {
        border = "none",
      },
    },
    ft = { "cpp", "c" },
  },
}
