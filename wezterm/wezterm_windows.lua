local wezterm = require 'wezterm'
local act     = wezterm.action
local config = {}
config = wezterm.config_builder()

-- programs
config.default_prog = { "wsl", "~" }

-- representations
config.font = wezterm.font("HackGen Console")
config.font_size = 12.75
config.color_scheme = 'nightfox'
config.audible_bell = "Disabled"
config.hide_tab_bar_if_only_one_tab = true

-- key binds
config.disable_default_key_bindings = true
config.keys = {
    { key = 'v',   mods = 'CTRL|SHIFT', action = act.PasteFrom 'Clipboard' },
    { key = 'Tab', mods = 'CTRL',       action = act.MoveTabRelative(1) },
    { key = 'Tab', mods = 'CTRL|SHIFT', action = act.MoveTabRelative(-1) },
    { key = 't',   mods = 'CTRL|SHIFT', action = act.SpawnTab 'DefaultDomain' },
}

config.window_padding = {
  left = 2,
  right = 2,
  top = 0,
  bottom = 0,
}

-- load local settings
local home_path = os.getenv("USERPROFILE")
package.path = home_path .. "/.wezterm_local.lua"
local local_settings = require ".wezterm_local"
for k, v in pairs(local_settings) do
    config[k] = v
end
return config
