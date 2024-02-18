local p = require 'telescope.previewers'
local u = require 'telescope.utils'

local function remove_preview(socket, id)
	vim.fn.system({
		'ueberzugpp', 'cmd',
		'-s', socket,
		'-a', 'remove',
		'-i', id,
	})
end

local function add_preview(socket, path, x, y, w, h)
	vim.fn.system({
		'ueberzugpp', 'cmd',
		'-s', socket,
		'-a', 'add',
		'-i', path,
		'-f', path,
		'-x', x,
		'-y', y,
		'--max-width', w,
		'--max-height', h,
	})
end

local function cleanup(socket, pid)
	vim.fn.system({ 'ueberzugpp', 'cmd', '-a', 'exit', '-s', socket })
	if vim.v.shell_error ~= 0 then
		vim.loop.pkill(pid)
		vim.fn.delete(socket)
	end
end

local function image_info(path)
	local information = vim.fn.system({
		'exiftool', path,
		'-ImageSize',
		'-Software',
		'-FileType',
		'-Compression',
		'-ColorSpace',
	})
	if vim.v.shell_error ~= 0 then
		return nil
	end
end

return u.make_default_callable(function (opts)
	return p.new {
		setup = function (self)
			local filename = '/tmp/nvim_ueberzugpp_pid'
			vim.fn.system({ 'ueberzugpp', 'layer', '--no-stdin', '--pid-file', filename })
			if vim.v.shell_error ~= 0 then
				return
			end
			local pid_file = io.open(filename, 'r')
			if pid_file == nil then
				return
			end
			local pid = pid_file:read("*l")
			pid_file:close()
			self.socket = '/tmp/ueberzugpp-'..pid..'.socket'
			self.pid = tonumber(pid)
			if not vim.fn.filereadable(self.socket) then
				self.socket = nil
				return
			end
			return self
		end,

		scroll_fn = function (self, direction)
		end,

		teardown = function (self)
			if self.socket == nil then
				return
			end
			cleanup(self.socket, self.pid)
			self.socket = nil
		end,

		preview_fn = function (self, entry, status)
			if self.socket == nil then
				return
			end
			if self.preview_id ~= nil then
				remove_preview(self.socket, self.preview_id)
			end
			local w = vim.fn.winwidth(status.preview_win)
			local h = vim.fn.winheight(status.preview_win)
			local position = vim.fn.win_screenpos(status.preview_win)
			local x = position[2] - 1
			local y = position[1] - 1
			add_preview(self.socket, entry.path, x, y, w, h)
			if vim.v.shell_error == 0 then
				self.preview_id = entry.path
			end
		end,

	}
end, {})
