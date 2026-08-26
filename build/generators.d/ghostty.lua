-- extras/ghostty/dune-<house> - Ghostty terminal themes.
-- Slot mapping from lua/dune/ansi.lua.

local ansi = require("dune.ansi")

return function(ctx)
  for _, house in ipairs(ctx.meta.house_order) do
    local c = ctx.palettes[house]
    local m = ctx.meta.houses[house]
    local colours = ansi.colours(c)
    local lines = { ("# dune-%s - %s"):format(house, m.ghostty_comment) }
    for i = 0, 15 do
      table.insert(lines, ("palette = %d=%s"):format(i, colours[i]))
    end
    vim.list_extend(lines, {
      "background = " .. c.bg,
      "foreground = " .. c.fg,
      "cursor-color = " .. ansi.cursor(c),
      "cursor-text = " .. c.bg,
      "selection-background = " .. ansi.selection(c),
      "selection-foreground = " .. c.fg,
      "",
    })
    ctx.emit("extras/ghostty/dune-" .. house, table.concat(lines, "\n"))
  end
end
