local ok, ft = require("Comment.ft")
if ok and ft then
  ft.set("c", { "// %s", "/* %s */" })
  ft.set("cpp", { "// %s", "/* %s */" })
else
  vim.bo.commentstring = "// %s"
end
