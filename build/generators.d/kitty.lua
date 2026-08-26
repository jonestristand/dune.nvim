-- extras/kitty/dune-<house>.conf - kitty terminal themes.
-- Slot mapping from lua/dune/ansi.lua.

local ansi = require("dune.ansi")

return function(ctx)
  for _, house in ipairs(ctx.meta.house_order) do
    local c = ctx.palettes[house]
    local m = ctx.meta.houses[house]
    local colours = ansi.colours(c)
    local lines = {
      ("# dune-%s - %s"):format(house, m.ghostty_comment),
      "background " .. c.bg,
      "foreground " .. c.fg,
      "cursor " .. ansi.cursor(c),
      "cursor_text_color " .. c.bg,
      "selection_background " .. ansi.selection(c),
      "selection_foreground " .. c.fg,
      "url_color " .. c.special,
      "active_border_color " .. ansi.accent(c),
      "inactive_border_color " .. c.overlay,
      "active_tab_background " .. c.overlay,
      "active_tab_foreground " .. c.fg,
      "inactive_tab_background " .. c.bg_dim,
      "inactive_tab_foreground " .. c.fg_dim,
    }
    for i = 0, 15 do
      table.insert(lines, ("color%d %s"):format(i, colours[i]))
    end
    table.insert(lines, "")
    ctx.emit("extras/kitty/dune-" .. house .. ".conf", table.concat(lines, "\n"))
  end
end
