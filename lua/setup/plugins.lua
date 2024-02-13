local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

local lsp_filetypes = { 'lua', 'python', 'c', 'cpp', 'rust', 'go', 'ps1', 'tex', 'plaintex', 'bib' }
local debuggable_filetypes = { 'python', 'c', 'cpp', 'rust', 'go' }

require 'lazy'.setup {
	{
		'nvim-lualine/lualine.nvim',
		dependencies = { 'nvim-tree/nvim-web-devicons' },
		lazy = false,
		config = function ()
			require 'setup.lualine'
		end,
	},

	{
		'monaqa/dial.nvim',
		config = function ()
			local augend = require("dial.augend")
			require("dial.config").augends:register_group {
				default = {
					augend.integer.alias.decimal,
					augend.integer.alias.hex,
					augend.integer.alias.binary,
					augend.integer.alias.octal,
					augend.date.alias["%d.%m.%Y"],
					augend.constant.alias.bool,
					augend.constant.new {
						elements = { 'True', 'False' },
						word = true,
						cyclic = true,
					},
					augend.constant.new {
						elements = { 'and', 'or' },
						word = true,
						cyclic = true,
					},
					augend.constant.new {
						elements = {
							'January',
							'February',
							'March',
							'April',
							'May',
							'June',
							'July',
							'August',
							'September',
							'October',
							'November',
							'December',
						},
						word = true,
						cyclic = true,
					},
					augend.constant.new {
						elements = {
							'Sunday',
							'Monday',
							'Tuesday',
							'Wednesday',
							'Thursday',
							'Friday',
							'Saturday',
						},
						word = true,
						cyclic = true,
					},
					augend.constant.new {
						elements = {
							'Январь',
							'Февраль',
							'Март',
							'Апрель',
							'Май',
							'Июнь',
							'Июль',
							'Август',
							'Сентябрь',
							'Октябрь',
							'Ноябрь',
							'Декабрь',
						},
						word = true,
						cyclic = true,
					},
					augend.constant.new {
						elements = {
							'Понедельник',
							'Вторник',
							'Среда',
							'Четверг',
							'Пятница',
							'Суббота',
							'Воскресенье',
						},
						word = true,
						cyclic = true,
					},
					augend.hexcolor.new { },
					augend.semver.new { },
				},
				visual = {
					augend.paren.new {
						patterns = { { "'", "'" }, { '"', '"' } },
						nested = false,
						escape_char = [[\]],
						cyclic = true,
					},
				},
			}
		end,
		keys = {
			{  '<C-a>',  '<Plug>(dial-increment)', mode = { 'n', 'v' }, },
			{  '<C-x>',  '<Plug>(dial-decrement)', mode = { 'n', 'v' }, },
			{ 'g<C-a>', 'g<Plug>(dial-increment)', mode = { 'n', 'v' }, },
			{ 'g<C-x>', 'g<Plug>(dial-decrement)', mode = { 'n', 'v' }, },
		},
	},

	{
		'norcalli/nvim-colorizer.lua',
		config = function ()
			require('colorizer').setup(
				{ "*" },
				{
					RGB      = true,
					RRGGBB   = true,
					names    = true,
					RRGGBBAA = true,
					rgb_fn   = true,
					hsl_fn   = true,
					css      = true,
					css_fn   = true,
					mode     = 'background',
				}
			)
		end,
	},

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
	},

	{
		'mtdl9/vim-log-highlighting',
		lazy = true,
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
				search_engine = "duckduckgo",
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
		'nvim-treesitter/nvim-treesitter',
		dependencies = { 'nvim-treesitter/nvim-treesitter-textobjects' },
		build = ':TSUpdate',
		lazy = false,
		config = function()
			require 'setup.treesitter'
		end,
		keys = {
			{ '<leader>ti', '<cmd>InspectTree<cr>', desc = '[T]ree [i]nspect', silent = true, },
		},
	},

	{
		'numToStr/Comment.nvim',
		config = function ()
			require 'Comment'.setup {
				padding = true,
				sticky = true,
				toggler = {
					line = 'gc',
				},
				mappings = {
					basic = true,
					extra = false,
				},
			}
		end,
	},

	{
		'tpope/vim-fugitive',
		lazy = false,
		keys = {
			{ '\\gc', '<cmd>G commit<cr>', desc = '[G]it [c]ommit', silent = true },
			{ '\\gf', '<cmd>G fetch<cr>', desc = '[G]it [f]etch', silent = true },
			{ '\\gF', '<cmd>G fetch --all --prune<cr>', desc = '[G]it [F]etch all and prune', silent = true },
			{ '\\gp', '<cmd>G push<cr>', desc = '[G]it [p]ush', silent = true },
			{ '\\gP', '<cmd>G push --force-with-lease<cr>', desc = '[G]it [P]ush force with lease', silent = true },
			{ '\\gu', '<cmd>G submodule update', desc = '[G]it [u]pdate submodules', silent = true },
			{ '\\gU', '<cmd>G submodule update --init --recursive<cr>', desc = '[G]it [U]pdate submodules recursive init', silent = true },
			{ '\\gl', '<cmd>G pull<cr>', desc = '[G]it pu[l]l', silent = true },
			{ '\\gL', '<cmd>G pull --no-rebase<cr>', desc = '[G]it pu[l]l rebase', silent = true },
		},
	},

	{
		'lewis6991/gitsigns.nvim',
		config = function()
			require 'setup.gitsigns'
		end,
	},

	{
		'nvim-telescope/telescope.nvim',
		branch = '0.1.x',
		dependencies = { 'nvim-lua/plenary.nvim' },
		config = function ()
			require 'setup.telescope'
		end,
	},

	{
		'nvim-telescope/telescope-file-browser.nvim',
		dependencies = { 'nvim-telescope/telescope.nvim' },
		config = function()
			local tf = require('telescope').load_extension('file_browser')
			vim.keymap.set('n', '<leader>fb', tf.file_browser, { desc = '[F]ile [b]rowser' })
		end,
	},

	{
		'nvim-telescope/telescope-symbols.nvim',
		dependencies = { 'nvim-telescope/telescope.nvim' },
		config = function()
			local ts = require('telescope.builtin')
			vim.keymap.set('n', '<leader>ts', ts.symbols, { desc = 'Open unicode symbols picker' })
			vim.keymap.set('i', '<c-s>', ts.symbols, { desc = 'Open unicode symbols picker' })
		end,
	},

	{
		'neovim/nvim-lspconfig',
		ft = lsp_filetypes,
		lazy = true,
		config = function ()
			require 'setup.lsp'
		end,
		keys = {
			{ 'gh', '<cmd>ClangdSwitchSourceHeader<cr>', silent = true, desc = 'Switch beetween source and header files by clangd', },
		},
	},

	{
		'hrsh7th/nvim-cmp',
		dependencies = {
			'hrsh7th/cmp-nvim-lsp',
			'hrsh7th/cmp-buffer',
			'hrsh7th/cmp-path',
			'hrsh7th/cmp-cmdline',
			'petertriho/cmp-git',
			'L3MON4D3/LuaSnip',
			'saadparwaiz1/cmp_luasnip',
		},
		lazy = false,
		config = function()
			require 'setup.completion'
		end,
	},

	{
		'mrcjkb/rustaceanvim',
		version = '^4',
		ft = { 'rust' },
		config = function ()
			vim.g.rustaceanvim = {
				dap = {
					autoload_configurations = true,
				},
			}
		end,
	},

	{
		'mfussenegger/nvim-dap',
		lazy = true,
		ft = debuggable_filetypes,
		dependencies = {
			'rcarriga/nvim-dap-ui',
		},
		config = function ()
			require 'setup.debugging'
		end,
	},

	{
		'mfussenegger/nvim-dap-python',
		ft = 'python',
		config = function ()
			require('dap-python').setup(vim.fn.executable('python3') and 'python3' or 'python')
		end,
	},

	{
		'nvim-telescope/telescope-dap.nvim',
		lazy = true,
		ft = debuggable_filetypes,
		dependencies = {
			'nvim-telescope/telescope.nvim',
			'mfussenegger/nvim-dap',
			'nvim-treesitter/nvim-treesitter',
		},
		config = function()
			local td = require('telescope').load_extension('dap')
			vim.keymap.set('n', '<leader>db', td.list_breakpoints, { desc = '[L]ist [d]ebug [b]reakpoints' })
			vim.keymap.set('n', '<leader>dd', td.configurations, { desc = '[L]ist [d]ebug [c]onfigurations' })
			vim.keymap.set('n', '<leader>df', td.frames, { desc = '[List] [d]ebug [f]rames' })
			vim.keymap.set('n', '<leader>dv', td.variables, { desc = '[L]ist [d]ebug [v]ariables' })
		end,
	},

}
