local ft = require('filetypes')
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

			vim.keymap.set("n", "K", hover.hover, { desc = "hover.nvim" })
			vim.keymap.set("n", "gK", hover.hover_select, { desc = "hover.nvim (select)" })
			vim.keymap.set("n", "<C-p>", function() hover.hover_switch("previous") end, { desc = "hover.nvim (previous source)" })
			vim.keymap.set("n", "<C-n>", function() hover.hover_switch("next") end, { desc = "hover.nvim (next source)" })

			-- vim.keymap.set('n', '<MouseMove>', require('hover').hover_mouse, { desc = "hover.nvim (mouse)" })
			-- vim.o.mousemoveevent = true
		end,
		keys = {
			{ "K", desc = "hover.nvim" },
			{ "gK", desc = "hover.nvim (select)" },
			{ "<C-p>", desc = "hover.nvim (previous source)" },
			{ "<C-n>", desc = "hover.nvim (next source)" },
		},
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
		cmd = {
			'Z', 'Lz', 'Tz', 'Zi', 'Lzi', 'Tzi',
		},
	},

	{ 'EdenEast/nightfox.nvim', lazy = true },
	{ 'catppuccin/nvim', name = 'catppuccin', setup = true, lazy = true },
	{ 'folke/tokyonight.nvim', lazy = true },

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

	unpack(local_plugins)
}
