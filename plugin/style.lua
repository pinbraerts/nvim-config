vim.diagnostic.config({
  signs = {
    active = true,
    text = {
      ERROR = "❗",
      WARN = "⚠️",
      INFO = "🔍",
      HINT = "💡",
    },
  },
  virtual_text = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})

-- DAP signs (still use sign_define)
vim.fn.sign_define("DapBreakpoint", { text = "🔴", texhl = "DapBreakpoint" })
vim.fn.sign_define("DapBreakpointCondition", { text = "🟠", texhl = "DapBreakpoint" })
vim.fn.sign_define("DapBreakpointRejected", { text = "⭕", texhl = "DapBreakpoint" })
vim.fn.sign_define("DapLogPoint", { text = "🟣", texhl = "DapLogPoint" })
vim.fn.sign_define("DapStopped", { text = "🔹", texhl = "DapStopped" })
-- 📌

if vim.g.neovide then
  vim.g.neovide_cursor_vfx_mode = "ripple"
  vim.g.neovide_cursor_animate_command_line = false
  vim.o.guifont = "FiraCode Nerd Font Mono:h14"
end
