return {
	{
		'EdenEast/nightfox.nvim',
		opts = {
			options = {
				transparent = true,
			},
			groups = {
				all = {
					 WinSeparator = { fg = '#719cd6' },
				},
			},
		},
		lazy = true,
	},

	{
		'catppuccin/nvim',
		name = 'catppuccin',
		opts = {
			transparent_background = true,
		},
		lazy = true,
	},

	{
		'folke/tokyonight.nvim',
		opts = {
			transparent = true,
			styles = {
				sidebars = 'transparent',
				floats = 'transparent',
			},
			lualine_bold = true,
		},
		lazy = true,
	},

	{
		'aserowy/tmux.nvim',
		cond = function () return os.getenv("TMUX") ~= nil end,
		config = function ()
			require('tmux').setup {
				navigation = {
					enable_default_keybindings = true,
					cycle_navigation = false,
					persist_zoom = true,
				},
				resize = {
					enable_default_keybindings = false,
				},
			}
		end
	},

}
