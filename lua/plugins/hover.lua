return {
	"lewis6991/hover.nvim",
	config = function()
		local hover = require("hover")
		hover.setup {
			init = function()
				-- Require providers
				require("hover.providers.lsp")
				require('hover.providers.gh')
				require('hover.providers.gh_user')
				-- require('hover.providers.jira')
				require('hover.providers.man')
				-- require('hover.providers.dictionary')
			end,
			preview_opts = {
				border = 'single',
				focusable = true,
				focus = true,
			},
			-- Whether the contents of a currently open hover window should be moved
			-- to a :h preview-window when pressing the hover keymap.
			preview_window = false,
			title = true,
			mouse_providers = {
				'LSP'
			},
			mouse_delay = 1000
		}

		vim.keymap.set("n", "K", hover.hover, { desc = "hover.nvim" })
		vim.keymap.set("n", "gK", hover.hover_select, { desc = "hover.nvim (select)" })
		vim.keymap.set("n", "<C-p>", function() hover.hover_switch("previous") end, { desc = "hover.nvim (previous source)" })
		vim.keymap.set("n", "<C-n>", function() hover.hover_switch("next") end, { desc = "hover.nvim (next source)" })

		-- vim.keymap.set('n', '<MouseMove>', require('hover').hover_mouse, { desc = "hover.nvim (mouse)" })
		-- vim.o.mousemoveevent = true
	end,
	keys = {
		{ "K", desc = "hover.nvim" },
		{ "gK", desc = "hover.nvim (select)" },
		{ "<C-p>", desc = "hover.nvim (previous source)" },
		{ "<C-n>", desc = "hover.nvim (next source)" },
	},
}
