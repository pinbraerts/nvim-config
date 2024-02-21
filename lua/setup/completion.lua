local luasnip = require('luasnip')
local cmp = require('cmp')

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
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	sources = {
		{ name = 'nvim_lsp' },
		{ name = 'nvim_lsp_signature_help' },
		{ name = 'luasnip' },
		{ name = 'buffer' },
		{ name = 'path' },
	},
	mapping = cmp.mapping.preset.insert {
		['<c-u>'] = cmp.mapping.scroll_docs(-4),
		['<c-d>'] = cmp.mapping.scroll_docs(4),
		['<c-n>'] = snip_next,
		['<c-p>'] = snip_prev,
		['<c-j>'] = snip_next,
		['<c-k>'] = snip_prev,
		['<c-space>'] = cmp.mapping.complete(),
		['<cr>'] = cmp.mapping.confirm {
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		},
	},
}

cmp.setup.filetype('gitcommit', {
	sources = {
		{ name = 'buffer' },
		{ name = 'git' },
	},
})

cmp.setup.cmdline({ '/', '?' }, {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = 'buffer' },
	},
})

cmp.setup.cmdline(':', {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = 'path' },
		{ name = 'cmdline' },
	},
})
