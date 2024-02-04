local l = require 'lualine'

local function refresh_statusline()
	l.refresh { place = 'statusline' }
end
local g = vim.api.nvim_create_augroup('lualine', { clear = true })
vim.api.nvim_create_autocmd('RecordingEnter', {
	callback = refresh_statusline,
	group = g,
})
vim.api.nvim_create_autocmd('RecordingLeave', {
	callback = function ()
		vim.defer_fn(refresh_statusline, 50)
	end,
	group = g,
})

l.setup {
	options = {
		globalstatus = true,
		section_separators = { left = '', right = '' },
		-- component_separators = { left = '', right = '' },
		component_separators = { left = '|', right = '|' },
	},
	sections = {
		lualine_a = { 'mode' },
		lualine_b = { 'branch' },
		lualine_c = {
			{
				'buffers',
				icons_enabled = false,
				section_separators = { left = '' },
				component_separators = { left = '' },
				mode = 2,
				symbols = {
					alternate_file = '',
				},
			},
		},
		lualine_x = {
			'diff',
			'diagnostics',
			{
				function ()
					return vim.fn.reg_recording()
				end,
				icon = { '🔴' },
				type = 'lua_expr',
			},
		},
		lualine_y = { 'filetype', 'fileformat', 'encoding', },
		lualine_z = { 'searchcount', 'progress', 'location', },
	},
}
for i = 1, 9 do
	local ii = tostring(i)
	vim.keymap.set('n', 'g' .. ii, '<cmd>LualineBuffersJump ' .. ii .. '<cr>', { silent = true, nowait = true, desc = 'Jump to buffer ' .. ii })
end
