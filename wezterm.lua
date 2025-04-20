local wezterm = require 'wezterm'
local config = {}
config = wezterm.config_builder()

-- programs
config.default_prog = { "wsl", "~" }

-- representations
config.font = wezterm.font("HackGen Console")
config.color_scheme = 'iceberg-dark'
config.font_size = 12.75
config.audible_bell = "Disabled"

-- load local settings
local home_path = os.getenv("USERPROFILE")
package.path = home_path .. "/.wezterm_local.lua"
local local_settings = require ".wezterm_local"
for k, v in pairs(local_settings) do
    config[k] = v
end
return config
