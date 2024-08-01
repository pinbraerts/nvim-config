local path = vim.fn.fnamemodify(vim.fn.expand("<sfile>"), ":p:h") .. "/"

pcall(vim.cmd.source, path .. ".vimrc")

-- vim.api.nvim_create_autocmd("BufWritePre", {
--   group = vim.api.nvim_create_augroup("RemoveTrailingWhitespaces", { clear = true }),
--   pattern = "*",
--   command = [[%s/\s\+$//e]],
-- })

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

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
vim.keymap.set("n", "<leader>lz", "<cmd>Lazy<cr>", { desc = "Open [L]a[z]y", silent = true })

local spec = {
  { import = "plugins" },
}

if
  vim.fn.isdirectory(path .. "lua/local") ~= 0
  or vim.fn.filereadable(path .. "lua/local.lua") ~= 0
then
  table.insert(spec, { import = "local" })
end

require("lazy").setup({
  spec = spec,
  change_detection = {
    enabled = true,
    notify = false,
  },
})
