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

local local_file = config .. '/lua/local.lua'
if vim.fn.filereadable(local_file) ~= 0 then
	vim.cmd.source(local_file)
end

local local_setup = config .. '/lua/local'
if vim.fn.isdirectory(local_setup) ~= 0 then
	local files = vim.fn.glob(local_setup .. '/*.lua')
	for file in string.gmatch(files, "([^\n]+)") do
		vim.cmd.source(file)
	end
end
