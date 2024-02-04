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
		'norcalli/nvim-colorizer.lua',
		opts = {
			"*",
		},
	},

	{
		'EdenEast/nightfox.nvim',
		opts = {
			options = {
				transparent = true,
			},
		},
	},

	'folke/tokyonight.nvim',
	{
		'mtdl9/vim-log-highlighting',
		lazy = true,
		ft = 'log',
	},

	{
		'nvim-treesitter/nvim-treesitter',
		dependencies = { 'nvim-treesitter/nvim-treesitter-textobjects' },
		build = ':TSUpdate',
		config = function()
			require 'setup.treesitter'
		end,
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

	-- 'pinbraerts/shell.vim',

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
		branch = 'master',
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
		dependencies = {
			'hrsh7th/cmp-nvim-lsp',
		},
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
			'L3MON4D3/LuaSnip',
			'hrsh7th/cmp-nvim-lsp',
			'saadparwaiz1/cmp_luasnip',
		},
		ft = lsp_filetypes,
		lazy = true,
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
