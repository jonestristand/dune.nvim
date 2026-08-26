-- extras/gnome-terminal/{install,uninstall}.py - GNOME Terminal themes live in 
-- dconf, so create an install and uninstall script that uses gsettings to add 
-- the theme. The per-house UUIDs are fixed in build/meta.lua, so installing is 
-- idempotent and uninstall removes the theme fully (not just one version of it)

local ansi = require("dune.ansi")

return function(ctx)
    local profiles, uuid_map = {}, {}
    for _, house in ipairs(ctx.meta.house_order) do
        local c = ctx.palettes[house]
        local m = ctx.meta.houses[house]
        local colours = ansi.colours(c)
        local pal = {}
        for i = 0, 15 do
            pal[i + 1] = ('"%s"'):format(colours[i])
        end
        table.insert(uuid_map, ('    "dune-%s": "%s",'):format(house, m.gnome_uuid))
        table.insert(profiles,
            table.concat({('    "dune-%s": {'):format(house), ('        "uuid": "%s",'):format(m.gnome_uuid),
                          ('        "display": "%s",'):format(m.display), ('        "bg": "%s",'):format(c.bg),
                          ('        "fg": "%s",'):format(c.fg), ('        "cursor": "%s",'):format(ansi.cursor(c)),
                          ('        "selection": "%s",'):format(ansi.selection(c)),
                          "        \"palette\": [" .. table.concat(pal, ", ") .. "],", "    },"}, "\n"))
    end
    local lookup = {
        profiles = table.concat(profiles, "\n"),
        uuid_map = table.concat(uuid_map, "\n"),
        version = ctx.meta.version
    }
    ctx.emit("extras/gnome-terminal/install.py", ctx.subst(ctx.template("install.py"), lookup))
    ctx.emit("extras/gnome-terminal/uninstall.py", ctx.subst(ctx.template("uninstall.py"), lookup))
end
