return {
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      attach_to_untracked = true,
      on_attach = function(buffer)
        local map = vim.keymap.set
        local g = require("gitsigns")
        vim.opt_local.signcolumn = "yes"

        map({ "o", "x" }, "ih", g.select_hunk, { desc = "Select hunk movement", buffer = buffer })
        map("n", "<leader>s", g.stage_hunk, { desc = "Git stage hunk", buffer = buffer })
        map("n", "<leader>x", g.reset_hunk, { desc = "Git reset hunk", buffer = buffer })
        map("v", "<leader>s", function()
          g.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, { desc = "Git stage selection", buffer = buffer })
        map("v", "<leader>x", function()
          g.reset_hunk({ vim.fn.line("."), vim.fn.line("v"), buffer = buffer })
        end, { desc = "Git reset selection", buffer = buffer })
        map(
          { "v", "n" },
          "<leader>u",
          g.undo_stage_hunk,
          { desc = "Git unstage hunk", buffer = buffer }
        )
        map("n", "<leader>S", g.stage_buffer, { desc = "Git stage buffer", buffer = buffer })
        map("n", "<leader>X", g.reset_buffer, { desc = "Git reset buffer", buffer = buffer })
        map(
          "n",
          "<leader>U",
          g.reset_buffer_index,
          { desc = "Git unstage buffer", buffer = buffer }
        )
        map("n", "<leader>gd", g.diffthis, { desc = "[G]it [d]iff this", buffer = buffer })
        map(
          "n",
          "<leader>gk",
          g.toggle_current_line_blame,
          { desc = "[G]it toggle blame", buffer = buffer }
        )
        map("n", "<leader>gv", g.preview_hunk, { desc = "[G]it pre[v]iew", buffer = buffer })

        map("n", "<esc>", function()
          for _, id in ipairs(vim.api.nvim_list_wins()) do
            if vim.api.nvim_win_get_config(id).relative ~= "" then
              vim.api.nvim_win_close(id, false)
            end
          end
          vim.cmd.nohls()
        end, { buffer = buffer, desc = "Close relative window" })

        map("n", "]c", function()
          if vim.wo.diff then
            return "]c"
          end
          vim.schedule(function()
            g.next_hunk("next", { preview = true })
          end)
          return "<Ignore>"
        end, { expr = true, buffer = buffer, desc = "Go to next hunk" })
        map("n", "[c", function()
          if vim.wo.diff then
            return "[c"
          end
          vim.schedule(function()
            g.nav_hunk("prev", { preview = true })
          end)
          return "<Ignore>"
        end, { expr = true, buffer = buffer, desc = "Go to previous hunk" })
      end,
    },
    cond = function()
      return vim.system({ "arc", "root" }, { text = true }):wait().code ~= 0
    end,
  },
}
