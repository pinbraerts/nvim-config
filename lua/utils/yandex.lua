vim.filetype.add({
  filename = {
    ["arc-rebase-todo"] = "gitrebase",
  },
})

local M = {}

local home = os.getenv("HOME") or os.getenv("USERPROFILE")
M.root = vim.fs.joinpath(home, "arcadia")

function M.has_arcadia()
  return vim.fs.dir(M.root)() ~= nil
end

function M.inside_arcadia()
  return vim.fn.getcwd():match(M.root) ~= nil
end

function M.join(...)
  return vim.fs.joinpath(M.root, ...)
end

function M.__div(m, a)
  return m.join(a)
end

function M.branch()
  if not home then
    return
  end
  local link = io.open(vim.fs.joinpath(home, ".arc", "store", ".arc", "HEAD")):read()
  return link:match('"(.*)"')
end

M.__index = M
M = setmetatable(M, M)

return M
