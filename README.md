# .dotfiles
## nvim
to-do list
- markdown入力補助

## wezterm
local setting example:
```.wezterm_local.lua
local config = {}
config.background = {
    {
        vertical_align = "Middle",
        horizontal_align = "Center",
        source = {
            File = "C:/Users/fkota/.wezterm_image",
        },
        hsb = {
            brightness = 0.2,
        },
    },
}
return config
```

## alacritty
local setting example:
```local.toml
[window]
opacity = 0.7

[general]
import = [
    "~/AppData/Roaming/alacritty/themes/themes/nightfox.toml"
]
```
