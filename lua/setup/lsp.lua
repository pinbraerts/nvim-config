local cmp_capabilities = require('cmp_nvim_lsp').default_capabilities()
local lspconfig = require('lspconfig')
lspconfig.lua_ls.setup {
	settings = {
		Lua = {
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
	single_file_support = true,
	capabilities = cmp_capabilities,
}
lspconfig.pylsp.setup {
	capabilities = cmp_capabilities,
}
lspconfig.clangd.setup {
	capabilities = cmp_capabilities,
}
lspconfig.powershell_es.setup {
	capabilities = cmp_capabilities,
	single_file_support = true,
	bundle_path = 'D:/PowerShellEditorServices',
}
lspconfig.bashls.setup { }
lspconfig.texlab.setup {
	settings = {
		texlab = {
			build = {
				executable = 'tectonic',
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
}

lspconfig.gopls.setup {
}

local t = require 'telescope.builtin'
vim.api.nvim_create_autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('lsp', { clear = true }),
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		local capabilities = client.server_capabilities
		vim.opt_local.signcolumn = 'yes'
		if capabilities.completionProvider then
			vim.bo[args.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
		end
		if capabilities.definitionProvider then
			vim.bo[args.buf].tagfunc = "v:lua.vim.lsp.tagfunc"
			vim.keymap.set('n', '<c-]>', vim.lsp.buf.definition, { buffer = args.buf, desc = 'LSP go to definition' })
		end
		if capabilities.declarationProvider then
			-- vim.keymap.set('n', '<c-[>', vim.lsp.buf.declaration, { buffer = args.buf, desc = 'LSP go to declaration' })
			vim.keymap.set('n', '<leader>l[', t.lsp_definitions, { buffer = args.buf, desc = '[L]SP list declarations' })
		end
		if capabilities.implementationProvider then
			vim.keymap.set('n', '<c-p>', vim.lsp.buf.implementation, { buffer = args.buf, desc = 'LSP go to implementation' })
		end
		if capabilities.documentSymbolProvider then
			vim.keymap.set('n', '<leader>ld', t.lsp_document_symbols, { buffer = args.buf, desc = '[L]SP document symbols' })
		end
		if capabilities.workspaceSymbolProvider then
			vim.keymap.set('n', '<leader>ls', t.lsp_workspace_symbols, { desc = '[L]SP workspace symbols' })
			vim.keymap.set('n', '<leader>lf', t.lsp_dynamic_workspace_symbols, { desc = '[L]SP dynamic workspace symbols' })
		end
		if capabilities.referencesProvider then
			vim.keymap.set('n', '<leader>]', t.lsp_references, { buffer = args.buf, desc = '[L]SP references' })
		end
		if capabilities.codeActionProvider then
			vim.keymap.set('n', '<leader>ll', function ()
				vim.lsp.buf.code_action {
					filter = function(action) return action.isPreferred end,
					apply = true,
				}
			end, { buffer = args.buf, desc = 'LSP apply code action' })
		end
		if capabilities.hoverProvider and not vim.fn.has('dap') then
			vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = args.buf, desc = 'LSP hover' })
		end
		if capabilities.formattingProvider then
			vim.bo[args.buf].formatexpr = "v:lua.vim.lsp.formatexpr()"
			vim.keymap.set({ 'n', 'v' }, '=', 'gq', { remap = true, buffer = args.buf, desc = 'LSP formatting' })
		end
	end,
})
vim.keymap.set('n', '<leader>lr', vim.lsp.buf.rename, { desc = '[L]SP rename' })
vim.keymap.set('n', '<leader>la', vim.lsp.buf.code_action, { desc = '[L]SP code [a]ction' })
