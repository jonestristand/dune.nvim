-- extras/kde/dune-<house>.colors - KDE Plasma colour schemes, derived from the
-- dune.colors template. Hex colours need to be converted to R,G,B triplets for
-- KDE Plasma

local ansi = require("dune.ansi")

local function rgb(hex)
  return ("%d,%d,%d"):format(
    tonumber(hex:sub(2, 3), 16),
    tonumber(hex:sub(4, 5), 16),
    tonumber(hex:sub(6, 7), 16))
end

-- mix `base` toward `colour` at `amount` (0..1) - hover tint derivation
local function blend(base, colour, amount)
  local br, bg, bb = base:match("#(%x%x)(%x%x)(%x%x)")
  local cr, cg, cb = colour:match("#(%x%x)(%x%x)(%x%x)")
  local mix = function(a, b)
    return math.floor(tonumber(a, 16) * (1 - amount) + tonumber(b, 16) * amount + 0.5)
  end
  return string.format("#%02X%02X%02X", mix(br, cr), mix(bg, cg), mix(bb, cb))
end

-- Generator implementation
return function(ctx)
  for _, house in ipairs(ctx.meta.house_order) do
    local c = ctx.palettes[house]
    local accent = ansi.accent(c)
    local lookup = {
      scheme = "dune-" .. house,
      display = ctx.meta.houses[house].display,
      accent = rgb(accent),
      -- hover is the accent mixed with fg ~= focus (Breeze
      -- distinguishes them; a single accent reads flat on buttons)
      accent_hover = rgb(blend(accent, c.fg, 0.3)),
      selection = rgb(ansi.selection(c)),
    }
    for role, v in pairs(c) do
      if type(v) == "string" and v:match("^#%x%x%x%x%x%x$") then
        lookup[role] = rgb(v)
      end
    end
    ctx.emit("extras/kde/dune-" .. house .. ".colors",
      ctx.subst(ctx.template("dune.colors"), lookup))
  end
end
