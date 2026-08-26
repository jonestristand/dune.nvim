-- Metadata for themes!
-- Names, taglines, doc labels, and fixed profile UUIDs for the generators.
-- Colour hexes live ONLY in lua/dune/palettes.lua - this file is only metadata

local M = {}

M.house_order = { "atreides", "harkonnen", "corrino", "fremen", "tleilaxu" }

-- role order used by README tables and site :root blocks
M.role_order = {
  "bg_dim", "bg", "surface", "overlay",
  "fg", "fg_dim", "muted",
  "kw", "num", "str", "fn", "ty", "err", "special", "add",
}

-- what each role does, as printed in the README tables
M.role_labels = {
  bg_dim = "dim panels",
  bg = "editor bg",
  surface = "popups · panels",
  overlay = "selection · overlay",
  fg = "foreground",
  fg_dim = "secondary fg",
  muted = "comments",
  kw = "keywords",
  num = "numbers · constants · warnings",
  str = "strings",
  fn = "functions",
  ty = "types · classes",
  err = "errors · exceptions",
  special = "escapes · special",
  add = "diff added",
  burnish = "search glow · folds · selection",
  gilt_leaf = "operators · punctuation",
}

M.houses = {
  atreides = {
    display = "Dune Atreides",
    -- fixed forever so gnome-terminal/install.py updates in place and
    -- uninstall.py knows what to remove (same idea per house below)
    gnome_uuid = "a8c7ff56-0dbf-4cfc-86f4-ddc59c66935b",
    ghostty_comment = "the shoreline of two worlds",
    names = {
      bg_dim = "midnightSea", bg = "inkWater", surface = "swell", overlay = "reefShadow",
      fg = "crestSand", fg_dim = "driftSand", muted = "seaMist",
      kw = "spice", num = "melange", str = "caladan", fn = "deepCurrent",
      ty = "sisterhoodViolet", err = "hawkRed", special = "foam", add = "bannerGreen",
    },
  },
  harkonnen = {
    display = "Dune Harkonnen",
    gnome_uuid = "7795e815-84fe-49d9-99d8-786fc9abd7f6",
    ghostty_comment = "the black sun (hard monochrome)",
    names = {
      bg_dim = "voidBlack", bg = "giediNight", surface = "machineShadow", overlay = "furnaceSmoke",
      fg = "harshLight", fg_dim = "ashDrift", muted = "smog",
      kw = "glare", num = "pewter", str = "static", fn = "coolant",
      ty = "sisterhoodViolet", err = "ember", special = "arcLight", add = "oxide",
    },
  },
  corrino = {
    display = "Dune Corrino",
    gnome_uuid = "10e5618c-d90f-4597-ac31-44b2e5fdd0c7",
    ghostty_comment = "the golden lion throne",
    names = {
      bg_dim = "porphyryDeep", bg = "kaitainDusk", surface = "marbleShadow", overlay = "courtVeil",
      fg = "alabaster", fg_dim = "agedMarble", muted = "courtier",
      kw = "throneGold", num = "gilt", str = "emerald", fn = "sapphire",
      ty = "sisterhoodViolet", err = "ruby", special = "coldIron", add = "laurel",
      burnish = "burnish", gilt_leaf = "giltLeaf",
    },
    -- roles beyond the shared fifteen, in README/table order
    extra_roles = { "burnish", "gilt_leaf" },
  },
  fremen = {
    display = "Dune Fremen",
    gnome_uuid = "9805b14b-1d91-4e99-8bb4-0951c0a59f1e",
    ghostty_comment = "the desert hides its life",
    names = {
      bg_dim = "openNight", bg = "duneside", surface = "leeward", overlay = "windward",
      fg = "moonlitSand", fg_dim = "wornSand", muted = "dust",
      kw = "spiceThread", num = "duneGold", str = "prophecyGreen", fn = "ibadBlue",
      -- same hex as sisterhoodViolet, worn under the desert name
      ty = "reverendViolet", err = "wormsign", special = "moonSilver", add = "greening",
    },
  },
  tleilaxu = {
    display = "Dune Tleilaxu",
    gnome_uuid = "3d85a4c4-6229-49d2-8754-10480d07646e",
    ghostty_comment = "there is no fifth theme",
    names = {
      bg_dim = "sealedDark", bg = "warren", surface = "vatGlass", overlay = "membrane",
      fg = "pallor", fg_dim = "fadedLinen", muted = "whisper",
      kw = "waxBone", num = "oldBrass", str = "axlotl", fn = "scalpel",
      ty = "sisterhoodViolet", err = "gholaRed", special = "quicksilver", add = "graft",
    },
    -- ghola rows for the README table: { palette key (or ghola_ui role), label }
    -- in display order; the name is "<original name> ghola"
    ghola_rows = {
      { key = "ghola_op", of = "kw", label = "operators · punctuation" },
      { key = "num", of = "num", label = "inactive UI", ui = true },
      { key = "str", of = "str", label = "inactive UI", ui = true },
      { key = "ghola_fn", of = "fn", label = "function call sites" },
      { key = "ghola_ty", of = "ty", label = "builtin types" },
      { key = "err", of = "err", label = "inactive UI", ui = true },
      { key = "special", of = "special", label = "inactive UI", ui = true },
      { key = "add", of = "add", label = "inactive UI", ui = true },
    },
  },
}

return M
