-- extras/konsole/dune-<house>.colorscheme - Konsole terminal colour schemes,
-- Konsole wants decimal R,G,B and Faint variants; Faint is each colour lerp'd 
-- toward bg.
-- Slot mapping from lua/dune/ansi.lua.

local ansi = require("dune.ansi")

local function rgb(hex)
  return ("%d,%d,%d"):format(
    tonumber(hex:sub(2, 3), 16),
    tonumber(hex:sub(4, 5), 16),
    tonumber(hex:sub(6, 7), 16))
end

-- mix `base` toward `colour` at `amount` (0..1)
local function blend(base, colour, amount)
  local br, bg, bb = base:match("#(%x%x)(%x%x)(%x%x)")
  local cr, cg, cb = colour:match("#(%x%x)(%x%x)(%x%x)")
  local mix = function(a, b)
    return math.floor(tonumber(a, 16) * (1 - amount) + tonumber(b, 16) * amount + 0.5)
  end
  return string.format("#%02X%02X%02X", mix(br, cr), mix(bg, cg), mix(bb, cb))
end

return function(ctx)
  for _, house in ipairs(ctx.meta.house_order) do
    local c = ctx.palettes[house]
    local m = ctx.meta.houses[house]
    local colours = ansi.colours(c)
    local lines = {}
    local function section(name, hex)
      vim.list_extend(lines, { "[" .. name .. "]", "Color=" .. rgb(hex), "" })
    end
    section("Background", c.bg)
    section("BackgroundFaint", c.bg_dim)
    section("BackgroundIntense", c.surface)
    for i = 0, 7 do
      section(("Color%d"):format(i), colours[i])
      section(("Color%dFaint"):format(i), blend(colours[i], c.bg, 0.35))
      section(("Color%dIntense"):format(i), colours[i + 8])
    end
    section("Foreground", c.fg)
    section("ForegroundFaint", c.fg_dim)
    section("ForegroundIntense", c.fg)
    vim.list_extend(lines, {
      "[General]",
      "Description=" .. m.display,
      "Opacity=1",
      "Wallpaper=",
      "",
    })
    ctx.emit("extras/konsole/dune-" .. house .. ".colorscheme", table.concat(lines, "\n"))
  end
end
