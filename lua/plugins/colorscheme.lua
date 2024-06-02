local is_tty = vim.fn.has("gui_running") == 0

local function colorscheme (options)
	return vim.tbl_extend('force', {
		lazy = true,
	}, options)
end

return {

	colorscheme {
		'EdenEast/nightfox.nvim',
		opts = {
			options = {
				transparent = is_tty,
			},
			groups = {
				all = {
					 WinSeparator = { fg = '#719cd6' },
				},
			},
		},
	},

	colorscheme {
		'catppuccin/nvim',
		name = 'catppuccin',
		opts = {
			transparent_background = is_tty,
		},
	},

	colorscheme {
		'folke/tokyonight.nvim',
		opts = {
			transparent = is_tty,
			styles = is_tty and {
				sidebars = 'transparent',
				floats = 'transparent',
			} or nil,
			lualine_bold = true,
		},
	},

}
