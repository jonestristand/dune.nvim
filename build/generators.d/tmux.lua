-- extras/tmux/dune-<house>.conf - tmux theme fragments. Colours only, no
-- status-line content

local ansi = require("dune.ansi")

return function(ctx)
  for _, house in ipairs(ctx.meta.house_order) do
    local c = ctx.palettes[house]
    local m = ctx.meta.houses[house]
    local accent = ansi.accent(c)
    local selection = ansi.selection(c)
    local colours = ansi.colours(c)
    local yellow, red = colours[3], colours[1]
    local lines = {
      ("# dune-%s - %s"):format(house, m.ghostty_comment),
      ("# add to tmux.conf: source-file ~/.config/tmux/dune-%s.conf"):format(house),
      "",
      ('set -g status-style "bg=%s,fg=%s"'):format(c.surface, c.fg_dim),
      ('set -g status-left-style "fg=%s,bold"'):format(accent),
      ('set -g status-right-style "fg=%s"'):format(c.fg_dim),
      ('setw -g window-status-style "fg=%s"'):format(c.muted),
      ('setw -g window-status-current-style "bg=%s,fg=%s,bold"'):format(c.overlay, c.fg),
      ('setw -g window-status-activity-style "fg=%s"'):format(yellow),
      ('setw -g window-status-bell-style "fg=%s"'):format(red),
      "",
      ('set -g pane-border-style "fg=%s"'):format(c.overlay),
      ('set -g pane-active-border-style "fg=%s"'):format(accent),
      "",
      ('set -g message-style "bg=%s,fg=%s"'):format(c.surface, c.fg),
      ('set -g message-command-style "bg=%s,fg=%s"'):format(c.surface, c.fg),
      ('set -g mode-style "bg=%s,fg=%s"'):format(selection, c.fg),
      ('set -g copy-mode-match-style "bg=%s,fg=%s"'):format(selection, c.fg),
      ('set -g copy-mode-current-match-style "bg=%s,fg=%s"'):format(yellow, c.bg),
      "",
      ('set -g display-panes-colour "%s"'):format(c.muted),
      ('set -g display-panes-active-colour "%s"'):format(accent),
      ('setw -g clock-mode-colour "%s"'):format(accent),
      "",
    }
    ctx.emit("extras/tmux/dune-" .. house .. ".conf", table.concat(lines, "\n"))
  end
end
