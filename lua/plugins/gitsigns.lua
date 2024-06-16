local function setup()
	local g = require 'gitsigns'
	vim.keymap.set({ 'o', 'x' }, 'ih', g.select_hunk, { desc = 'Select hunk movement' })
	vim.keymap.set('n', '<leader>s', g.stage_hunk, { desc = 'Git stage hunk' })
	vim.keymap.set('n', '<leader>x', g.reset_hunk, { desc = 'Git reset hunk' })
	vim.keymap.set('v', '<leader>s', function() g.stage_hunk { vim.fn.line '.', vim.fn.line 'v' } end, { desc = 'Git stage selection' })
	vim.keymap.set('v', '<leader>x', function() g.reset_hunk { vim.fn.line '.', vim.fn.line 'v' } end, { desc = 'Git reset selection' })
	vim.keymap.set({ 'v', 'n' }, '<leader>u', g.undo_stage_hunk, { desc = 'Git unstage hunk' })
	vim.keymap.set('n', '<leader>S', g.stage_buffer, { desc = 'Git stage buffer' })
	vim.keymap.set('n', '<leader>X', g.reset_buffer, { desc = 'Git reset buffer' })
	vim.keymap.set('n', '<leader>U', g.reset_buffer_index, { desc = 'Git unstage buffer' })
	vim.keymap.set('n', '<leader>gd', g.diffthis, { desc = '[G]it [d]iff this' })
	vim.keymap.set('n', '<leader>gk', g.toggle_current_line_blame, { desc = '[G]it toggle blame' })
	vim.keymap.set('n', '<leader>gv', g.preview_hunk, { desc = '[G]it pre[v]iew' })

	g.setup {
		on_attach = function(buffer)
			vim.opt_local.signcolumn = 'yes'

			vim.keymap.set('n', '<esc>', function ()
				for _, id in ipairs(vim.api.nvim_list_wins()) do
					if vim.api.nvim_win_get_config(id).relative ~= "" then
						vim.api.nvim_win_close(id, false)
					end
				end
				vim.cmd.nohls()
				end, { buffer = buffer, desc = 'Close relative window' })

			vim.keymap.set('n', ']c', function()
				if vim.wo.diff then return ']c' end
				vim.schedule(function ()
					g.next_hunk { preview = true }
				end)
				return '<Ignore>'
				end, { expr = true, buffer = buffer, desc = 'Go to next hunk' })
			vim.keymap.set('n', '[c', function()
				if vim.wo.diff then return '[c' end
				vim.schedule(function ()
					g.prev_hunk { preview = true }
				end)
				return '<Ignore>'
				end, { expr = true, buffer = buffer, desc = 'Go to previous hunk' })
		end
	}
end

return {

	{
		'lewis6991/gitsigns.nvim',
		config = setup,
	},


}
