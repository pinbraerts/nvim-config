-- local dap = require 'dap'
--
-- dap.configurations.trueconf = {
-- 	{
-- 		name = 'TrueConf.exe',
-- 		type = 'codelldb',
-- 		request = 'launch',
-- 		program = 'C:\\Users\\shirshov\\src\\pc\\build_x64\\Client8\\Debug\\TrueConf.exe',
-- 		cwd = 'C:\\Users\\shirshov\\src\\pc\\build_x64\\extlibs\\debug',
-- 		stopOnEntry = false,
-- 		options = {
-- 			detached = false,
-- 		},
-- 	},
-- 	{
-- 		name = 'TestProjects.exe',
-- 		type = 'codelldb',
-- 		request = 'launch',
-- 		program = 'C:\\Users\\shirshov\\src\\pc\\build_x64\\TestProjects\\Debug\\TestProjects.exe',
-- 		cwd = 'C:\\Users\\shirshov\\src\\pc\\build_x64\\extlibs\\debug',
-- 		stopOnEntry = false,
-- 		options = {
-- 			detached = false,
-- 		},
-- 	},
-- }

local parsers = require 'nvim-treesitter.parsers'.get_parser_configs()
vim.filetype.add {
	extension = {
		bff = 'fastbuild',
	},
}
parsers.fastbuild = {
	install_info = {
		url = 'https://github.com/pinbraerts/tree-sitter-fastbuild.git',
		branch = 'main',
		files = {
			'src/parser.c',
			'src/scanner.c',
		},
		generate_requires_npm = false,
		requires_generate_from_grammar = false,
	},
	filetype = 'fastbuild',
}
vim.treesitter.language.register('fastbuild', 'fastbuild')
