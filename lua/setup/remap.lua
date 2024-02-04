local v = vim.diagnostic
local vs = v.severity
vim.keymap.set('n', '[d', v.goto_prev, { desc = 'Go to previous diagnostic' })
vim.keymap.set('n', ']d', v.goto_next, { desc = 'Go to next diagnostic' })
vim.keymap.set('n', '[e', function () v.goto_prev { severity = vs.ERROR } end, { desc = 'Go to previous error' })
vim.keymap.set('n', ']e', function () v.goto_next { severity = vs.ERROR } end, { desc = 'Go to next error' })
vim.keymap.set('n', '[w', function () v.goto_prev { severity = vs.WARNING } end, { desc = 'Go to previous warning' })
vim.keymap.set('n', ']w', function () v.goto_next { severity = vs.WARNING } end, { desc = 'Go to next warning' })
vim.keymap.set('n', '[i', function () v.goto_prev { severity = vs.INFO } end, { desc = 'Go to previous information' })
vim.keymap.set('n', ']i', function () v.goto_next { severity = vs.INFO } end, { desc = 'Go to next information' })

vim.keymap.set('n', 'cd', function ()
	if vim.b.gitsigns_status_dict and vim.b.gitsigns_status_dict.root then
		vim.cmd.cd(vim.b.gitsigns_status_dict.root)
		return
	end
	local clients = vim.lsp and vim.lsp.get_active_clients() or nil
	local lsp_root = clients and #clients > 0 and clients[1].root_dir or nil
	if lsp_root ~= nil then
		vim.cmd.cd(lsp_root)
		return
	end
	vim.cmd.cd(vim.fs.dirname(vim.fn.bufname()))
end, { desc = '[cd] git root or lsp root or current file directory' })
