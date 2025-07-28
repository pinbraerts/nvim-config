pcall(vim.cmd.source, vim.fs.joinpath(vim.fn.stdpath("config"), ".vimrc"))

vim.o.winborder = "rounded"

vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup("RemoveTrailingWhitespaces", { clear = true }),
  pattern = "*",
  command = [[%s/\s\+$//e]],
})

vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("HighlightTextYank", { clear = true }),
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({
      higroup = "IncSearch",
      timeout = 40,
    })
  end,
})

if vim.fn.executable("python3") ~= 0 then
  vim.g.python3_host_prog = "python3"
end

if vim.fn.executable("python") ~= 0 then
  local version = vim.fn.system({ "python", "--version" }):sub(8, 8)
  if version == "3" then
    vim.g.python3_host_prog = "python"
  elseif version == "2" then
    vim.g.python_host_prog = "python"
  end
end

local lazypath = vim.fs.joinpath(vim.fn.stdpath("data"), "/lazy/lazy.nvim")
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out =
    vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)
vim.keymap.set("n", "<leader>lz", "<cmd>Lazy<cr>", { desc = "Open [L]a[z]y", silent = true })

require("lazy").setup({
  spec = {
    { import = "plugins" },
  },
  change_detection = {
    enabled = true,
    notify = false,
  },
  dev = {
    path = vim.fs.joinpath(os.getenv("HOME") or os.getenv("USERPROFILE"), "src"),
    patterns = {
      "pinbraerts",
    },
  },
})
