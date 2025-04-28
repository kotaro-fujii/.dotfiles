# .dotfiles
## nvim
to-do list
- clipboard
- markdown入力補助
- implement to change color in insert mode
## wezterm
local setting
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
```local.toml
[window]
opacity = 0.7

[general]
import = [
    "~/AppData/Roaming/alacritty/themes/themes/nightfox.toml"
]
```
