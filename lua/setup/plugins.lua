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

local function join (arrays)
	local result = { }
	for _, a in ipairs(arrays) do
		local result_size = #result
		for j, v in ipairs(a) do
			result[result_size + j] = v
		end
	end
	return result
end

local ft_web = {
	'javascript', 'html', 'css',
}

local ft_shell = {
	'sh', 'ps1',
}

local ft_debug = {
	'python',
	'c', 'cpp', 'rust', 'go',
}

local ft_tex = {
	'tex', 'plaintex', 'bib',
}

local ft_config = {
	'json', 'toml', 'xml', 'zathurarc', 'ini',
}

local ft_documentation = {
	'jsdoc', 'luadoc', 'vimdoc',
}

local ft_lsp = join {
	{ 'lua', 'fastbuild', },
	ft_shell,
	ft_debug,
	ft_web,
	ft_tex,
}

local ft_highlight = join {
	{ 'jq', 'query', },
	{ 'markdown', 'markdown_inline', },
	ft_documentation,
	ft_config,
	ft_lsp,
}

local ft_colorize = join {
	{ 'lua', },
	ft_web,
	ft_config,
	ft_shell,
}

local ok, local_plugins = pcall(require, 'local.plugins')
if not ok then
	local_plugins = { }
end
if vim.fn.has('win32') ~= 0 then
	local status, plugins = pcall(require, 'windows.plugins')
	if status then
		local_plugins = vim.tbl_extend('force', local_plugins, plugins)
	end
end
if vim.fn.has('linux') ~= 0 then
	local status, plugins = pcall(require, 'linux.plugins')
	if status then
		local_plugins = vim.tbl_extend('force', local_plugins, plugins)
	end
end

local function theme(opts)
	return vim.tbl_extend('keep', opts, {
		lazy = true,
		cmd = 'Telescope colorscheme',
		keys = { '<leader>tc' },
	})
end

vim.keymap.set('n', '<leader>lz', '<cmd>Lazy<cr>', { desc = 'Open [L]a[z]y', silent = true })
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
		'stevearc/resession.nvim',
		config = function ()
			local resession = require 'resession'
			resession.setup {
			}
			vim.api.nvim_create_autocmd("VimEnter", {
				callback = function()
					-- Only load the session if nvim was started with no args
					if vim.fn.argc(-1) == 0 then
						-- Save these to a different directory, so our manual sessions don't get polluted
						resession.load(vim.fn.getcwd(), { dir = ".session", silence_errors = true })
					end
				end,
			})
			vim.api.nvim_create_autocmd("VimLeavePre", {
				callback = function()
					resession.save(vim.fn.getcwd(), { dir = ".session", notify = false })
				end,
			})
		end,
	},

	{
		"lewis6991/hover.nvim",
		config = function()
			local hover = require("hover")
			hover.setup {
				init = function()
					-- Require providers
					require("hover.providers.lsp")
					require('hover.providers.gh')
					require('hover.providers.gh_user')
					-- require('hover.providers.jira')
					require('hover.providers.man')
					-- require('hover.providers.dictionary')
				end,
				preview_opts = {
					border = 'single',
					focusable = true,
					focus = true,
				},
				-- Whether the contents of a currently open hover window should be moved
				-- to a :h preview-window when pressing the hover keymap.
				preview_window = false,
				title = true,
				mouse_providers = {
					'LSP'
				},
				mouse_delay = 1000
			}

			vim.keymap.set("n", "K", require("hover").hover, { desc = "hover.nvim" })
			vim.keymap.set("n", "gK", require("hover").hover_select, { desc = "hover.nvim (select)" })
			vim.keymap.set("n", "<C-p>", function() require("hover").hover_switch("previous") end, { desc = "hover.nvim (previous source)" })
			vim.keymap.set("n", "<C-n>", function() require("hover").hover_switch("next") end, { desc = "hover.nvim (next source)" })

			-- vim.keymap.set('n', '<MouseMove>', require('hover').hover_mouse, { desc = "hover.nvim (mouse)" })
			-- vim.o.mousemoveevent = true
		end,
	},

	{
		'nanotee/zoxide.vim',
		cmd = {
			'Z', 'Lz', 'Tz', 'Zi', 'Lzi', 'Tzi',
		},
	},

	theme { 'EdenEast/nightfox.nvim' },
	theme { 'catppuccin/nvim', name = 'catppuccin', setup = true, },
	theme { 'folke/tokyonight.nvim' },

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
		'folke/trouble.nvim',
		keys = {
			{ '<leader>te', '<cmd>TroubleToggle<cr>', desc = "[T]oggle [e]rrors", silent = true },
		},
	},

	{
		'NvChad/nvim-colorizer.lua',
		ft = ft_colorize,
		config = function ()
			require('colorizer').setup {
				filetypes = ft_colorize,
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
		dependencies = {
			'nvim-treesitter/nvim-treesitter-textobjects',
			'nvim-treesitter/nvim-treesitter-context',
		},
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
		'windwp/nvim-ts-autotag',
		dependencies = {
			'nvim-treesitter/nvim-treesitter',
		},
		ft = {
			'html', 'xml',
			-- 'javascript', 'typescript', 'javascriptreact',
			'typescriptreact', 'svelte', 'vue', 'tsx', 'jsx', 'rescript',
			'php',
			'markdown',
			'astro', 'glimmer', 'handlebars', 'hbs'
		},
	},

	{
		'numToStr/Comment.nvim',
		dependencies = { 'nvim-treesitter/nvim-treesitter' },
		keys = { { 'gc', mode = { 'n', 'v' } } },
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
		'NeogitOrg/neogit',
		dependencies = {
			'nvim-lua/plenary.nvim',
			{
				'sindrets/diffview.nvim',
				cmd = {
					'DiffviewOpen',
					'DiffviewFileHistory',
					'DiffviewClose',
					'DiffviewToggleFiles',
					'DiffviewFocusFiles',
					'DiffviewRefresh',
					'DiffviewLog',
				},
			},
			'nvim-telescope/telescope.nvim',
		},
		config = function ()
			local neogit = require('neogit')
			neogit.setup({})
			vim.keymap.set('n', '\\gc', function () neogit.open({ 'commit' }) end, { desc = '[G]it [c]ommit', })
			vim.keymap.set('n', '\\gf', neogit.action('fetch', 'fetch_upstream'), { desc = '[G]it [f]etch', })
			vim.keymap.set('n', '\\gF', neogit.action('fetch', 'fetch_all_remotes', { '--all', '--prune' }), { desc = '[G]it [F]etch all and prune', })
			vim.keymap.set('n', '\\gp', neogit.action('push', 'to_upstream'), { desc = '[G]it [P]ush', })
			vim.keymap.set('n', '\\gP', neogit.action('push', 'to_upstream', { '--force-with-lease' }), { desc = '[G]it [P]ush force with lease', })
			-- vim.keymap.set('n', '\\gu', neogit.action('submodule', 'update', { 'update' }), { desc = '[G]it [u]pdate submodules', })
			-- vim.keymap.set('n', '\\gU', neogit.action('submodule', 'update', { 'update', '--init', '--recursive' }), { desc = '[G]it [U]pdate submodules recursive init', })
			vim.keymap.set('n', '\\gl', neogit.action('pull', 'from_upstream'), { desc = '[G]it pu[l]l', })
			vim.keymap.set('n', '\\gL', neogit.action('pull', 'from_upstream', { '--no-rebase' , { desc = '[G]it pu[l]l no rebase', }}))
		end,
		cmd = { 'Neogit' },
		keys = {
			{ '\\gc', desc = '[G]it [c]ommit' },
			{ '\\gf', desc = '[G]it [f]etch' },
			{ '\\gF', desc = '[G]it [F]etch all and prune' },
			{ '\\gp', desc = '[G]it [p]ush' },
			{ '\\gP', desc = '[G]it [P]ush force with lease' },
			-- { '\\gu', desc = '[G]it [u]pdate submodules' },
			-- { '\\gU', desc = '[G]it [U]pdate submodules recursive init' },
			{ '\\gl', desc = '[G]it pu[l]l' },
			{ '\\gL', desc = '[G]it pu[l]l no rebase' },
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
		cmd = 'Telescope',
		keys = {
			{ '<leader>]' , desc = 'Fuzzy find' },
			{ '<leader>t/', desc = 'Search history' },
			{ '<leader>t;', desc = 'Command history' },
			{ '<leader>h' , desc = '[h]elp tags' },
			{ '<leader>mp', desc = '[m]an [p]ages' },
			{ '<leader>mm', desc = 'marks' },
			{ '<leader>q' , desc = '[q]uickfix' },
			{ '<leader>tb', desc = '[b]uffers' },
			{ '<leader>tc', desc = '[c]olorscheme' },
			{ '<leader>ch', desc = '[C]heat [s]heet' },
			{ '<leader>tl', desc = 'Jump[l]is[t]' },
			{ '<leader>to', desc = '[o]ptions' },
			{ '<leader>tp', desc = '[p]ickers' },
			{ '<leader>tq', desc = '[q]uckfix history' },
			{ '<leader>t=', desc = 'Registers' },
			{ '<leader>tj', desc = 'builtin pickers' },
			{ '<leader>tr', desc = 'Reopen last picker [T]elescope [r]esume' },
			{ '<leader>fd', desc = 'Find files (with [fd])' },
			{ '<leader>gf', desc = '[G]it [f]iles' },
			{ '<leader>rg', desc = 'Live grep (with [rg])' },
			{ '<leader>rG', desc = 'Live grea (with [rg], all files)' },
			{ '<leader>gw', desc = '[G]rep [w]ord' },
			{ '<leader>gW', desc = '[G]rep [w]ord (all files)' },
			{ '<leader>rf', desc = '[R]ecent [f]iles' },
			{ '<leader>ld', desc = '[L]SP buffer [t]ags' },
			{ '<leader>lf', desc = '[L]SP [f]ull tags' },
			{ '<leader>li', desc = '[L]SP [i]ncoming calls' },
			{ '<leader>lo', desc = '[L]SP [o]outgoing calls' },
			{ '<leader>ls', desc = '[L]SP tag[s]tack' },
			{ '<leader>lt', desc = '[L]SP [t]ype definitions' },
			{ '<leader>gb', desc = '[g]it [b]ranches' },
			{ '<leader>gc', desc = '[g]it [c]ommits' },
			{ '<leader>gC', desc = '[g]it [C]ommits of the buffer' },
			{ '<leader>gh', desc = '[G]it stas[h]' },
			{ '<leader>gl', desc = '[G]it [l]og commits' },
			{ '<leader>gs', desc = '[G]it [s]tatus' },
		},
	},

	{
		'nvim-telescope/telescope-ui-select.nvim',
		dependencies = { 'nvim-telescope/telescope.nvim' },
		config = function()
			require('telescope').load_extension('ui-select')
		end,
	},

	{
		'nvim-telescope/telescope-file-browser.nvim',
		dependencies = { 'nvim-telescope/telescope.nvim' },
		config = function()
			local tf = require('telescope').load_extension('file_browser')
			vim.keymap.set('n', '<leader>fb', tf.file_browser, { desc = '[F]ile [b]rowser' })
		end,
		keys = { '<leader>fb', desc = '[F]ile [b]rowser' },
	},

	{
		'nvim-telescope/telescope-symbols.nvim',
		dependencies = { 'nvim-telescope/telescope.nvim' },
		config = function ()
			local t = require 'telescope.builtin'
			vim.keymap.set('n', '<leader>ts', t.symbols, { desc = 'unicode symbols picker' })
		end,
		keys = { '<leader>ts', desc = 'unicode symbols picker' },
		cmd = 'Telescope symbols',
	},

	{
		'neovim/nvim-lspconfig',
		dependencies = {
			{
				'williamboman/mason.nvim',
				lazy = false,
				opts = {
					ui = {
						icons = {
							package_installed = '✓',
							package_pending = '⬇️',
							package_uninstalled = '✗',
						},
					},
				},
				keys = {
					{ '<leader>ms', '<cmd>Mason<cr>', desc = 'Open [M]a[s]on', silent = true },
				},
			},
			'williamboman/mason-lspconfig.nvim',
			{
				'WhoIsSethDaniel/mason-tool-installer.nvim',
				opts = {
					ensure_installed = {
						'stylua',
						'codelldb',
					},
				},
			},
			{ 'j-hui/fidget.nvim', opts = {} },
			{ 'folke/neodev.nvim', opts = {} },
			'nvim-telescope/telescope.nvim',
		},
		ft = ft_lsp,
		lazy = false,
		config = function ()
			require 'setup.lsp'
		end,
		keys = {
			{ 'gh', '<cmd>ClangdSwitchSourceHeader<cr>', desc = '[G]o to header', silent = true, },
		},
	},

	{
		'hrsh7th/nvim-cmp',
		event = { 'CmdLineEnter', 'InsertEnter' },
		dependencies = {
			'hrsh7th/cmp-nvim-lsp',
			'hrsh7th/cmp-nvim-lsp-signature-help',
			'hrsh7th/cmp-buffer',
			'hrsh7th/cmp-path',
			'hrsh7th/cmp-cmdline',
			'petertriho/cmp-git',
			{
				'L3MON4D3/LuaSnip',
				build = 'make install_jsregexp',
			},
			'saadparwaiz1/cmp_luasnip',
			'onsails/lspkind.nvim',
			{
				'rafamadriz/friendly-snippets',
				config = function ()
					require('luasnip.loaders.from_vscode').lazy_load()
				end,
			},
			{
				'pinbraerts/cmp-tabby',
				config = function()
					local tabby = require('cmp_tabby.config')
					tabby:setup({
						host = 'http://192.168.10.112:5345',
						max_lines = 1024,
					})
				end,
			},
		},
		config = function()
			require 'setup.completion'
		end,
	},

	{
		'mrcjkb/rustaceanvim',
		version = '^4',
		ft = { 'rust' },
		dependencies = { 'neovim/nvim-lspconfig' },
	},

	{
		'mfussenegger/nvim-dap',
		ft = ft_debug,
		config = function ()
			require 'setup.debugging'
		end,
	},

	{
		'rcarriga/nvim-dap-ui',
		dependencies = { 'mfussenegger/nvim-dap', 'nvim-neotest/nvim-nio' },
		keys = { { '<leader>td', desc = '[T]oggle [d]ebug ui' }, },
		config = function ()
			local dapui = require 'dapui'
			dapui.setup()
			vim.keymap.set(
				'n', '<leader>td', dapui.toggle,
				{ desc = "[T]oggle [d]ebug ui" }
			)
		end,
	},

	{
		'mfussenegger/nvim-dap-python',
		dependencies = { 'mfussenegger/nvim-dap' },
		ft = 'python',
		config = function ()
			require('dap-python').setup(vim.fn.executable('python3') and 'python3' or 'python')
		end,
	},

	{
		'leoluz/nvim-dap-go',
		dependencies = { 'mfussenegger/nvim-dap' },
		ft = 'go',
		config = function ()
			require('dap-go').setup()
		end,
	},

	{
		'nvim-telescope/telescope-dap.nvim',
		dependencies = {
			'nvim-telescope/telescope.nvim',
			'mfussenegger/nvim-dap',
		},
		config = function()
			local td = require('telescope').load_extension('dap')
			vim.keymap.set('n', '<leader>db', td.list_breakpoints, { desc = '[L]ist [d]ebug [b]reakpoints' })
			vim.keymap.set('n', '<leader>dd', td.configurations, { desc = '[L]ist [d]ebug [c]onfigurations' })
			vim.keymap.set('n', '<leader>df', td.frames, { desc = '[List] [d]ebug [f]rames' })
			vim.keymap.set('n', '<leader>dv', td.variables, { desc = '[L]ist [d]ebug [v]ariables' })
		end,
		keys = {
			{ '<leader>db', desc = '[L]ist [d]ebug [b]reakpoints' },
			{ '<leader>dd', desc = '[L]ist [d]ebug [c]onfigurations' },
			{ '<leader>df', desc = '[List] [d]ebug [f]rames' },
			{ '<leader>dv', desc = '[L]ist [d]ebug [v]ariables' },
		},
	},

	unpack(local_plugins)
}
