local function config()
  local augend = require("dial.augend")

  local Bool = augend.constant.new({
    elements = { "True", "False" },
    word = true,
    cyclic = true,
  })

  local and_or = augend.constant.new({
    elements = { "and", "or" },
    word = true,
    cyclic = true,
  })

  local month = augend.constant.new({
    elements = {
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December",
    },
    word = true,
    cyclic = true,
  })

  local weekday = augend.constant.new({
    elements = {
      "Sunday",
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
    },
    word = true,
    cyclic = true,
  })

  local month_ru = augend.constant.new({
    elements = {
      "Январь",
      "Февраль",
      "Март",
      "Апрель",
      "Май",
      "Июнь",
      "Июль",
      "Август",
      "Сентябрь",
      "Октябрь",
      "Ноябрь",
      "Декабрь",
    },
    word = true,
    cyclic = true,
  })

  local weekday_ru = augend.constant.new({
    elements = {
      "Понедельник",
      "Вторник",
      "Среда",
      "Четверг",
      "Пятница",
      "Суббота",
      "Воскресенье",
    },
    word = true,
    cyclic = true,
  })

  require("dial.config").augends:register_group({
    default = {
      augend.integer.alias.decimal_int,
      augend.integer.alias.hex,
      augend.integer.alias.binary,
      augend.integer.alias.octal,
      augend.date.alias["%d.%m.%Y"],
      augend.constant.alias.bool,
      Bool,
      and_or,
      month,
      weekday,
      month_ru,
      weekday_ru,
      augend.hexcolor.new({
        case = "lower",
      }),
      augend.semver.new({}),
    },
    visual = {
      augend.paren.new({
        patterns = { { "'", "'" }, { '"', '"' } },
        nested = false,
        escape_char = [[\]],
        cyclic = true,
      }),
    },
  })
  local dial_map = require("dial.map")
  local function manipulate(direction, mode)
    return function()
      dial_map.manipulate(direction, mode)
    end
  end
  vim.keymap.set("n", "<C-a>", manipulate("increment", "normal"), { desc = "increment" })
  vim.keymap.set("n", "<C-x>", manipulate("decrement", "normal"), { desc = "decrement" })
  vim.keymap.set("n", "g<C-a>", manipulate("increment", "gnormal"), { desc = "increment" })
  vim.keymap.set("n", "g<C-x>", manipulate("decrement", "gnormal"), { desc = "decrement" })
  vim.keymap.set("v", "<C-a>", manipulate("increment", "visual"), { desc = "increment" })
  vim.keymap.set("v", "<C-x>", manipulate("decrement", "visual"), { desc = "decrement" })
  vim.keymap.set("v", "g<C-a>", manipulate("increment", "gvisual"), { desc = "increment" })
  vim.keymap.set("v", "g<C-x>", manipulate("decrement", "gvisual"), { desc = "decrement" })
end

return {

  {
    "monaqa/dial.nvim",
    config = config,
    keys = {
      { "<C-a>", mode = { "n", "v" } },
      { "<C-x>", mode = { "n", "v" } },
      { "g<C-a>", mode = { "n", "v" } },
      { "g<C-x>", mode = { "n", "v" } },
    },
  },
}
