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
