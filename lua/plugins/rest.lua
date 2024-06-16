local ft = require('filetypes')

local function foreground(colors)
	local result = {}
	for i, color in ipairs(colors) do
		local group = 'Rainbow' .. i
		vim.cmd.highlight(group, 'guifg=' .. color)
		result[i] = group
	end
	return result
end

return {

	{
		'stevearc/resession.nvim',
		config = function ()
			local resession = require 'resession'
			resession.setup {
			}
			vim.api.nvim_create_autocmd("VimEnter", {
				callback = function()
					if vim.fn.argc(-1) == 0 then
						resession.load(vim.fn.getcwd(), { dir = ".session", silence_errors = true })
					end
				end,
			})
			vim.api.nvim_create_autocmd("VimLeavePre", {
				callback = function()
					if vim.fn.argc(-1) == 0 then
						resession.save(vim.fn.getcwd(), { dir = ".session", notify = false })
					end
				end,
			})
		end,
	},

	{
		'HiPhish/rainbow-delimiters.nvim',
		ft = ft.highlight,
		config = function ()
			local rd = require('rainbow-delimiters')
			require('rainbow-delimiters.setup').setup {
				strategy = {
					[''] = rd.strategy['global'],
				},
				query = {
					[''] = 'rainbow-delimiters',
					latex = 'rainbow-blocks',
				},
				whitelist = ft.highlight,
				highlight = foreground {
					"#82aaff",
					"#ff966c",
					"#c3e88d",
					"#ffc777",
					"#c099ff",
					"#86e1fc",
					"#828bb8",
					"#ff757f",
					"#c8d3f5",
				},
			}
		end
	},

	{
		'nanotee/zoxide.vim',
		cond = function () return vim.fn.executable("zoxide") ~= 0 end,
		cmd = {
			'Z', 'Lz', 'Tz', 'Zi', 'Lzi', 'Tzi',
		},
	},

	{
		'folke/trouble.nvim',
		keys = {
			{ '<leader>te', '<cmd>TroubleToggle<cr>', desc = "[T]oggle [e]rrors", silent = true },
		},
	},

	{
		'NvChad/nvim-colorizer.lua',
		ft = ft.colorize,
		config = function ()
			require('colorizer').setup {
				filetypes = ft.colorize,
				user_default_options = {
					RGB      = true,
					RRGGBB   = true,
					names    = true,
					RRGGBBAA = true,
					rgb_fn   = true,
					hsl_fn   = true,
					css      = true,
					css_fn   = true,
					mode     = 'background',
				},
			}
		end,
	},

	{
		'mtdl9/vim-log-highlighting',
		ft = 'log',
	},

	{
		"chrishrb/gx.nvim",
		keys = { { "gx", "<cmd>Browse<cr>", mode = { "n", "x" } } },
		cmd = { "Browse" },
		init = function ()
			vim.g.netrw_nogx = 1
		end,
		dependencies = { 'nvim-lua/plenary.nvim' },
		opts = {
			handler_options = {
				search_engine = "https://search.disroot.org/?q=",
			},
		},
	},

	{
		'mbbill/undotree',
		keys = {
			{ '<leader>tu', '<cmd>UndotreeToggle<cr>', desc = '[T]oggle [u]ndo tree', silent = true, },
		},
	},

	{
		'numToStr/Comment.nvim',
		dependencies = { 'nvim-treesitter/nvim-treesitter' },
		keys = { { 'gc', mode = { 'n', 'v' } } },
		config = true,
	},

	{
		'aserowy/tmux.nvim',
		enable = vim.fn.executable("tmux") ~= 0,
		cond = function () return os.getenv("TMUX") ~= nil end,
		config = function ()
			local tmux = require('tmux')
			tmux.setup {
				navigation = {
					enable_default_keybindings = false,
					cycle_navigation = false,
					persist_zoom = true,
				},
				resize = {
					enable_default_keybindings = false,
				},
			}
			vim.keymap.set('n', '<c-h>', tmux.move_left, { silent = true, nowait = true, desc = 'Select right pane' })
			vim.keymap.set('n', '<c-j>', tmux.move_bottom, { silent = true, nowait = true, desc = 'Select upper pane' })
			vim.keymap.set('n', '<c-k>', tmux.move_top, { silent = true, nowait = true, desc = 'Select down pane' })
			vim.keymap.set('n', '<c-l>', tmux.move_right, { silent = true, nowait = true, desc = 'Select left pane' })
		end,
		keys = {
			{ '<c-h>', desc = 'Select right pane' },
			{ '<c-j>', desc = 'Select down pane' },
			{ '<c-k>', desc = 'Select upper pane' },
			{ '<c-l>', desc = 'Select left pane' },
		},
	},

}
