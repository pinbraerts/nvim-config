local ft = require("filetypes")

local function setup ()
	local d = require 'dap'
	local dui = require 'dap.ui.widgets'
	-- d.set_log_level('trace')
	vim.keymap.set('n', '<leader>b', d.toggle_breakpoint, { desc = 'Toggle breakpoint' })
	vim.keymap.set('n', '<leader>dc', d.continue, { desc = '[D]ebug [c]ontinue' })
	vim.keymap.set('n', '<leader>dC', d.reverse_continue, { desc = '[D]ebug reverse [c]ontinue' })
	vim.keymap.set('n', '<leader>dh', d.step_back, { desc = '[D]ebug step back' })
	vim.keymap.set('n', '<leader>dj', d.run_to_cursor, { desc = '[D]ebug run to cursor' })
	vim.keymap.set('n', '<leader>dn', d.down, { desc = '[D]ebug dow[n]' })
	vim.keymap.set('n', '<leader>dp', d.pause, { desc = '[D]ebug [p]ause' })
	vim.keymap.set('n', '<leader>dq', d.close, { desc = '[D]ebug [q]iut' })
	vim.keymap.set('n', '<leader>dr', d.run, { desc = '[D]ebug [r]un' })
	vim.keymap.set('n', '<leader>du', d.up, { desc = '[D]ebug [u]p' })
	vim.keymap.set('n', '<leader>dx', d.terminate, { desc = '[D]ebug terminate' })
	vim.keymap.set('n', '<leader>j', d.step_over, { desc = 'Step over' })
	vim.keymap.set('n', '<leader>k', d.step_out, { desc = 'Step out' })
	vim.keymap.set('n', '<leader>l', d.step_into, { desc = 'Step into' })

	vim.api.nvim_create_autocmd('FileType', {
		group = vim.api.nvim_create_augroup("dap-repl-autocomplete", { clear = true }),
		pattern = "dap-repl",
		callback = function ()
			require('dap.ext.autocompl').attach()
		end,
	})

	local function lldb_compiling (compiler)
		return {
			type = 'codelldb',
			request = 'launch',
			name = 'Compile and run standalone ("'..compiler..'")',
			cwd = '${fileDirname}',
			stopOnEntry = false,
			program = function ()
				local filename = vim.fs.normalize(vim.api.nvim_buf_get_name(0))
				local executable = filename:gsub('%..*$', '')
				if vim.fn.executable(executable) == 0 or vim.fn.getftime(executable) < vim.fn.getftime(filename) then
					local command = compiler..' '..executable..' '..filename
					print("Compililng: "..command)
					vim.fn.system(command)
				end
				return executable
			end
		}
	end

	d.configurations.cpp = {
		lldb_compiling('clang++ -O0 -g -o')
	}

	d.configurations.c = {
		lldb_compiling('clang -O0 -g -o')
	}

	d.configurations.rust = {
		lldb_compiling('rustc -C opt-level=0 -g -o')
	}

	require('hover.providers.dap')
end

return {

	{
		'mfussenegger/nvim-dap',
		ft = ft.debug,
		config = setup,
		keys = {
			{ '<leader>b', desc = 'Toggle breakpoint' },
			{ '<leader>dc', desc = '[D]ebug [c]ontinue' },
			{ '<leader>dC', desc = '[D]ebug reverse [c]ontinue' },
			{ '<leader>dh', desc = '[D]ebug step back' },
			{ '<leader>dj', desc = '[D]ebug run to cursor' },
			{ '<leader>dn', desc = '[D]ebug dow[n]' },
			{ '<leader>dp', desc = '[D]ebug [p]ause' },
			{ '<leader>dq', desc = '[D]ebug [q]iut' },
			{ '<leader>dr', desc = '[D]ebug [r]un' },
			{ '<leader>du', desc = '[D]ebug [u]p' },
			{ '<leader>dx', desc = '[D]ebug terminate' },
			{ '<leader>j', desc = 'Step over' },
			{ '<leader>k', desc = 'Step out' },
			{ '<leader>l', desc = 'Step into' },
		},
	},

	{
		'rcarriga/nvim-dap-ui',
		dependencies = { 'mfussenegger/nvim-dap', 'nvim-neotest/nvim-nio' },
		keys = { { '<leader>td', desc = '[T]oggle [d]ebug ui' }, },
		config = function ()
			local dapui = require 'dapui'
			dapui.setup()
			vim.keymap.set(
				'n', '<leader>td', dapui.toggle,
				{ desc = "[T]oggle [d]ebug ui" }
			)
		end,
	},

	{
		'mfussenegger/nvim-dap-python',
		dependencies = { 'mfussenegger/nvim-dap' },
		ft = 'python',
		config = function ()
			require('dap-python').setup(vim.fn.executable('python3') and 'python3' or 'python')
		end,
	},

	{
		'leoluz/nvim-dap-go',
		dependencies = { 'mfussenegger/nvim-dap' },
		ft = 'go',
		config = function ()
			require('dap-go').setup()
		end,
	},

	{
		'nvim-telescope/telescope-dap.nvim',
		dependencies = {
			'nvim-telescope/telescope.nvim',
			'mfussenegger/nvim-dap',
		},
		config = function()
			local td = require('telescope').load_extension('dap')
			vim.keymap.set('n', '<leader>db', td.list_breakpoints, { desc = '[L]ist [d]ebug [b]reakpoints' })
			vim.keymap.set('n', '<leader>dd', td.configurations, { desc = '[L]ist [d]ebug [c]onfigurations' })
			vim.keymap.set('n', '<leader>df', td.frames, { desc = '[List] [d]ebug [f]rames' })
			vim.keymap.set('n', '<leader>dv', td.variables, { desc = '[L]ist [d]ebug [v]ariables' })
		end,
		keys = {
			{ '<leader>db', desc = '[L]ist [d]ebug [b]reakpoints' },
			{ '<leader>dd', desc = '[L]ist [d]ebug [c]onfigurations' },
			{ '<leader>df', desc = '[List] [d]ebug [f]rames' },
			{ '<leader>dv', desc = '[L]ist [d]ebug [v]ariables' },
		},
	},

}
