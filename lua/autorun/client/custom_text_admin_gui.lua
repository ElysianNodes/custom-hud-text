-- Custom Text Addon: Admin GUI for configuration
if not LocalPlayer then return end

local color_presets = {"red", "blue", "green", "white", "black"}
local position_presets = {"bottom_middle", "right_middle", "left_middle", "upper_middle", "left_middle"}
local font_presets = {"DermaLarge", "Default", "Trebuchet24", "TargetID", "ChatFont", "DefaultBold", "TabLarge", "HudHintTextLarge", "HudHintTextSmall"}

local function OpenCustomTextAdminGUI()
    if not LocalPlayer():IsAdmin() then
        chat.AddText(Color(255,0,0), "[CustomText] You must be an admin to use this menu.")
        return
    end

    local frame = vgui.Create("DFrame")
    frame:SetTitle("Custom Text Config (Admin Only)")
    frame:SetSize(400, 260)
    frame:Center()
    frame:MakePopup()

    local textEntry = vgui.Create("DTextEntry", frame)
    textEntry:SetPos(20, 40)
    textEntry:SetSize(360, 30)
    textEntry:SetText(CustomTextConfig and CustomTextConfig.text or "")
    textEntry:SetUpdateOnType(true)

    local colorLabel = vgui.Create("DLabel", frame)
    colorLabel:SetPos(20, 80)
    colorLabel:SetText("Color:")
    colorLabel:SizeToContents()

    local colorCombo = vgui.Create("DComboBox", frame)
    colorCombo:SetPos(80, 80)
    colorCombo:SetSize(120, 22)
    for _, col in ipairs(color_presets) do colorCombo:AddChoice(col) end
    colorCombo:SetValue(CustomTextConfig and CustomTextConfig.color or "white")

    local posLabel = vgui.Create("DLabel", frame)
    posLabel:SetPos(20, 120)
    posLabel:SetText("Position:")
    posLabel:SizeToContents()

    local posCombo = vgui.Create("DComboBox", frame)
    posCombo:SetPos(100, 120)
    posCombo:SetSize(180, 22)
    for _, pos in ipairs(position_presets) do posCombo:AddChoice(pos) end
    posCombo:SetValue(CustomTextConfig and CustomTextConfig.position or "bottom_middle")

    local fontLabel = vgui.Create("DLabel", frame)
    fontLabel:SetPos(20, 160)
    fontLabel:SetText("Font:")
    fontLabel:SizeToContents()

    local fontCombo = vgui.Create("DComboBox", frame)
    fontCombo:SetPos(70, 160)
    fontCombo:SetSize(180, 22)
    for _, font in ipairs(font_presets) do fontCombo:AddChoice(font) end
    fontCombo:SetValue(CustomTextConfig and CustomTextConfig.font or "DermaLarge")

    local saveBtn = vgui.Create("DButton", frame)
    saveBtn:SetPos(20, 200)
    saveBtn:SetSize(360, 40)
    saveBtn:SetText("Save Config (Admins Only)")
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