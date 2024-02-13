local luasnip = require('luasnip')
local cmp = require('cmp')
local function snip_next (fallback)
	if cmp.visible() then
		cmp.select_next_item()
	elseif luasnip.expand_or_jumpable() then
		luasnip.expand_or_jump()
	else
		fallback()
	end
end
snip_next = cmp.mapping(snip_next)
local function snip_prev (fallback)
	if cmp.visible() then
		cmp.select_prev_item()
	elseif luasnip.jumpable(-1) then
		luasnip.jump(-1)
	else
		fallback()
	end
end
snip_prev = cmp.mapping(snip_prev)
cmp.setup {
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	sources = {
		{ name = 'nvim_lsp' },
		{ name = 'luasnip' },
		{ name = 'buffer' },
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
