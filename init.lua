local config = vim.fn.stdpath('config')
local vimrc = config .. '/../../.vimrc'
if vim.fn.filereadable(vimrc) ~= 0 then
	vim.cmd.source(vimrc)
else
	vimrc = config .. '/../../../.vimrc'
	if vim.fn.filereadable(vimrc) ~= 0 then
		vim.cmd.source(vimrc)
	end
end

require 'setup.plugins'
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
