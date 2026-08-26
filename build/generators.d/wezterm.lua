-- extras/wezterm/dune-<house>.toml - WezTerm colour schemes
-- (drop into ~/.config/wezterm/colors/, select with color_scheme).
-- Slot mapping from lua/dune/ansi.lua.

local ansi = require("dune.ansi")

local function list(colours, from, to)
  local out = {}
  for i = from, to do
    table.insert(out, ('  "%s",'):format(colours[i]))
  end
  return out
end

return function(ctx)
  for _, house in ipairs(ctx.meta.house_order) do
    local c = ctx.palettes[house]
    local m = ctx.meta.houses[house]
    local colours = ansi.colours(c)
    local lines = {
      ("# dune-%s - %s"):format(house, m.ghostty_comment),
      "[colors]",
      ('background = "%s"'):format(c.bg),
      ('foreground = "%s"'):format(c.fg),
      ('cursor_bg = "%s"'):format(ansi.cursor(c)),
      ('cursor_fg = "%s"'):format(c.bg),
      ('cursor_border = "%s"'):format(ansi.cursor(c)),
      ('selection_bg = "%s"'):format(ansi.selection(c)),
      ('selection_fg = "%s"'):format(c.fg),
      "ansi = [",
    }
    vim.list_extend(lines, list(colours, 0, 7))
    table.insert(lines, "]")
    table.insert(lines, "brights = [")
    vim.list_extend(lines, list(colours, 8, 15))
    vim.list_extend(lines, {
      "]",
      "",
      "[metadata]",
      ('name = "dune-%s"'):format(house),
      "",
    })
    ctx.emit("extras/wezterm/dune-" .. house .. ".toml", table.concat(lines, "\n"))
  end
end
