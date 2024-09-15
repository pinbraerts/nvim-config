local meta = {
  __index = function(self, name)
    return function(...)
      local args = { ... }
      return function()
        require(self.name)[name](unpack(args))
      end
    end
  end,
}

return function(name)
  return setmetatable({ name = name }, meta)
end
