-- Custom Text Addon: Draws custom text on the HUD based on config
if not CustomTextConfig then return end

local color_presets = {
    red   = Color(255, 0, 0),
    blue  = Color(0, 128, 255),
    green = Color(0, 255, 0),
    white = Color(255, 255, 255),
    black = Color(0, 0, 0)
}

local positions = {
    bottom_middle = function(w, h, tw, th) return w/2 - tw/2, h - th - 32 end,
    right_middle  = function(w, h, tw, th) return w - tw - 32, h/2 - th/2 end,
    left_middle   = function(w, h, tw, th) return 32, h/2 - th/2 end,
    upper_middle  = function(w, h, tw, th) return w/2 - tw/2, 32 end
}

hook.Add("HUDPaint", "CustomTextAddon_DrawText", function()
    local cfg = CustomTextConfig
    if not cfg or not cfg.text or cfg.text == "" then return end

    local col = color_presets[cfg.color] or color_presets.white
    local pos_func = positions[cfg.position] or positions.bottom_middle
    local font = cfg.font or "DermaLarge"

    surface.SetFont(font)
    local tw, th = surface.GetTextSize(cfg.text)
    local w, h = ScrW(), ScrH()
    local x, y = pos_func(w, h, tw, th)

    draw.SimpleText(cfg.text, font, x, y, col, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
end) 