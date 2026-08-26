-- Regenerates every derived artifact from lua/dune/palettes.lua.
--
--   nvim -l build/generate.lua          write anything that is out of date
--   nvim -l build/generate.lua --check  exit 1 if anything is out of date
--
-- Each extras/ target lives in build/generators.d/, as either
--   <target>.lua            a generator with no templates, or
--   <target>/<target>.lua   a generator plus its template files beside it.
-- A generator is a module returning `function(ctx)` that emits its files
-- through ctx. This driver runs every entry in that directory, so adding a
-- target (KDE, kitty, tmux, ...) is just dropping a new one in the folder.
--
-- ctx:
--   palettes             lua/dune/palettes.lua (colours)
--   meta                 build/meta.lua (names, taglines, doc labels),
--                        plus meta.version from the VERSION file
--   read(relpath)        read a file, relative to the repo root
--   template(name)       read a template from the generator's own directory
--                        (directory-style generators only)
--   emit(relpath, s)     write s to relpath if changed (or record it stale
--                        under --check)
--   subst(template, t)   expand ${token} / ${token.AA} from lookup table

local script = debug.getinfo(1, "S").source:sub(2)
local root = vim.fs.dirname(vim.fs.dirname(vim.fn.fnamemodify(script, ":p")))
package.path = table.concat({
  root .. "/lua/?.lua",
  root .. "/build/?.lua",
  package.path,
}, ";")

local check = arg[1] == "--check"
local stale, wrote = {}, {}

local ctx = {
  palettes = require("dune.palettes"),
  meta = require("meta"),
}

function ctx.read(relpath)
  local f = assert(io.open(root .. "/" .. relpath, "r"), "missing " .. relpath)
  local s = f:read("*a")
  f:close()
  return s
end

ctx.meta.version = vim.trim(ctx.read("VERSION"))

function ctx.emit(relpath, content)
  local path = root .. "/" .. relpath
  local f = io.open(path, "r")
  local current = f and f:read("*a") or nil
  if f then f:close() end
  if current == content then return end
  if check then
    table.insert(stale, relpath)
  else
    vim.fn.mkdir(vim.fs.dirname(path), "p")
    local out = assert(io.open(path, "w"))
    out:write(content)
    out:close()
    table.insert(wrote, relpath)
  end
end

-- ${token} substitution; tokens are `name` or `name.AA` (two-digit alpha).
-- Anything ${...} that survives both passes is malformed and fails the build.
function ctx.subst(template, lookup)
  local function resolve(name)
    return assert(lookup[name], "unknown template token: ${" .. name .. "}")
  end
  local out = template
    :gsub("%${([%w_]+)%.([0-9A-Fa-f][0-9A-Fa-f])}",
      function(name, alpha) return resolve(name) .. alpha end)
    :gsub("%${([%w_]+)}", resolve)
  local leftover = out:match("%${[^}\n]*}?")
  if leftover then
    error("malformed template token: " .. leftover)
  end
  return out
end

-- run -------------------------------------------------------------------

local entries = {}
for name, kind in vim.fs.dir(root .. "/build/generators.d") do
  if kind == "file" and name:match("%.lua$") then
    table.insert(entries, { name = name:sub(1, -5), script = name })
  elseif kind == "directory" then
    table.insert(entries, { name = name, script = name .. "/" .. name .. ".lua", dir = name })
  end
end
table.sort(entries, function(a, b) return a.name < b.name end)
assert(#entries > 0, "no generators found in build/generators.d/")

for _, e in ipairs(entries) do
  local path = root .. "/build/generators.d/" .. e.script
  local gen = assert(loadfile(path))()
  local gctx = setmetatable({}, { __index = ctx })
  if e.dir then
    function gctx.template(name)
      return ctx.read("build/generators.d/" .. e.dir .. "/" .. name)
    end
  end
  gen(gctx)
end

if check and #stale > 0 then
  io.stderr:write("stale generated files (run `just build`):\n")
  for _, p in ipairs(stale) do
    io.stderr:write("  " .. p .. "\n")
  end
  os.exit(1)
end
for _, p in ipairs(wrote) do
  print("wrote " .. p)
end
print(check and "check ok: everything up to date"
  or (#wrote == 0 and "nothing to do: everything up to date" or "done"))
