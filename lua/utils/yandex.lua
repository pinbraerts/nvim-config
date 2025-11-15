vim.filetype.add({
  filename = {
    ["arc-rebase-todo"] = "gitrebase",
  },
})

local M = {}

local _status = vim.system({ "arc", "root" }, { text = true }):wait()
M.arcadia = nil
if _status.code == 0 then
  M.arcadia = vim.trim(_status.stdout)
end

function M.inside_arcadia()
  return M.arcadia and vim.fn.getcwd():match(M.arcadia)
end

function M.inside_taxi()
  return M.arcadia and vim.fn.getcwd():match(M / "taxi")
end

function M.branch()
  local info = vim.system({ "arc", "info", "--json" }, { text = true }):wait()
  if info.code ~= 0 then
    return
  end
  local info_json = vim.json.decode(info.stdout)
  return info_json.branch
end

M.__index = M
M = setmetatable(M, {
  __div = function(m, o)
    return vim.fs.joinpath(m.arcadia, o)
  end,
})

return M
