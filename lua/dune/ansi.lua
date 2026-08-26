-- ANSI slot → palette role, used by every terminal-port generator in
-- build/generators.d/ (ghostty, kitty, tmux, ...) plus VS Code and KDE. Slots 
-- are semantic (green = added/success, yellow = warning)
--
-- A palette may override a hue by ANSI name via its optional `ansi` table
-- (e.g. harkonnen yses a tarnished-brass yellow since the theme itself doesn't
-- include any colour that is recognizeable as yellow
local ROLES = {
	[0] = "surface", "err", "add", "num", "fn", "ty", "special", "fg_dim",
	"muted", "err", "add", "num", "fn", "ty", "special", "fg",
}
local NAMES = {
	[1] = "red", [2] = "green", [3] = "yellow",
	[4] = "blue", [5] = "magenta", [6] = "cyan",
}

local M = {}

--- UI accent (frames, borders, active elements): gold in
--- the gilded house (corrino), blue elsewhere.
function M.accent(c)
	return c.gilded and c.kw or c.fn
end

--- Cursor colour: corrino cursors in gold (gilded).
function M.cursor(c)
	return c.gilded and c.kw or c.fg
end

--- Selection background: burnished background for corrino.
function M.selection(c)
	return c.gilded and c.burnish or c.overlay
end

--- The 16 terminal colours for a palette, indexed 0..15.
function M.colours(c)
	local out = {}
	for i = 0, 15 do
		local name = NAMES[i % 8]
		out[i] = (c.ansi and name and c.ansi[name]) or c[ROLES[i]]
	end
	return out
end

return M
