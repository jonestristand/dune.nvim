-- extras/iterm2/dune-<house>.itermcolors - iTerm2 colour presets (XML plist,
-- sRGB components as 0..1 reals, keys alphabetical like iTerm's own export).
-- Slot mapping from lua/dune/ansi.lua.

local ansi = require("dune.ansi")

local function real(byte)
  return ("%.6f"):format(tonumber(byte, 16) / 255)
end

local function colour(key, hex)
  local r, g, b = hex:match("#(%x%x)(%x%x)(%x%x)")
  return ("\t<key>%s</key>\n\t<dict>\n"
      .. "\t\t<key>Alpha Component</key>\n\t\t<real>1</real>\n"
      .. "\t\t<key>Blue Component</key>\n\t\t<real>%s</real>\n"
      .. "\t\t<key>Color Space</key>\n\t\t<string>sRGB</string>\n"
      .. "\t\t<key>Green Component</key>\n\t\t<real>%s</real>\n"
      .. "\t\t<key>Red Component</key>\n\t\t<real>%s</real>\n"
      .. "\t</dict>"):format(key, real(b), real(g), real(r))
end

return function(ctx)
  for _, house in ipairs(ctx.meta.house_order) do
    local c = ctx.palettes[house]
    local m = ctx.meta.houses[house]
    local colours = ansi.colours(c)
    local lines = {
      '<?xml version="1.0" encoding="UTF-8"?>',
      '<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">',
      ("<!-- dune-%s - %s -->"):format(house, m.ghostty_comment),
      '<plist version="1.0">',
      "<dict>",
    }
    for i = 0, 15 do
      table.insert(lines, colour(("Ansi %d Color"):format(i), colours[i]))
    end
    table.insert(lines, colour("Background Color", c.bg))
    table.insert(lines, colour("Bold Color", c.fg))
    table.insert(lines, colour("Cursor Color", ansi.cursor(c)))
    table.insert(lines, colour("Cursor Text Color", c.bg))
    table.insert(lines, colour("Foreground Color", c.fg))
    table.insert(lines, colour("Link Color", c.fn))
    table.insert(lines, colour("Selected Text Color", c.fg))
    table.insert(lines, colour("Selection Color", ansi.selection(c)))
    vim.list_extend(lines, { "</dict>", "</plist>", "" })
    ctx.emit("extras/iterm2/dune-" .. house .. ".itermcolors", table.concat(lines, "\n"))
  end
end
