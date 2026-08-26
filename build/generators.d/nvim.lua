-- Per-house Neovim boilerplate: colors/dune-<house>.lua entry points and
-- lua/dune-<house>/peacock.lua self-describing peacock modules.

return function(ctx)
  for _, house in ipairs(ctx.meta.house_order) do
    ctx.emit("colors/dune-" .. house .. ".lua",
      ('require("dune").load("%s")\n'):format(house))
    ctx.emit("lua/dune-" .. house .. "/peacock.lua", ([[
-- Self-describing peacock.nvim palette module (see peacock's README).
return {
	palette = require("dune.palettes").%s,
	mapping = require("dune.peacock_mapping"),
}
]]):format(house))
  end
end
