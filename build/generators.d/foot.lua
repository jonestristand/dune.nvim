-- extras/foot/dune-<house>.ini - foot terminal themes (include= fragments).
-- foot wants bare hex (no '#'). 
-- Slot mapping from lua/dune/ansi.lua.

local ansi = require("dune.ansi")

local function bare(hex)
  return hex:sub(2)
end

return function(ctx)
  for _, house in ipairs(ctx.meta.house_order) do
    local c = ctx.palettes[house]
    local m = ctx.meta.houses[house]
    local colours = ansi.colours(c)
    local lines = {
      ("# dune-%s - %s"):format(house, m.ghostty_comment),
      "[cursor]",
      ("color=%s %s"):format(bare(c.bg), bare(ansi.cursor(c))),
      "",
      "[colors]",
      "background=" .. bare(c.bg),
      "foreground=" .. bare(c.fg),
      "selection-background=" .. bare(ansi.selection(c)),
      "selection-foreground=" .. bare(c.fg),
      "urls=" .. bare(c.special),
    }
    for i = 0, 7 do
      table.insert(lines, ("regular%d=%s"):format(i, bare(colours[i])))
    end
    for i = 8, 15 do
      table.insert(lines, ("bright%d=%s"):format(i - 8, bare(colours[i])))
    end
    table.insert(lines, "")
    ctx.emit("extras/foot/dune-" .. house .. ".ini", table.concat(lines, "\n"))
  end
end
