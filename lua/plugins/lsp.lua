local ft = require("filetypes")

local function setup ()
	local capabilities = vim.lsp.protocol.make_client_capabilities()
	local cmp_capabilities = require('cmp_nvim_lsp').default_capabilities()
	capabilities = vim.tbl_extend('force', capabilities, cmp_capabilities)
	local lspconfig = require('lspconfig')

	local servers = {

		pylsp = {
			settings = {
				pylsp = {
					configurationSources = { "pycodestyle" },
					plugins = {
						mccabe = { enabled = false },
						pycodestyle = {
							enabled = true,
							ignore = { "E501" },
						},
						pyflakes = { enabled = true },
						flake8 = { enabled = false },
						rope_autoimport = {
							completions = { enabled = true },
							code_actions = { enabled = true },
							enabled = true,
							memory = true,
						},
					},
				},
			},
		},

		lua_ls = {
			settings = {
				Lua = {
					completion = {
						callSnippet = 'Replace',
					},
					runtime = {
						version = 'LuaJIT',
					},
					diagnostics = {
						globals = {'vim'},
					},
					workspace = {
						library = vim.api.nvim_get_runtime_file("", true),
						checkThirdParty = false,
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
							'-X',
							'compile',
							'%f',
							'--synctex',
							'--keep-logs',
							'--keep-intermediates',
						},
						forwardSearchAfter = true,
						onSave = true,
					},
					forwardSearch = {
						onSave = true,
						executable = 'zathura',
						args = {
							'--synctex-forward',
							'%l:1:%f',
							'%p',
						},
					},
				},
			},
		},

	}

	require('mason-lspconfig').setup {
		ensure_installed = {
			"clangd", "pylsp", vim.fn.has("win32") ~= 0 and "powershell_es" or "bashls",
		},
		automatic_installation = true,
		handlers = {
			function (server_name)
				local server = servers[server_name] or {}
				server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
				server.single_file_support = true
				lspconfig[server_name].setup(server)
			end,
			rust_analyzer = function() end,
		},
	}

	local t = require 'telescope.builtin'
	vim.api.nvim_create_autocmd('LspAttach', {
		group = vim.api.nvim_create_augroup('lsp-config-attach', { clear = true }),
		callback = function (event)
			local client = vim.lsp.get_client_by_id(event.data.client_id)
			if client == nil then
				return
			end
			local server_capabilities = client.server_capabilities
			if server_capabilities == nil then
				return
			end
			local buffer = event.buf
			vim.opt_local.signcolumn = 'yes'
			if server_capabilities.completionProvider then
				vim.bo[buffer].omnifunc = "v:lua.vim.lsp.omnifunc"
			end
			if server_capabilities.definitionProvider then
				vim.bo[buffer].tagfunc = "v:lua.vim.lsp.tagfunc"
				vim.keymap.set('n', '<c-]>', vim.lsp.buf.definition, { buffer = buffer, desc = 'LSP go to definition' })
			end
			if server_capabilities.declarationProvider then
				-- vim.keymap.set('n', '<c-[>', vim.lsp.buf.declaration, { buffer = buffer, desc = 'LSP go to declaration' })
				vim.keymap.set('n', '<leader>l[', t.lsp_definitions, { buffer = buffer, desc = '[L]SP list declarations' })
			end
			if server_capabilities.implementationProvider then
				vim.keymap.set('n', '<c-p>', vim.lsp.buf.implementation, { buffer = buffer, desc = 'LSP go to implementation' })
			end
			if server_capabilities.documentSymbolProvider then
				vim.keymap.set('n', '<leader>ld', t.lsp_document_symbols, { buffer = buffer, desc = '[L]SP document symbols' })
			end
			if server_capabilities.workspaceSymbolProvider then
				vim.keymap.set('n', '<leader>ls', t.lsp_workspace_symbols, { desc = '[L]SP workspace symbols' })
				vim.keymap.set('n', '<leader>lf', t.lsp_dynamic_workspace_symbols, { desc = '[L]SP dynamic workspace symbols' })
			end
			if server_capabilities.referencesProvider then
				vim.keymap.set('n', '<leader>]', t.lsp_references, { buffer = buffer, desc = '[L]SP references' })
			end
			if server_capabilities.codeActionProvider then
				vim.keymap.set('n', '<leader>ll', function ()
					vim.lsp.buf.code_action {
						filter = function(action) return action.isPreferred end,
						apply = true,
					}
					end, { buffer = buffer, desc = 'LSP apply code action' })
			end
			if server_capabilities.formattingProvider then
				vim.bo[buffer].formatexpr = "v:lua.vim.lsp.formatexpr()"
				vim.keymap.set({ 'n', 'v' }, '=', 'gq', { remap = true, buffer = buffer, desc = 'LSP formatting' })
			end
		end,
	})

	vim.g.rustaceanvim = {
		dap = {
			autoload_configurations = true,
		},
		server = {
			cmd = "rust-analyzer",
		},
	}

	vim.keymap.set('n', '<leader>lr', vim.lsp.buf.rename, { desc = '[L]SP rename' })
	vim.keymap.set('n', '<leader>la', vim.lsp.buf.code_action, { desc = '[L]SP code [a]ction' })

end

return {

	{
		'neovim/nvim-lspconfig',
		dependencies = {
			'williamboman/mason-lspconfig.nvim',
			{ 'j-hui/fidget.nvim', opts = {} },
			{ 'folke/neodev.nvim', opts = {} },
			'nvim-telescope/telescope.nvim',
		},
		ft = ft.lsp,
		config = setup,
		keys = {
			{ 'gh', '<cmd>ClangdSwitchSourceHeader<cr>', desc = '[G]o to header', silent = true, },
		},
	},

	{
		'mrcjkb/rustaceanvim',
		version = '^4',
		ft = { 'rust' },
		dependencies = { 'neovim/nvim-lspconfig' },
	},

}
