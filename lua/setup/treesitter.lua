local languages = { 'rust', 'c', 'cpp', 'python', 'lua', 'cuda', 'vimdoc', 'html', 'css', 'javascript', 'go' }
if vim.fn.has('win32') ~= 0 then
	require 'nvim-treesitter.install'.compilers = { 'cl.exe' }
end
require 'nvim-treesitter.configs'.setup {
	ensure_installed = languages,
	auto_install = false,
	sync_install = true,
	ignore_install = {},
	modules = {},
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	},
	indent = { enable = true, disable = { 'c', 'cpp' } },
	incremental_selection = { enable = true },
	textobjects = {
		select = {
			enable = true,
			lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
			keymaps = {
				-- You can use the capture groups defined in textobjects.scm
				['aa'] = '@parameter.outer',
				['ia'] = '@parameter.inner',
				['af'] = '@function.outer',
				['if'] = '@function.inner',
				['ac'] = '@class.outer',
				['ic'] = '@class.inner',
			},
		},
		move = {
			enable = true,
			set_jumps = true, -- whether to set jumps in the jumplist
			goto_next_start = {
				[']m'] = '@function.outer',
				[']]'] = '@class.outer',
			},
			goto_next_end = {
				[']M'] = '@function.outer',
				[']['] = '@class.outer',
			},
			goto_previous_start = {
				['[m'] = '@function.outer',
				['[['] = '@class.outer',
			},
			goto_previous_end = {
				['[M'] = '@function.outer',
				['[]'] = '@class.outer',
			},
		},
		swap = {
			enable = true,
			swap_next = {
				['<leader>a'] = '@parameter.inner',
			},
			swap_previous = {
				['<leader>A'] = '@parameter.inner',
			},
		},
	},
	context = {
		enable = true,
	},
}
vim.wo.foldmethod = 'expr'
vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.o.foldlevel = 9999
