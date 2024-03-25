vim.o.cmdheight = 0
vim.cmd.colorscheme('nightfox')
vim.filetype.add {
	extension = {
		zsh = 'sh',
		sh = 'sh',
	},
	filename = {
		['.zshrc'] = 'sh',
		['.zprofile'] = 'sh',
		['.zshenv'] = 'sh',
	},
}

require('telescope.config').values.file_previewer = require('core.ueberzugpp').new

local parsers = require 'nvim-treesitter.parsers'.get_parser_configs()
vim.filetype.add {
	extension = {
		jk = 'jk',
		bff = 'fastbuild',
	},
}
parsers.jk = {
	install_info = {
		url = '~/src/tree-sitter-jk/',
		files = {
			'src/parser.c',
			'src/scanner.c',
		},
		generate_requires_npm = false,
		requires_generate_from_grammar = true,
	},
	filetype = 'jk',
}
parsers.fastbuild = {
	install_info = {
		url = '~/src/tree-sitter-fastbuild/',
		files = {
			'src/parser.c',
			'src/scanner.c',
		},
		generate_requires_npm = false,
		requires_generate_from_grammar = true,
	},
	filetype = 'fastbuild',
}
