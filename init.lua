local function test_directory(dir)
	local vimrc = dir .. '/.vimrc'
	if vim.fn.filereadable(vimrc) == 0 then
		return false
	end
	local ok, _ = pcall(vim.cmd.source, vimrc)
	return ok
end

local directories = {
	vim.fn.stdpath('config') or '',
	os.getenv('XDG_CONFIG_HOME') or '',
	os.getenv('HOME') or '',
	os.getenv('USERPROFILE') or '',
}

for _, directory in ipairs(directories) do
	if test_directory(directory) then
		break
	end
end

vim.api.nvim_create_autocmd("BufWritePre", {
	group = vim.api.nvim_create_augroup("RemoveTrailingWhitespaces", { clear = true }),
	pattern = "*",
	command = [[%s/\s\+$//e]],
})

vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("HighlightTextYank", { clear = true }),
	pattern = "*",
	callback = function ()
		vim.highlight.on_yank {
			higroup = "IncSearch",
			timeout = 40,
		}
	end
})

if vim.fn.executable('python3') ~= 0 then
	vim.g.python3_host_prog = 'python3'
end

if vim.fn.executable('python') ~= 0 then
	if vim.fn.has('win32') ~= 0 then
		vim.g.python3_host_prog = 'python'
	else
		vim.g.python_host_prog = 'python'
	end
end

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
vim.keymap.set('n', '<leader>lz', '<cmd>Lazy<cr>', { desc = 'Open [L]a[z]y', silent = true })
require 'lazy'.setup("plugins")

require 'setup.style'
require 'setup.remap'
require 'setup.terminal'

pcall(require, 'local')
if vim.fn.has('win32') ~= 0 then
	pcall(require, 'windows')
end
if vim.fn.has('linux') ~= 0 then
	pcall(require, 'linux')
end
