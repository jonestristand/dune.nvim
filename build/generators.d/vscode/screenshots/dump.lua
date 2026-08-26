-- Dump palettes + house metadata as JSON for render.py.
--   nvim -l build/generators.d/vscode/screenshots/dump.lua
local script = debug.getinfo(1, "S").source:sub(2)
local here = vim.fn.fnamemodify(script, ":p:h")
local root = vim.fs.dirname(vim.fs.dirname(vim.fs.dirname(vim.fs.dirname(here))))
package.path = table.concat({
  root .. "/lua/?.lua",
  root .. "/build/?.lua",
  package.path,
}, ";")

local meta = require("meta")
-- io.write, not print: nvim -l sends print() to stderr when piped
io.write(vim.json.encode({
  palettes = require("dune.palettes"),
  houses = meta.houses,
  house_order = meta.house_order,
}))
