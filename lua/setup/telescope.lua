local t = require 'telescope'
local a = require 'telescope.actions'

local next = {
	a.move_selection_next,
	type = 'action',
	opts = { nowait = true, silent = true },
}
local previous = {
	a.move_selection_previous,
	type = 'action',
	opts = { nowait = true, silent = true },
}

t.setup {
	defaults = {
		path_display = { 'smart', },
		layout_config = {
			flex = {
				flip_columns = 140,
			},
			horizontal = {
				preview_width = { 0.5, min = 80, },
				preview_cutoff = 0,
				width = 0.9,
				height = 0.9,
			},
			vertical = {
				preview_cutoff = 0,
				preview_height = 0.5,
				width = 0.9,
				height = 0.9,
			},
		},
		layout_strategy = 'flex',
		mappings = {
			i = {
				['<c-j>'] = next,
				['<c-k>'] = previous,
				['<c-l>'] = 'select_vertical',
				['<c-v>'] = 'select_vertical',
				['<c-h>'] = 'select_horizontal',
			},
			n = {
				v = 'toggle_selection',
				l = 'select_vertical',
				h = 'select_horizontal',
				q = 'close',
				['<c-c>'] = 'close',
				['<c-j>'] = next,
				['<c-k>'] = previous,
			},
		},
	},
	pickers = {
		pickers = {
			mappings = {
				i = {
					['<c-l>'] = 'select_default',
				},
				n = {
					l = 'select_default',
				},
			},
		},
		colorscheme = {
			enable_preview = true,
		},
		builtin = { include_extensions = true, },
		help_tags = {
			mappings = {
				i = {
					['<enter>'] = 'select_vertical',
				},
				n = {
					['<c-enter>'] = 'select_vertical',
				},
			},
		},
		man_pages = {
			mappings = {
				i = {
					['<enter>'] = 'select_vertical',
				},
				n = {
					['<c-enter>'] = 'select_vertical',
				},
			},
		},
		git_status = {
			initial_mode = 'normal',
			mappings = {
				n = {
					s = 'git_staging_toggle',
					u = 'git_staging_toggle',
				},
			},
		},
		find_files = {
			no_ignore = true,
			hidden = true,
		},
	},
	extensions = {
		file_browser = {
			respect_gitignore = false,
			auto_depth = 2,
			hidden = true,
		},
	},
}

local b = require 'telescope.builtin'
vim.keymap.set('n', '<leader>]', b.current_buffer_fuzzy_find, { desc = 'Fuzzy find' })
vim.keymap.set('n', '<leader>t/', b.search_history, { desc = 'Search history' })
vim.keymap.set('n', '<leader>t;', b.command_history, { desc = 'Command history' })
vim.keymap.set('n', '<leader>h', b.help_tags, { desc = '[h]elp tags' })
vim.keymap.set('n', '<leader>mp', b.man_pages, { desc = '[m]an [p]ages' })
vim.keymap.set('n', '<leader>mm', b.marks, { desc = 'marks' })
vim.keymap.set('n', '<leader>q', b.quickfix, { desc = '[q]uickfix' })
vim.keymap.set('n', '<leader>tb', b.buffers, { desc = '[b]uffers' })
vim.keymap.set('n', '<leader>tc', b.colorscheme, { desc = '[c]olorscheme' })
-- vim.keymap.set('n', '<leader>te', b.diagnostics, { desc = '[e]rrors' })
vim.keymap.set('n', '<leader>ch', b.keymaps, { desc = '[C]heat [s]heet' })
vim.keymap.set('n', '<leader>tl', b.jumplist, { desc = 'Jump[l]is[t]' })
vim.keymap.set('n', '<leader>to', b.vim_options, { desc = '[o]ptions' })
vim.keymap.set('n', '<leader>tp', b.pickers, { desc = '[p]ickers' })
vim.keymap.set('n', '<leader>tq', b.quickfixhistory, { desc = '[q]uckfix history' })
vim.keymap.set('n', '<leader>t=', b.registers, { desc = 'Registers' })
vim.keymap.set('n', '<leader>ts', b.symbols, { desc = '[S]ymbols' })
vim.keymap.set('n', '<leader>tj', b.builtin, { desc = 'builtin pickers' })
vim.keymap.set('n', '<leader>tr', b.resume, { desc = 'Reopen last picker [T]elescope [r]esume' })

vim.keymap.set('n', '<leader>fd', b.find_files, { desc = 'Find files (with [fd])' })
vim.keymap.set('n', '<leader>gf', b.git_files, { desc = '[G]it [f]iles' })
vim.keymap.set('n', '<leader>rg', b.live_grep, { desc = 'Live grep (with [rg])' })
vim.keymap.set('n', '<leader>rG', function ()
	b.live_grep {
		additional_args = { '-u' },
	}
end, { desc = 'Live grep (with [rg], all files)' })
vim.keymap.set('n', '<leader>gw', b.grep_string, { desc = '[G]rep [w]ord' })
vim.keymap.set('n', '<leader>gW', function ()
	b.grep_string {
		additional_args = { '-u' },
	}
end, { desc = '[G]rep [w]ord (all files)' })
vim.keymap.set('n', '<leader>rf', b.oldfiles, { desc = '[R]ecent [f]iles' })

vim.keymap.set('n', '<leader>ld', b.current_buffer_tags, { desc = '[L]SP buffer [t]ags' })
vim.keymap.set('n', '<leader>lf', b.tags, { desc = '[L]SP [f]ull tags' })
vim.keymap.set('n', '<leader>li', b.lsp_incoming_calls, { desc = '[L]SP [i]ncoming calls' })
vim.keymap.set('n', '<leader>lo', b.lsp_outgoing_calls, { desc = '[L]SP [o]outgoing calls' })
vim.keymap.set('n', '<leader>ls', b.tagstack, { desc = '[L]SP tag[s]tack' })
vim.keymap.set('n', '<leader>lt', b.lsp_type_definitions, { desc = '[L]SP [t]ype definitions' })

vim.keymap.set('n', '<leader>gb', b.git_branches, { desc = '[g]it [b]ranches' })
vim.keymap.set('n', '<leader>gc', b.git_commits, { desc = '[g]it [c]ommits' })
vim.keymap.set('n', '<leader>gC', b.git_bcommits, { desc = '[g]it [C]ommits of the buffer' })
vim.keymap.set('n', '<leader>gh', b.git_stash, { desc = '[G]it stas[h]' })
vim.keymap.set('n', '<leader>gl', b.git_commits, { desc = '[G]it [l]og commits' })
vim.keymap.set('n', '<leader>gs', b.git_status, { desc = '[G]it [s]tatus' })
