-- extras/windows-terminal/dune-<house>.json - Windows Terminal colour
-- schemes (paste into the "schemes" array of settings.json).
-- Slot mapping from lua/dune/ansi.lua.

local ansi = require("dune.ansi")

-- Windows Terminal names the magenta slots "purple"
local NAMES = { "black", "red", "green", "yellow", "blue", "purple", "cyan", "white" }

return function(ctx)
  for _, house in ipairs(ctx.meta.house_order) do
    local c = ctx.palettes[house]
    local colours = ansi.colours(c)
    local lines = {
      "{",
      ('  "name": "dune-%s",'):format(house),
      ('  "background": "%s",'):format(c.bg),
      ('  "foreground": "%s",'):format(c.fg),
      ('  "cursorColor": "%s",'):format(ansi.cursor(c)),
      ('  "selectionBackground": "%s",'):format(ansi.selection(c)),
    }
    for i, name in ipairs(NAMES) do
      table.insert(lines, ('  "%s": "%s",'):format(name, colours[i - 1]))
    end
    for i, name in ipairs(NAMES) do
      local bright = "bright" .. name:sub(1, 1):upper() .. name:sub(2)
      local comma = i < #NAMES and "," or ""
      table.insert(lines, ('  "%s": "%s"%s'):format(bright, colours[i + 7], comma))
    end
    vim.list_extend(lines, { "}", "" })
    ctx.emit("extras/windows-terminal/dune-" .. house .. ".json", table.concat(lines, "\n"))
  end
end
