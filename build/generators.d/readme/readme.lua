-- README.md, derived from the README.md template

-- swatch files are emitted by build/generators.d/swatches.lua
local function table_row(name, hex, label)
  return ("| ![](assets/swatches/%s.svg) | %s | `%s` | %s |"):format(
    hex:sub(2), name, hex, label)
end

local function readme_table(ctx, house, c)
  local meta = ctx.meta
  local m = meta.houses[house]
  local rows = { "| | colour | hex | role |", "|:-:|---|---|---|" }
  for _, role in ipairs(meta.role_order) do
    table.insert(rows, table_row(m.names[role], c[role], meta.role_labels[role]))
  end
  for _, role in ipairs(m.extra_roles or {}) do
    table.insert(rows, table_row(m.names[role], c[role], meta.role_labels[role]))
  end
  for _, g in ipairs(m.ghola_rows or {}) do
    local hex = g.ui and c.ghola_ui[g.key] or c[g.key]
    table.insert(rows, table_row(m.names[g.of] .. " ghola", hex, g.label))
  end
  return table.concat(rows, "\n")
end

return function(ctx)
  local lookup = {}
  for _, house in ipairs(ctx.meta.house_order) do
    lookup["palette_" .. house] = readme_table(ctx, house, ctx.palettes[house])
  end
  -- shields.io badge colours using atreides palette
  lookup.badge_spice = ctx.palettes.atreides.kw:sub(2)
  lookup.badge_fn = ctx.palettes.atreides.fn:sub(2)
  lookup.badge_violet = ctx.palettes.atreides.ty:sub(2)
  lookup.badge_melange = ctx.palettes.atreides.num:sub(2)
  lookup.badge_canada = ctx.palettes.atreides.err:sub(2)
  lookup.version = ctx.meta.version
  ctx.emit("README.md", ctx.subst(ctx.template("README.md"), lookup))
end
