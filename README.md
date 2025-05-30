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
### font installation
```sh
wget https://github.com/yuru7/HackGen/releases/download/v2.10.0/HackGen_v2.10.0.zip
unzip HackGen_v2.10.0.zip
mv HackGen_v2.10.0.zip ~/.fonts
fc-cache -fv
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
