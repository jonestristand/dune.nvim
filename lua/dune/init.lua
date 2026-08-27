-- dune.nvim - 4+1 themes

local M = {}

---@param house '"atreides"'|'"harkonnen"'|'"corrino"'|'"fremen"'|'"tleilaxu"'
function M.load(house)
  local palettes = require("dune.palettes")
  local c = palettes[house]
  if not c then
    vim.notify(("dune.nvim: unknown house '%s'"):format(house), vim.log.levels.ERROR)
    return
  end

  if vim.g.colors_name then
    vim.cmd("hi clear")
  end
  vim.o.termguicolors = true
  vim.g.colors_name = "dune-" .. house

  local hl = function(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
  end

  -- mix `colour` into `base` at `amount` (0..1)
  local blend = function(base, colour, amount)
    local br, bg_, bb = base:match("#(%x%x)(%x%x)(%x%x)")
    local cr, cg, cb = colour:match("#(%x%x)(%x%x)(%x%x)")
    local mix = function(a, b)
      return math.floor(tonumber(a, 16) * (1 - amount) + tonumber(b, 16) * amount + 0.5)
    end
    return string.format("#%02X%02X%02X", mix(br, cr), mix(bg_, cg), mix(bb, cb))
  end

  -- bones-style palettes carry keywords by weight, not hue; kw_bold can
  -- also be set alone (corrino: bold gold keywords)
  local kw_bold = (c.bones or c.kw_bold) and true or nil
  -- gilded palettes (corrino) let the accent metal own more syntax:
  -- operators, delimiters, constants, and the UI frame
  local gilded = c.gilded and true or nil
  local shadow = c.burnish or c.surface
  -- constants are literals: they have the values colour (num), except in
  -- gilded houses where the metal owns them (README: palette capabilities)
  local const = gilded and c.kw or c.num

  -- UI -----------------------------------------------------------------
  hl("Normal",        { fg = c.fg, bg = c.bg })
  hl("NormalNC",      { fg = c.fg, bg = c.bg })
  hl("NormalFloat",   { fg = c.fg, bg = c.surface })
  hl("FloatBorder",   { fg = gilded and c.num or c.overlay, bg = c.surface })
  hl("FloatTitle",    { fg = c.kw, bg = c.surface, bold = true })
  hl("Cursor",        { fg = c.bg, bg = c.fg })
  hl("CursorLine",    { bg = c.surface })
  hl("CursorColumn",  { bg = c.surface })
  hl("ColorColumn",   { bg = c.surface })
  hl("LineNr",        { fg = c.muted })
  hl("CursorLineNr",  { fg = gilded and c.kw or c.num, bold = true })
  hl("SignColumn",    { bg = c.bg })
  hl("Visual",        { bg = gilded and shadow or c.overlay })
  hl("VisualNOS",     { bg = c.overlay })
  hl("Search",        gilded and { fg = c.fg, bg = shadow } or { fg = c.bg, bg = c.num })
  hl("IncSearch",     { fg = c.bg, bg = c.kw })
  hl("CurSearch",     { link = "IncSearch" })
  hl("MatchParen",    { fg = c.special, bold = true })
  hl("Pmenu",         { fg = c.fg_dim, bg = c.surface })
  hl("PmenuSel",      { fg = c.fg, bg = c.overlay, bold = true })
  hl("PmenuSbar",     { bg = c.surface })
  hl("PmenuThumb",    { bg = c.overlay })
  hl("WildMenu",      { link = "PmenuSel" })
  hl("StatusLine",    { fg = gilded and c.num or c.fg_dim, bg = c.surface })
  hl("StatusLineNC",  { fg = c.muted, bg = c.bg_dim })
  hl("WinSeparator",  { fg = c.overlay })
  hl("VertSplit",     { link = "WinSeparator" })
  hl("TabLine",       { fg = c.muted, bg = c.bg_dim })
  hl("TabLineSel",    { fg = c.fg, bg = c.bg })
  hl("TabLineFill",   { bg = c.bg_dim })
  hl("Folded",        { fg = c.muted, bg = gilded and shadow or c.surface, italic = true })
  hl("FoldColumn",    { fg = c.muted })
  hl("NonText",       { fg = c.overlay })
  hl("Whitespace",    { fg = c.overlay })
  hl("SpecialKey",    { fg = c.special })
  hl("EndOfBuffer",   { fg = c.bg })
  hl("Directory",     { fg = c.fn })
  hl("Title",         { fg = c.kw, bold = true })
  hl("ErrorMsg",      { fg = c.err, bold = true })
  hl("WarningMsg",    { fg = c.num })
  hl("MoreMsg",       { fg = c.add })
  hl("Question",      { fg = c.fn })
  hl("ModeMsg",       { fg = c.fg_dim, bold = true })
  hl("QuickFixLine",  { bg = c.overlay })

  -- Diffs & git --------------------------------------------------------
  hl("DiffAdd",       { bg = blend(c.bg, c.add, 0.12) })
  hl("DiffChange",    { bg = c.surface })
  hl("DiffDelete",    { fg = c.err, bg = blend(c.bg, c.err, 0.12) })
  hl("DiffText",      { bg = c.overlay })
  hl("Added",         { fg = c.add })
  hl("Changed",       { fg = c.num })
  hl("Removed",       { fg = c.err })
  hl("GitSignsAdd",    { fg = c.add })
  hl("GitSignsChange", { fg = c.num })
  hl("GitSignsDelete", { fg = c.err })

  -- Syntax -------------------------------------------------------------
  hl("Comment",       { fg = c.muted, italic = true })
  hl("Constant",      { fg = const })
  hl("String",        { fg = c.str })
  hl("Character",     { fg = c.str })
  hl("Number",        { fg = c.num })
  hl("Float",         { fg = c.num })
  hl("Boolean",       { fg = const })
  hl("Identifier",    { fg = c.fg })
  hl("Function",      { fg = c.fn })
  hl("Statement",     { fg = c.kw })
  hl("Conditional",   { fg = c.kw, bold = kw_bold })
  hl("Repeat",        { fg = c.kw })
  hl("Label",         { fg = c.kw })
  hl("Operator",      { fg = c.ghola_op or c.gilt_leaf or c.fg_dim })
  hl("Keyword",       { fg = c.kw, bold = kw_bold })
  -- exception keywords use err: red means trouble, and throw/catch/raise
  -- is trouble's control flow - otherwise there's no red... 
  hl("Exception",     { fg = c.err })
  hl("PreProc",       { fg = c.ty })
  hl("Include",       { fg = c.kw, bold = kw_bold })
  hl("Define",        { fg = c.kw })
  hl("Macro",         { fg = c.ty })
  hl("Type",          { fg = c.ty })
  hl("StorageClass",  { fg = c.kw, bold = kw_bold })
  hl("Structure",     { fg = c.ty })
  hl("Typedef",       { fg = c.ty })
  hl("Special",       { fg = c.special })
  hl("SpecialChar",   { fg = c.special })
  hl("Tag",           { fg = c.kw })
  hl("Delimiter",     { fg = c.ghola_op or c.gilt_leaf or c.fg_dim })
  hl("SpecialComment",{ fg = c.muted, bold = true })
  hl("Debug",         { fg = c.err })
  hl("Underlined",    { fg = c.fn, underline = true })
  hl("Bold",          { bold = true })
  hl("Italic",        { italic = true })
  hl("Error",         { fg = c.err })
  hl("Todo",          { fg = c.bg, bg = c.num, bold = true })

  -- Treesitter ---------------------------------------------------------
  hl("@variable",             { fg = c.fg })
  hl("@variable.builtin",     { fg = c.special, italic = true })
  hl("@variable.parameter",   { fg = c.fg_dim, italic = true })
  hl("@variable.member",      { fg = c.fg })
  hl("@constant",             { fg = const })
  hl("@constant.builtin",     { fg = const, bold = true })
  hl("@module",               { fg = c.ty })
  hl("@string",               { link = "String" })
  hl("@string.escape",        { fg = c.special })
  hl("@string.regexp",        { fg = c.special })
  hl("@string.special.url",   { fg = c.fn, underline = true })
  hl("@number",               { link = "Number" })
  hl("@boolean",              { link = "Boolean" })
  hl("@function",             { link = "Function" })
  hl("@function.builtin",     { fg = c.fn, bold = true })
  hl("@function.method",      { link = "Function" })
  hl("@constructor",          { fg = c.ty })
  hl("@keyword",              { link = "Keyword" })
  hl("@keyword.function",     { fg = c.kw })
  hl("@keyword.return",       { fg = c.kw, italic = true })
  hl("@keyword.exception",    { fg = c.err })
  hl("@operator",             { link = "Operator" })
  -- tleilaxu ghola roles: definitions use the original, repetitions the copy
  if c.ghola_fn then
    hl("@function.call",        { fg = c.ghola_fn })
    hl("@function.method.call", { fg = c.ghola_fn })
  end
  hl("@punctuation.bracket",  { fg = c.fg_dim })
  hl("@punctuation.delimiter",{ fg = c.fg_dim })
  hl("@type",                 { link = "Type" })
  hl("@type.builtin",         { fg = c.ghola_ty or c.ty, italic = true })
  hl("@property",             { fg = c.fg })
  hl("@attribute",            { fg = c.ty })
  hl("@tag",                  { fg = c.kw })
  hl("@tag.attribute",        { fg = c.fg_dim })
  hl("@tag.delimiter",        { fg = c.muted })
  hl("@comment",              { link = "Comment" })
  hl("@markup.heading",       { fg = c.kw, bold = true })
  hl("@markup.strong",        { bold = true })
  hl("@markup.italic",        { italic = true })
  hl("@markup.link",          { fg = c.fn, underline = true })
  hl("@markup.raw",           { fg = c.str })
  hl("@markup.list",          { fg = c.kw })
  hl("@diff.plus",            { fg = c.add })
  hl("@diff.minus",           { fg = c.err })
  hl("@diff.delta",           { fg = c.num })

  -- LSP semantic tokens ------------------------------------------------
  -- semantic tokens paint over treesitter at higher priority, and they
  -- don't distinguish definition from call - cleared groups keep the
  -- treesitter colour (ghola definition/copy split, parameter italics,
  -- todo-comments inside comments)
  hl("@lsp.type.function",      {})
  hl("@lsp.type.method",        {})
  hl("@lsp.type.variable",      {})
  hl("@lsp.type.comment",       {})
  hl("@lsp.type.class",         { link = "@type" })
  hl("@lsp.type.struct",        { link = "@type" })
  hl("@lsp.type.enum",          { link = "@type" })
  hl("@lsp.type.interface",     { link = "@type" })
  hl("@lsp.type.typeParameter", { link = "@type" })
  hl("@lsp.type.builtinType",   { link = "@type.builtin" })
  hl("@lsp.type.enumMember",    { link = "@constant" })
  hl("@lsp.type.namespace",     { link = "@module" })
  hl("@lsp.type.parameter",     { link = "@variable.parameter" })
  hl("@lsp.type.property",      { link = "@property" })
  hl("@lsp.type.keyword",       { link = "@keyword" })
  hl("@lsp.type.macro",         { link = "Macro" })
  hl("@lsp.type.decorator",     { link = "@attribute" })
  hl("@lsp.type.selfParameter", { link = "@variable.builtin" })
  hl("@lsp.type.selfKeyword",   { link = "@variable.builtin" })
  hl("@lsp.mod.deprecated",     { strikethrough = true })
  hl("@lsp.typemod.function.defaultLibrary", { link = "@function.builtin" })
  hl("@lsp.typemod.method.defaultLibrary",   { link = "@function.builtin" })
  hl("@lsp.typemod.variable.defaultLibrary", { link = "@variable.builtin" })

  -- Diagnostics --------------------------------------------------------
  hl("DiagnosticError", { fg = c.err })
  hl("DiagnosticWarn",  { fg = c.num })
  hl("DiagnosticInfo",  { fg = c.fn })
  hl("DiagnosticHint",  { fg = c.special })
  hl("DiagnosticOk",    { fg = c.add })
  hl("DiagnosticUnderlineError", { sp = c.err, undercurl = true })
  hl("DiagnosticUnderlineWarn",  { sp = c.num, undercurl = true })
  hl("DiagnosticUnderlineInfo",  { sp = c.fn, undercurl = true })
  hl("DiagnosticUnderlineHint",  { sp = c.special, undercurl = true })
  hl("DiagnosticVirtualTextError", { fg = c.err, bg = c.bg_dim })
  hl("DiagnosticVirtualTextWarn",  { fg = c.num, bg = c.bg_dim })
  hl("DiagnosticVirtualTextInfo",  { fg = c.fn, bg = c.bg_dim })
  hl("DiagnosticVirtualTextHint",  { fg = c.special, bg = c.bg_dim })

  -- LSP / misc plugins -------------------------------------------------
  hl("LspReferenceText",  { bg = c.overlay })
  hl("LspReferenceRead",  { bg = c.overlay })
  hl("LspReferenceWrite", { bg = c.overlay, underline = true })
  -- telescope floats sit on bg (not NormalFloat's surface) so muted text
  -- keeps its contrast and the selection has room to stand out
  hl("TelescopeNormal",       { fg = c.fg, bg = c.bg })
  hl("TelescopeBorder",       { fg = c.overlay, bg = c.bg })
  hl("TelescopeTitle",        { fg = c.kw, bold = true })
  hl("TelescopeSelection",    { fg = c.fg, bg = c.overlay, bold = true })
  hl("TelescopeSelectionCaret", { fg = c.num, bg = c.overlay })
  hl("TelescopeResultsComment", { fg = c.muted })
  -- picker matches are search hits; the search family lives on num
  hl("TelescopeMatching",     { fg = c.num, bold = true })
  hl("TelescopePromptPrefix", { fg = c.num })
  -- snacks.nvim picker: its defaults link Dir/Totals/etc to NonText (a
  -- background shade here) and the list cursorline to Visual (the same
  -- overlay), so path text disappears on the selected row - pin real colours
  hl("SnacksPicker",              { fg = c.fg, bg = c.bg })
  hl("SnacksPickerBorder",        { fg = c.overlay, bg = c.bg })
  hl("SnacksPickerTitle",         { fg = c.kw, bg = c.bg, bold = true })
  hl("SnacksPickerListCursorLine",{ bg = c.overlay })
  hl("SnacksPickerPreviewCursorLine", { bg = c.overlay })
  hl("SnacksPickerMatch",         { fg = c.num, bold = true })
  hl("SnacksPickerPrompt",        { fg = c.num })
  hl("SnacksPickerDir",           { fg = c.muted })
  hl("SnacksPickerPathHidden",    { fg = c.muted })
  hl("SnacksPickerPathIgnored",   { fg = c.muted, italic = true })
  hl("SnacksPickerTotals",        { fg = c.muted })
  hl("SnacksPickerUnselected",    { fg = c.muted })
  hl("SnacksPickerGitStatusUntracked", { fg = c.special })
  hl("WhichKey",              { fg = c.kw })
  hl("WhichKeyGroup",         { fg = c.fn })
  hl("WhichKeyDesc",          { fg = c.fg_dim })
  hl("IblIndent",             { fg = c.surface })
  hl("IblScope",              { fg = c.overlay })

  -- Completion menus (nvim-cmp / blink.cmp) ----------------------------
  hl("CmpItemAbbr",             { fg = c.fg })
  hl("CmpItemAbbrMatch",        { fg = c.num, bold = true })
  hl("CmpItemAbbrMatchFuzzy",   { fg = c.num, bold = true })
  hl("CmpItemAbbrDeprecated",   { fg = c.muted, strikethrough = true })
  hl("CmpItemMenu",             { fg = c.muted, italic = true })
  hl("CmpItemKindText",         { fg = c.fg_dim })
  hl("CmpItemKindMethod",       { fg = c.fn })
  hl("CmpItemKindFunction",     { fg = c.fn })
  hl("CmpItemKindConstructor",  { fg = c.ty })
  hl("CmpItemKindField",        { fg = c.fg })
  hl("CmpItemKindVariable",     { fg = c.fg })
  hl("CmpItemKindClass",        { fg = c.ty })
  hl("CmpItemKindInterface",    { fg = c.ty })
  hl("CmpItemKindModule",       { fg = c.ty })
  hl("CmpItemKindProperty",     { fg = c.fg })
  hl("CmpItemKindValue",        { fg = c.num })
  hl("CmpItemKindEnum",         { fg = c.ty })
  hl("CmpItemKindKeyword",      { fg = c.kw })
  hl("CmpItemKindSnippet",      { fg = c.special })
  hl("CmpItemKindConstant",     { fg = c.num })
  hl("CmpItemKindStruct",       { fg = c.ty })
  hl("CmpItemKindOperator",     { fg = c.fg_dim })
  hl("BlinkCmpMenu",            { link = "Pmenu" })
  hl("BlinkCmpMenuBorder",      { fg = c.overlay, bg = c.surface })
  hl("BlinkCmpLabel",           { fg = c.fg_dim })
  hl("BlinkCmpLabelMatch",      { fg = c.num, bold = true })
  hl("BlinkCmpLabelDeprecated", { fg = c.muted, strikethrough = true })
  hl("BlinkCmpKind",            { fg = c.special })

  -- lazy.nvim / mason --------------------------------------------------
  hl("LazyH1",                  { fg = c.bg, bg = c.kw, bold = true })
  hl("LazyButton",              { fg = c.fg_dim, bg = c.surface })
  hl("LazyButtonActive",        { fg = c.fg, bg = c.overlay, bold = true })
  hl("LazySpecial",             { fg = c.special })
  hl("MasonHeader",             { fg = c.bg, bg = c.kw, bold = true })
  hl("MasonHighlight",          { fg = c.fn })
  hl("MasonHighlightBlock",     { fg = c.bg, bg = c.fn })
  hl("MasonHighlightBlockBold", { fg = c.bg, bg = c.fn, bold = true })
  hl("MasonMuted",              { fg = c.muted })
  hl("MasonMutedBlock",         { fg = c.fg_dim, bg = c.surface })

  -- neo-tree -----------------------------------------------------------
  hl("NeoTreeNormal",           { fg = c.fg, bg = c.bg_dim })
  hl("NeoTreeNormalNC",         { fg = c.fg, bg = c.bg_dim })
  hl("NeoTreeDirectoryName",    { fg = c.fn })
  hl("NeoTreeDirectoryIcon",    { fg = c.fn })
  hl("NeoTreeRootName",         { fg = c.kw, bold = true })
  hl("NeoTreeDotfile",          { fg = c.muted })
  hl("NeoTreeGitModified",      { fg = c.num })
  hl("NeoTreeGitAdded",         { fg = c.add })
  hl("NeoTreeGitDeleted",       { fg = c.err })
  hl("NeoTreeGitUntracked",     { fg = c.special })

  -- nvim-notify / noice ------------------------------------------------
  for level, colour in pairs({ ERROR = c.err, WARN = c.num, INFO = c.fn,
                               DEBUG = c.muted, TRACE = c.special }) do
    hl("Notify" .. level .. "Border", { fg = colour })
    hl("Notify" .. level .. "Icon",   { fg = colour })
    hl("Notify" .. level .. "Title",  { fg = colour, bold = true })
  end
  hl("NotifyBackground",        { bg = c.bg })
  hl("NoiceCmdlinePopupBorder", { fg = c.overlay })
  hl("NoiceCmdlineIcon",        { fg = c.kw })

  -- core stragglers ----------------------------------------------------
  hl("WinBar",     { fg = c.fg_dim, bold = true })
  hl("WinBarNC",   { fg = c.muted })
  hl("Substitute", { link = "Search" })
  hl("Conceal",    { fg = c.muted })

  -- :terminal - ansi.lua mapping
  local ansi = require("dune.ansi").colours(c)
  for i = 0, 15 do
    vim.g["terminal_color_" .. i] = ansi[i]
  end
end

return M
