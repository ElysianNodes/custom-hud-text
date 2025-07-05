if not LocalPlayer then return end

local color_presets = {"red", "blue", "green", "white", "black"}
local position_presets = {"bottom_middle", "right_middle", "left_middle", "upper_middle"}
local font_presets = {"DermaLarge", "Default", "Trebuchet24", "TargetID", "ChatFont", "DefaultBold", "TabLarge", "HudHintTextLarge", "HudHintTextSmall"}

local function OpenCustomTextAdminGUI()
    if not LocalPlayer():IsAdmin() then
        chat.AddText(Color(255,0,0), "[CustomText] You must be an admin to use this menu.")
        return
    end

    local frame = vgui.Create("DFrame")
    frame:SetTitle("")
    frame:SetSize(420, 300)
    frame:Center()
    frame:MakePopup()
    frame.Paint = function(self, w, h)
        draw.RoundedBox(12, 0, 0, w, h, Color(30, 30, 30, 230))
        draw.SimpleText("🛠️ Custom Text Config (Admin Only)", "Trebuchet24", 20, 15, Color(255,255,255), TEXT_ALIGN_LEFT)
    end

    local y = 50
    local spacing = 40

    -- Text Entry
    local textEntry = vgui.Create("DTextEntry", frame)
    textEntry:SetPos(20, y)
    textEntry:SetSize(380, 28)
    textEntry:SetPlaceholderText("Enter HUD text...")
    textEntry:SetText(CustomTextConfig and CustomTextConfig.text or "")
    textEntry:SetUpdateOnType(true)
    y = y + spacing

    -- Dropdown helper
    local function CreateLabelCombo(labelText, values, default, xpos, ypos)
        local label = vgui.Create("DLabel", frame)
        label:SetPos(xpos, ypos)
        label:SetText(labelText)
		label:SetFont("Trebuchet24")
        label:SetTextColor(Color(200, 200, 200))
        label:SizeToContents()

        local combo = vgui.Create("DComboBox", frame)
        combo:SetPos(xpos + 80, ypos - 3)
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

    -- Save Button
    local saveBtn = vgui.Create("DButton", frame)
    saveBtn:SetPos(20, y)
    saveBtn:SetSize(380, 40)
    saveBtn:SetText("💾 Save Config (Admins Only)")
    saveBtn:SetFont("DermaLarge")
    saveBtn:SetTextColor(Color(255,255,255))
    saveBtn.Paint = function(self, w, h)
        local clr = self:IsHovered() and Color(50, 150, 250) or Color(70, 130, 200)
        draw.RoundedBox(10, 0, 0, w, h, clr)
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
