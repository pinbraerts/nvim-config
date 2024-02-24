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
