local function setup()
  local d = require("dap")
  require("hover.providers.dap")
  vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("dap-repl-autocomplete", { clear = true }),
    pattern = "dap-repl",
    callback = function()
      require("dap.ext.autocompl").attach()
    end,
  })

  local m = require("mason-registry")
  if not m.is_installed("codelldb") then
    return
  end

  local r = require("rustaceanvim.config")
  local codelldb_package = m.get_package("codelldb"):get_install_path()
  local codelldb, liblldb
  if vim.fn.has("win32") ~= 0 then
    local extension = vim.fn.join({ codelldb_package, "extension" }, "\\\\")
    codelldb = vim.fn.join({ extension, "adapter", "codelldb.exe" }, "\\\\")
    liblldb = vim.fn.join({ extension, "lldb", "bin", "liblldb.dll" }, "\\\\")
  else
    local extension = vim.fs.joinpath(codelldb_package, "extension")
    codelldb = vim.fs.joinpath(extension, "adapter", "codelldb")
    liblldb = vim.fs.joinpath(
      extension,
      "lldb",
      "lib",
      "liblldb" .. (vim.fn.has("mac") ~= 0 and ".dylib" or ".so")
    )
  end
  d.adapters.codelldb = r.get_codelldb_adapter(codelldb, liblldb)

  local function lldb_compiling(...)
    local a = { ... }
    return {
      type = "codelldb",
      request = "launch",
      name = "Compile and run standalone " .. vim.inspect(a),
      cwd = "${fileDirname}",
      stopOnEntry = false,
      program = function()
        local filename = vim.fs.normalize(vim.api.nvim_buf_get_name(0))
        if vim.bo.modified then
          print("Autosaving", filename)
          vim.cmd.write()
        end
        local index = filename:match(".*%.()") - 2
        local executable = filename:sub(1, index)
        if vim.fn.has("win32") ~= 0 then
          executable = executable .. ".exe"
        end
        if
          vim.fn.executable(executable) == 0
          or vim.fn.getftime(executable) < vim.fn.getftime(filename)
        then
          local args = { unpack(a) }
          if vim.fn.has("linux") then
            table.insert(args, 2, "-stdlib=libc++")
          end
          table.insert(args, executable)
          table.insert(args, filename)
          print("Compililng: ", vim.inspect(args))
          vim.fn.system(args)
        end
        return executable
      end,
    }
  end

  if vim.fn.executable("clang++") then
    d.configurations.cpp = {
      lldb_compiling("clang++", "-O0", "-g", "-o"),
    }
  end

  if vim.fn.executable("clang") then
    d.configurations.c = {
      lldb_compiling("clang", "-O0", "-g", "-o"),
    }
  end

  if vim.fn.executable("rustc") then
    d.configurations.rust = {
      lldb_compiling("rustc", "-C", "opt-level=0", "-g", "-o"),
    }
  end
end

local mock = require("utils.lazy_mock")
local d = mock("dap")

return {

  {
    "mfussenegger/nvim-dap",
    config = setup,
    keys = {
      { "<leader>dc", d.continue(), desc = "[D]ebug [c]ontinue" },
      { "<leader>dC", d.reverse_continue(), desc = "[D]ebug reverse [c]ontinue" },
      { "<leader>dh", d.step_back(), desc = "[D]ebug step back" },
      { "<leader>dj", d.run_to_cursor(), desc = "[D]ebug run to cursor" },
      { "<leader>dn", d.down(), desc = "[D]ebug dow[n]" },
      { "<leader>dp", d.pause(), desc = "[D]ebug [p]ause" },
      { "<leader>dq", d.close(), desc = "[D]ebug [q]iut" },
      { "<leader>dr", d.run(), desc = "[D]ebug [r]un" },
      { "<leader>du", d.up(), desc = "[D]ebug [u]p" },
      { "<leader>dx", d.terminate(), desc = "[D]ebug terminate" },
      { "<leader>b", d.toggle_breakpoint(), desc = "Toggle breakpoint" },
      { "<leader>j", d.step_over(), desc = "Step over" },
      { "<leader>k", d.step_out(), desc = "Step out" },
      { "<leader>l", d.step_into(), desc = "Step into" },
    },
  },

  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    keys = { { "<leader>td", mock("dapui").toggle(), desc = "[T]oggle [d]ebug ui" } },
    config = true,
  },

  {
    "mfussenegger/nvim-dap-python",
    dependencies = { "mfussenegger/nvim-dap" },
    ft = "python",
    config = function()
      require("dap-python").setup(vim.g.python3_host_prog or vim.g.python_host_prog)
    end,
  },

  {
    "leoluz/nvim-dap-go",
    dependencies = { "mfussenegger/nvim-dap" },
    ft = "go",
    config = true,
  },

  {
    "nvim-telescope/telescope-dap.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "mfussenegger/nvim-dap",
    },
    config = function()
      require("telescope").load_extension("dap")
    end,
    keys = {
      {
        "<leader>db",
        "<cmd>Telescope dap list_breakpoints<cr>",
        desc = "[L]ist [d]ebug [b]reakpoints",
      },
      {
        "<leader>dd",
        "<cmd>Telescope dap configurations<cr>",
        desc = "[L]ist [d]ebug [c]onfigurations",
      },
      { "<leader>df", "<cmd>Telescope dap frames<cr>", desc = "[List] [d]ebug [f]rames" },
      { "<leader>dv", "<cmd>Telescope dap variables<cr>", desc = "[L]ist [d]ebug [v]ariables" },
    },
  },
}
