local config = vim.fn.stdpath('config')
local vimrc = config .. '/../../.vimrc'
if vim.fn.filereadable(vimrc) ~= 0 then
	vim.cmd.source(vimrc)
end
require 'setup.plugins'
require 'setup.style'
require 'setup.remap'
require 'setup.terminal'
vim.o.cmdheight = 0

