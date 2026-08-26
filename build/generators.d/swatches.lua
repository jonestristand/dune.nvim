-- assets/swatches/<HEX>.svg - one tiny swatch per unique colour the
-- README palette tables display
-- Note: does not delete unused swatches if colours change

local SVG = '<svg xmlns="http://www.w3.org/2000/svg" width="32" height="32">'
  .. '<rect width="32" height="32" rx="6" fill="#%s"/></svg>\n'

return function(ctx)
  local seen = {}
  local function swatch(hex)
    local bare = hex:sub(2)
    if not seen[bare] then
      seen[bare] = true
      ctx.emit("assets/swatches/" .. bare .. ".svg", SVG:format(bare))
    end
  end
  for _, house in ipairs(ctx.meta.house_order) do
    local c = ctx.palettes[house]
    local m = ctx.meta.houses[house]
    for _, role in ipairs(ctx.meta.role_order) do
      swatch(c[role])
    end
    for _, role in ipairs(m.extra_roles or {}) do
      swatch(c[role])
    end
    for _, g in ipairs(m.ghola_rows or {}) do
      swatch(g.ui and c.ghola_ui[g.key] or c[g.key])
    end
  end
end
