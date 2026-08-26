-- extras/alacritty/dune-<house>.toml - Alacritty themes.
-- Slot mapping from lua/dune/ansi.lua.

local ansi = require("dune.ansi")

local NAMES = { "black", "red", "green", "yellow", "blue", "magenta", "cyan", "white" }

return function(ctx)
  for _, house in ipairs(ctx.meta.house_order) do
    local c = ctx.palettes[house]
    local m = ctx.meta.houses[house]
    local colours = ansi.colours(c)
    local lines = {
      ("# dune-%s - %s"):format(house, m.ghostty_comment),
      "",
      "[colors.primary]",
      ('background = "%s"'):format(c.bg),
      ('foreground = "%s"'):format(c.fg),
      "",
      "[colors.cursor]",
      ('text = "%s"'):format(c.bg),
      ('cursor = "%s"'):format(ansi.cursor(c)),
      "",
      "[colors.selection]",
      ('text = "%s"'):format(c.fg),
      ('background = "%s"'):format(ansi.selection(c)),
      "",
      "[colors.normal]",
    }
    for i, name in ipairs(NAMES) do
      table.insert(lines, ('%s = "%s"'):format(name, colours[i - 1]))
    end
    vim.list_extend(lines, { "", "[colors.bright]" })
    for i, name in ipairs(NAMES) do
      table.insert(lines, ('%s = "%s"'):format(name, colours[i + 7]))
    end
    table.insert(lines, "")
    ctx.emit("extras/alacritty/dune-" .. house .. ".toml", table.concat(lines, "\n"))
  end
end
