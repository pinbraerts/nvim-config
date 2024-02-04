vim.fn.sign_define('DapBreakpoint'		   , { text = '🔴', texhl = 'DapBreakpoint' })
vim.fn.sign_define('DapBreakpointCondition', { text = '🟠', texhl = 'DapBreakpoint' })
vim.fn.sign_define('DapBreakpointRejected' , { text = '⭕', texhl = 'DapBreakpoint' })
vim.fn.sign_define('DapLogPoint'		   , { text = '🟣', texhl = 'DapLogPoint'	})
vim.fn.sign_define('DapStopped'			   , { text = '🔹', texhl = 'DapStopped'	})
vim.fn.sign_define('DiagnosticSignError'   , { text = '❗', texhl = 'DiagnosticSignError' })
vim.fn.sign_define('DiagnosticSignWarn'    , { text = '⚠️ ', texhl = 'DiagnosticSignWarn'  })
vim.fn.sign_define('DiagnosticSignInfo'    , { text = '🔍', texhl = 'DiagnosticSignInfo'  })
vim.fn.sign_define('DiagnosticSignHint'    , { text = '💡', texhl = 'DiagnosticSignHint'  })
-- 📌

if vim.g.neovide then
	vim.g.neovide_cursor_vfx_mode = 'ripple'
	vim.g.neovide_cursor_animate_command_line = false
	vim.o.guifont = 'FiraCode Nerd Font Mono:h14'
end

vim.cmd.colorscheme('nightfox')
