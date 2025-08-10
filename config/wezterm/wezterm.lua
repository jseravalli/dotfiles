
local wezterm = require 'wezterm'

return {
  -- Font settings
  font = wezterm.font_with_fallback({
    "Fragment Mono",
    "JetBrains Mono",
    "FiraCode Nerd Font",
  }),
  font_size = 17.0,

  -- Color scheme
  color_scheme = "Whimsy",

  -- Window settings
  enable_tab_bar = true,
  hide_tab_bar_if_only_one_tab = true,
  window_decorations = "RESIZE",
  window_padding = {
	  top = 0,
	  left = 10,
	  right = 10,
	  bottom = 10
  },

  -- Cursor
  default_cursor_style = "BlinkingBlock",

  -- Scrollback
  scrollback_lines = 10000,
}
