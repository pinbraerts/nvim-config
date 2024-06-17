local t = vim.api.nvim_create_augroup('terminal', { clear = true })
vim.api.nvim_create_autocmd('TermOpen', {
	group = t,
	callback = function (args)
		vim.opt_local.number = false
		vim.opt_local.relativenumber = false
		vim.opt_local.signcolumn = 'no'
		vim.bo[args.buf].filetype = 'terminal'
		vim.cmd.startinsert()
	end,
})

vim.api.nvim_create_autocmd({ 'BufWinEnter', 'WinEnter' }, {
	pattern = 'term://*',
	group = t,
	callback = function (_)
		vim.cmd.startinsert() -- automatically enter normal mode
	end,
})

vim.keymap.set('t', '<s-esc>', '<c-\\><c-n>', { desc = 'quit terminal mode' })
vim.keymap.set('t', '<c-q>[', '<c-\\><c-n>', { desc = 'quit terminal mode' })
vim.keymap.set({ 't', 'i' }, '<c-h>', '<c-\\><c-n><c-w>h', { desc = 'focus left window' })
vim.keymap.set({ 't', 'i' }, '<c-l>', '<c-\\><c-n><c-w>l', { desc = 'focus right window' })
vim.keymap.set('i', '<c-j>', '<c-\\><c-n><c-w>j', { desc = 'focus down window' })
vim.keymap.set('i', '<c-k>', '<c-\\><c-n><c-w>k', { desc = 'focus up window' })

vim.keymap.set('t', '<c-j>', '<c-j>')
vim.keymap.set('t', '<c-k>', '<c-k>')

-- workaround CSI u
vim.keymap.set('t', '<s-space>', '<space>')
vim.keymap.set('t', '<s-enter>', '<enter>')
vim.keymap.set('t', '<s-backspace>', '<backspace>')

vim.keymap.set('n', '<c-q>v', '<cmd>vsplit <bar> term pwsh -nologo<cr>', { silent = true, nowait = true, desc = 'Split vertical terminal' })
vim.keymap.set('n', '<c-q>h', '<cmd>split <bar> term pwsh -nologo<cr>', { silent = true, nowait = true, desc = 'Split horizontal terminal' })
vim.keymap.set('n', '<c-q>c', '<cmd>tabnew <bar> term pwsh -nologo<cr>', { silent = true, nowait = true, desc = 'New terminal tab' })
