local luasnip = require('luasnip')
local cmp = require('cmp')
local lspkind = require('lspkind')

local snip_next = cmp.mapping(function  (fallback)
	if cmp.visible() then
		cmp.select_next_item()
	elseif luasnip.expand_or_jumpable() then
		luasnip.expand_or_jump()
	else
		fallback()
	end
end)

local snip_prev = cmp.mapping(function (fallback)
	if cmp.visible() then
		cmp.select_prev_item()
	elseif luasnip.jumpable(-1) then
		luasnip.jump(-1)
	else
		fallback()
	end
end)

cmp.setup {
	formatting = {
		format = lspkind.cmp_format({
			mode = 'symbol',
			maxwidth = 50,
			ellipsis_char = '...',
			symbol_map = {
				Copilot = '',
				Tabby = '',
			},
		})
	},
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	sources = cmp.config.sources({
		{ name = 'nvim_lsp' },
		{ name = 'nvim_lsp_signature_help' },
		{ name = 'luasnip' },
		{ name = 'path' },
		{ name = 'cmp_tabby', priority = 9999, },
	}, {
		{ name = 'buffer' },
	}),
	mapping = cmp.mapping.preset.insert {
		['<c-u>'] = cmp.mapping.scroll_docs(-4),
		['<c-d>'] = cmp.mapping.scroll_docs(4),
		['<c-n>'] = snip_next,
		['<c-p>'] = snip_prev,
		['<tab>'] = snip_next,
		['<s-tab>'] = snip_prev,
		['<c-j>'] = snip_next,
		['<c-k>'] = snip_prev,
		['<c-space>'] = cmp.mapping.complete(),
		['<c-y>'] = cmp.mapping.confirm {
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		},
		['<cr>'] = cmp.mapping.confirm {
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		},
	},
	experimental = {
		ghost_text = true,
	},
}

cmp.setup.filetype('gitcommit', {
	sources = cmp.config.sources(
		{ { name = 'git' }, },
		{ { name = 'buffer' }, }
	),
})

cmp.setup.cmdline({ '/', '?' }, {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = 'buffer' },
	},
})

cmp.setup.cmdline(':', {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources(
		{ { name = 'path' }, },
		{ { name = 'cmdline' }, }
	),
	matching = { disallow_symbol_nonprefix_matching = false },
})
