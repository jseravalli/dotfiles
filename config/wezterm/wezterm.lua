local wezterm = require("wezterm")

-- wallpaper directory
local wpdir = os.getenv("HOME") .. "/wallpapers"

-- Helper: list files in a directory (sorted for stability)
local function list_files(dir)
  local f = io.popen("ls -1 " .. wezterm.shell_quote_arg(dir) .. " | sort")
  local files = {}
  if f then
    for file in f:lines() do
      table.insert(files, dir .. "/" .. file)
    end
    f:close()
  end
  return files
end

-- Track index across restarts
local idx_file = wpdir .. "/.last_index"
local files = list_files(wpdir)

local function read_last_index(file)
  local f = io.open(file, "r")
  if f then
    local last = tonumber(f:read("*all")) or 0
    f:close()
    return (last % #files) + 1
  else
    return 1
  end
end

local idx = read_last_index(idx_file)

local function get_next_wallpaper()
  if #files == 0 then return nil end

  -- read last index
  local f = io.open(idx_file, "r")
  if f then
    local last = tonumber(f:read("*all")) or 0
    f:close()
    idx = (last % #files) + 1
  else
    idx = 1
  end

  -- write new index
  f = io.open(idx_file, "w")
  if f then
    f:write(tostring(idx))
    f:close()
  end

  return files[idx]
end

-- pick initial wallpaper
local wallpaper = files[idx]

local function background_layers(file)
  -- Image layer (fit without cropping) + a subtle dark overlay on top
  return {
    {
      source = { Color = "#111010" },
      width = "100%",
      height = "100%",
    },
    -- {
    --   source           = { File = file },
    --   height           = "Contain",
    --   width            = "Contain",
    --   repeat_x         = "NoRepeat",
    --   repeat_y         = "NoRepeat",
    --   horizontal_align = "Center",
    --   vertical_align   = "Middle",
    --   -- optional extra dimming of the image itself:
    --   hsb              = { brightness = 0.015, saturation = 0.8, hue = 1.0 },
    --   opacity          = 1.0,
    -- },
    -- -- Top overlay to improve readability regardless of the image
    {
      source = { Color = "black" },
      opacity = 0.10,
      width = "100%",
      height = "100%",
    },
  }
end

local config = {
  default_prog = { "/bin/zsh", "-l", "-c", "tmux -f ~/.config/tmux/tmux.conf" },

  term = "wezterm",
  -- Fonts
  font = wezterm.font_with_fallback({ "Fragment Mono", "JetBrains Mono", "FiraCode Nerd Font" }),
  font_size = 17.0,

  -- Font rendering - improve sharpness
  freetype_load_target = "Normal",
  freetype_render_target = "HorizontalLcd",

  -- Colors
  color_scheme = "GJM (terminal.sexy)",

  -- Window & padding
  enable_tab_bar = true,
  hide_tab_bar_if_only_one_tab = true,
  window_decorations = "RESIZE",
  window_padding = { top = 0, left = 10, right = 10, bottom = 10 },

  -- Make window slightly translucent + enable macOS blur (this blurs what’s behind the window)
  -- window_background_opacity = 0.9,
  -- macos_window_background_blur = 60, -- requires a recent WezTerm build. :contentReference[oaicite:2]{index=2}

  -- Cursor & scrollback
  default_cursor_style = "BlinkingBlock",
  scrollback_lines = 10000,

  -- Background layers (fit + dim)
  background = wallpaper and background_layers(wallpaper) or nil,

  -- Keys
  keys = {
    { key = "r",          mods = "CTRL|SHIFT", action = wezterm.action.ReloadConfiguration },
    { key = "e",          mods = "CMD",        action = wezterm.action.SendKey { key = "e", mods = "CTRL" } },
    { key = "s",          mods = "CMD",        action = wezterm.action.SendKey { key = "s", mods = "CTRL" } },
    { key = "LeftArrow",  mods = "CMD",        action = wezterm.action.SendKey { key = "LeftArrow", mods = "ALT" } },
    { key = "RightArrow", mods = "CMD",        action = wezterm.action.SendKey { key = "RightArrow", mods = "ALT" } },
    {
      key = "r",
      mods = "CMD", -- ⌘W: next wallpaper instead of close
      action = wezterm.action_callback(function(window, pane)
        local next_wp = get_next_wallpaper()
        if next_wp then
          window:set_config_overrides({ background = background_layers(next_wp) })
        end
      end),
    },
    -- (optional) keep close-tab on ⌘⇧W
    { key = "r", mods = "CMD|SHIFT", action = wezterm.action.CloseCurrentTab({ confirm = true }) },
  },
}

return config
