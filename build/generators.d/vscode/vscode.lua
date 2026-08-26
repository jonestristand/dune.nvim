-- extras/vscode/dune.nvim - themes/dune-<house>-color-theme.json (from the
-- vscode-theme.json template beside this file), the extension's package.json
-- and README.md, plus verbatim copies of the repo LICENSE and the icon.
-- icon.png is rendered from icon.svg beside this file; after editing the SVG:
--   rsvg-convert -w 256 -h 256 build/generators.d/vscode/icon.svg \
--     -o build/generators.d/vscode/icon.png
-- The README screenshots live in the dune.nvim-site repo (served at
-- dune-nvim.tdjones.ca/vscode/, referenced by absolute URL) so plugin
-- managers don't pull them with every install; after a palette change:
--   python3 build/generators.d/vscode/screenshots/render.py

local BOLD = ',\n        "fontStyle": "bold"'

local function theme(ctx, house, c)
  local m = ctx.meta.houses[house]
  local kw_bold = c.bones or c.kw_bold
  local slots = {
    display = m.display,
    const = c.gilded and c.kw or c.num,
    -- bracket-pair cycle: same colour punctuation wears in this house
    punct = c.ghola_op or (c.gilded and c.gilt_leaf) or c.fg_dim,
    keyword_semantic = kw_bold
        and ('{\n      "foreground": "%s",\n      "bold": true\n    }'):format(c.kw)
      or ('"%s"'):format(c.kw),
    semantic_extra = c.ghola_fn
        and (',\n    "function.defaultLibrary": {\n      "foreground": "%s"\n    }'):format(c.ghola_fn)
      or "",
    line_active = c.gilded and c.kw or c.num,
    cursor = c.gilded and c.kw or c.fg,
    selection_bg = c.gilded and c.burnish or c.overlay,
    inactive_selection_bg = c.gilded and (c.burnish .. "80") or c.surface,
    find_match = c.gilded and c.burnish or (c.num .. "55"),
    find_match_hl = c.gilded and c.burnish or (c.num .. "33"),
    statusbar_fg = c.gilded and c.num or c.fg_dim,
    focus_border = c.gilded and c.num or c.overlay,
    colours_extra = c.gilded
        and (',\n    "editor.findMatchBorder": "%s",\n    "editor.foldBackground": "%s60"'):format(c.kw, c.burnish)
      or "",
    const_bold = c.bones and BOLD or "",
    keyword_bold = kw_bold and BOLD or "",
    tag_bold = c.bones and BOLD or "",
    token_extra = "",
  }

  local function token_block(scopes, hex)
    local quoted = {}
    for _, s in ipairs(scopes) do
      table.insert(quoted, ('        "%s"'):format(s))
    end
    return (',\n    {\n      "scope": [\n%s\n      ],\n      "settings": {\n        "foreground": "%s"\n      }\n    }'):format(
      table.concat(quoted, ",\n"), hex)
  end

  if c.gilded then
    slots.token_extra = token_block({ "keyword.operator" }, c.gilt_leaf)
      .. token_block({ "punctuation.separator", "punctuation.terminator", "meta.brace" }, c.gilt_leaf)
      .. token_block({ "variable.other.constant", "constant.other" }, c.kw)
  elseif c.ghola_fn then
    slots.token_extra = token_block(
        { "meta.function-call entity.name.function", "meta.function-call support.function" }, c.ghola_fn)
      .. token_block({ "support.type.primitive", "support.type.builtin" }, c.ghola_ty)
      .. token_block(
        { "keyword.operator", "punctuation.separator", "punctuation.terminator", "meta.brace" }, c.ghola_op)
  end

  -- terminal.ansi* - semantic slot mapping shared with :terminal and ghostty
  local ansi = require("dune.ansi").colours(c)
  for i = 0, 15 do
    slots["ansi" .. i] = ansi[i]
  end

  local lookup = setmetatable(slots, { __index = c })
  return ctx.subst(ctx.template("vscode-theme.json"), lookup)
end

local function package_json(ctx)
  local entries = {}
  for _, house in ipairs(ctx.meta.house_order) do
    table.insert(entries, ([[      {
        "label": "%s",
        "uiTheme": "vs-dark",
        "path": "./themes/dune-%s-color-theme.json"
      }]]):format(ctx.meta.houses[house].display, house))
  end
  return ([[{
  "name": "dune-nvim",
  "displayName": "Dune.nvim Themes",
  "description": "Four colourschemes — Atreides, Harkonnen, Corrino, and Fremen. There is no fifth theme.",
  "version": "%s",
  "publisher": "jonestristand",
  "license": "MIT",
  "icon": "icon.png",
  "repository": {
    "type": "git",
    "url": "https://github.com/jonestristand/dune.nvim"
  },
  "keywords": [
    "theme",
    "color-theme",
    "dark",
    "dune",
    "atreides",
    "harkonnen",
    "corrino",
    "fremen",
    "tleilaxu"
  ],
  "engines": {
    "vscode": "^1.85.0"
  },
  "categories": [
    "Themes"
  ],
  "contributes": {
    "themes": [
%s
    ]
  }
}]]):format(ctx.meta.version, table.concat(entries, ",\n"))
end

return function(ctx)
  for _, house in ipairs(ctx.meta.house_order) do
    ctx.emit("extras/vscode/dune.nvim/themes/dune-" .. house .. "-color-theme.json",
      theme(ctx, house, ctx.palettes[house]))
  end
  ctx.emit("extras/vscode/dune.nvim/package.json", package_json(ctx))
  ctx.emit("extras/vscode/dune.nvim/README.md",
    ctx.subst(ctx.template("README.md"), ctx.meta))
  ctx.emit("extras/vscode/dune.nvim/LICENSE", ctx.read("LICENSE"))
  ctx.emit("extras/vscode/dune.nvim/icon.png", ctx.template("icon.png"))
end
