return {
	{
		'EdenEast/nightfox.nvim',
		opts = {
			options = {
				transparent = true,
			},
		},
	},

	{
		'catppuccin/nvim',
		name = 'catppuccin',
		opts = {
			transparent_background = true,
		},
		enabled = false,
	},

	{
		'folke/tokyonight.nvim',
		opts = {
			transparent = true,
			styles = {
				sidebars = 'transparent',
				floats = 'transparent',
			},
		},
		enabled = false,
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
