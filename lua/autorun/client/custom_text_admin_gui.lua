if not LocalPlayer then return end

local color_presets = {"red", "blue", "green", "white", "black"}
local position_presets = {"bottom_middle", "right_middle", "left_middle", "upper_middle"}
local font_presets = {"DermaLarge", "Default", "Trebuchet24", "TargetID", "ChatFont", "HudHintTextLarge", "HudHintTextSmall"}

local function OpenCustomTextAdminGUI()
    if not LocalPlayer():IsAdmin() then
        chat.AddText(Color(255, 0, 0), "[CustomText] You must be an admin to use this menu.")
        return
    end

    local frame = vgui.Create("DFrame")
    frame:SetTitle("")
    frame:SetSize(450, 400)
    frame:Center()
    frame:MakePopup()
    frame.Paint = function(self, w, h)
        draw.RoundedBox(10, 0, 0, w, h, Color(30, 30, 30, 240))
        draw.SimpleText("Custom Text Config (Admin Only)", "Trebuchet24", 20, 15, Color(255, 255, 255), TEXT_ALIGN_LEFT)
    end

    local y = 50
    local spacing = 40

    local textEntry = vgui.Create("DTextEntry", frame)
    textEntry:SetPos(20, y)
    textEntry:SetSize(400, 28)
    textEntry:SetPlaceholderText("Enter HUD text...")
    textEntry:SetText(CustomTextConfig and CustomTextConfig.text or "")
    textEntry:SetUpdateOnType(true)
    y = y + spacing

    -- CreateLabelCombo utility
    local function CreateLabelCombo(labelText, values, default, xpos, ypos)
        local label = vgui.Create("DLabel", frame)
        label:SetPos(xpos, ypos)
        label:SetText(labelText)
        label:SetFont("Default")
        label:SetTextColor(Color(200, 200, 200))
        label:SizeToContents()

        local combo = vgui.Create("DComboBox", frame)
        combo:SetPos(xpos + 90, ypos - 3)
        combo:SetSize(200, 24)
        for _, v in ipairs(values) do combo:AddChoice(v) end
        combo:SetValue(default)
        return combo
    end

    local colorCombo = CreateLabelCombo("Color:", color_presets, CustomTextConfig and CustomTextConfig.color or "white", 20, y)
    y = y + spacing
    local posCombo = CreateLabelCombo("Position:", position_presets, CustomTextConfig and CustomTextConfig.position or "bottom_middle", 20, y)
    y = y + spacing
    local fontCombo = CreateLabelCombo("Font:", font_presets, CustomTextConfig and CustomTextConfig.font or "DermaLarge", 20, y)
    y = y + spacing

    -- Live preview label
    local preview = vgui.Create("DLabel", frame)
    preview:SetPos(20, y)
    preview:SetSize(400, 60)
    preview:SetFont(CustomTextConfig and CustomTextConfig.font or "DermaLarge")
    preview:SetTextColor(Color(255, 255, 255))
    preview:SetText(textEntry:GetValue())
    preview:SetContentAlignment(5) -- center
    preview:SetWrap(true)
    y = y + 60

    -- Live update functions
    local function updatePreview()
        preview:SetText(textEntry:GetValue())
        preview:SetFont(fontCombo:GetValue())

        local clr = colorCombo:GetValue()
        local colorMap = {
            red = Color(255, 0, 0),
            green = Color(0, 255, 0),
            blue = Color(0, 100, 255),
            white = Color(255, 255, 255),
            black = Color(0, 0, 0),
        }
        preview:SetTextColor(colorMap[clr] or Color(255, 255, 255))
    end

    textEntry.OnChange = updatePreview
    fontCombo.OnSelect = updatePreview
    colorCombo.OnSelect = updatePreview

    -- Save Button
    local saveBtn = vgui.Create("DButton", frame)
    saveBtn:SetPos(20, y + 10)
    saveBtn:SetSize(400, 40)
    saveBtn:SetText("Save Config")
    saveBtn:SetFont("DermaLarge")
    saveBtn:SetTextColor(Color(255, 255, 255))
    saveBtn.Paint = function(self, w, h)
        local clr = self:IsHovered() and Color(50, 150, 250) or Color(70, 130, 200)
        draw.RoundedBox(8, 0, 0, w, h, clr)
    end
    saveBtn.DoClick = function()
        net.Start("CustomTextAdminUpdate")
            net.WriteString(textEntry:GetValue())
            net.WriteString(colorCombo:GetValue())
            net.WriteString(posCombo:GetValue())
            net.WriteString(fontCombo:GetValue())
        net.SendToServer()
        frame:Close()
    end
end

concommand.Add("customtext_admin_gui", OpenCustomTextAdminGUI)

net.Receive("CustomTextConfigSync", function()
    CustomTextConfig = net.ReadTable()
end)
