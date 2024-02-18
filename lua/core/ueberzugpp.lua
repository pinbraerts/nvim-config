local p = require 'telescope.previewers'
local u = require 'telescope.utils'
local pu = require 'telescope.previewers.utils'
local c = require("telescope.config").values

local function cleanup(socket, pid)
	vim.fn.system({ 'ueberzugpp', 'cmd', '-a', 'exit', '-s', socket })
	if vim.v.shell_error ~= 0 then
		vim.loop.pkill(pid)
		vim.fn.delete(socket)
	end
end

local function get_file_extension(filename)
	local array = vim.split(filename, '.', { plain = true })
	return array[#array]
end

local defaults = {
	image_filetypes = { 'jpg', 'jpeg', 'png', 'svg', },
	title = 'File Preview',
	cmd = 'ueberzug',
}

function defaults.exiftool (filename)
	return {
		'exiftool',
		'-ImageSize',
		'-Software',
		'-FileType',
		'-Compression',
		'-ColorSpace',
		filename,
	}
end

function defaults.add (cmd, socket, path, id, x, y, w, h)
	return {
		cmd, 'cmd',
		'-s', socket,
		'-a', 'add',
		'-i', id,
		'-f', path,
		'-x', x,
		'-y', y,
		'--max-width', w,
		'--max-height', h,
	}
end

function defaults.remove (cmd, socket, id)
	return {
		cmd, 'cmd',
		'-s', socket,
		'-a', 'remove',
		'-i', id,
	}
end

function defaults.start (cmd, filename)
	return {
		cmd, 'layer',
		'--no-stdin', '--pid-file',
		filename,
	}
end

return u.make_default_callable(function (opts)
	opts = vim.tbl_extend("keep", opts or { }, defaults)
	return p.new_buffer_previewer {
		title = opts.title,

		setup = function (self)
			local filename = '/tmp/nvim_ueberzugpp_pid'
			vim.fn.system(opts.start(opts.cmd, filename))
			if vim.v.shell_error ~= 0 then
				return { }
			end
			local pid_file = io.open(filename, 'r')
			if pid_file == nil then
				return { }
			end
			local pid = pid_file:read("*l")
			pid_file:close()
			vim.fn.delete(filename)
			self.socket = '/tmp/ueberzugpp-'..pid..'.socket'
			self.pid = tonumber(pid)
			if not vim.fn.filereadable(self.socket) then
				self.socket = nil
				return { }
			end
			return self
		end,

		teardown = function (self)
			if self.socket == nil then
				return
			end
			cleanup(self.socket, self.pid)
			self.socket = nil
		end,

		define_preview = function (self, entry, status)
			local w = vim.fn.winwidth(self.state.winid)
			local h = vim.fn.winheight(self.state.winid) - 5
			local position = vim.fn.win_screenpos(status.preview_win)
			local x = position[2] - 1
			local y = position[1] - 1 + 5

			if self.preview_id ~= nil then
				pu.job_maker(
					opts.remove(opts.cmd, self.socket, self.preview_id),
					self.state.bufnr,
					{ mode = 'append' }
				)
			end
			self.preview_id = entry.path..x..y..w..h
			local filetype = get_file_extension(entry.path)
			if filetype == nil or #filetype == 0 then
				return { }
			end

			-- fallback to default buffer preview
			if not vim.tbl_contains(opts.image_filetypes, filetype) then
				return c.buffer_previewer_maker(entry.path, self.state.bufnr, {
					bufname = self.state.bufname,
					winid = self.state.winid,
				})
			end

			-- local info = vim.fn.systemlist(opts.exiftool(entry.path), self.state.bufnr)
			-- vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, true, info)
			pu.job_maker(opts.exiftool(entry.path), self.state.bufnr)

			pu.job_maker(
				opts.add(opts.cmd, self.socket, entry.path, self.preview_id, x, y, w, h),
				self.state.bufnr,
				{ mode = 'append' }
			)
		end,

	}
end, {})
