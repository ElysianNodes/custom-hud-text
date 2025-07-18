# Custom Text Addon for Garry's Mod

Display custom text on your HUD with configurable color, position, and font. Includes an admin-only GUI for live configuration.

## Features
- Show custom text on the HUD
- Choose from preset colors and positions
- Select from built-in Garry's Mod fonts
- Admin-only in-game GUI for live config
- Config file for manual setup

## Installation
1. Download or clone this repository.
2. Place the `custom_text_addon` folder into your `garrysmod/addons/` directory.
3. (Optional) Edit `lua/autorun/custom_text_config.lua` to set default text, color, position, and font.

## Configuration
You can configure the addon in two ways:

## Support
We provide support at https://discord.gg/XmWJssZmjc

### 1. Config File
Edit `lua/autorun/custom_text_config.lua`:
```lua
CustomTextConfig = {
    text = "Hello from Jimputin!", -- The text to display
    color = "red",                -- Preset color: red, blue, green, white, black
    position = "bottom_middle",   -- bottom_middle, right_middle, left_middle, upper_middle
    font = "DermaLarge"           -- DermaLarge, Default, Trebuchet24, TargetID, ChatFont, etc.
}
```

### 2. Admin GUI (in-game)
Admins can open the GUI with the console command:
```
customtext_admin_gui
```
- Only admins can use this menu.
- Change the text, color, position, and font live.
- Changes are synced to all players.

## Fonts
Common built-in fonts:
- DermaLarge
- Default
- Trebuchet24
- TargetID
- ChatFont
- DefaultBold
- TabLarge
- HudHintTextLarge
- HudHintTextSmall

## Credits
- Addon by Jimputin & ElysianNodes.uk
- ASCII art and sponsorship message print to server console

## License
Do What The Fuck You Want To Public License
