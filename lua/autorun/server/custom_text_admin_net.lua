util.AddNetworkString("CustomTextAdminUpdate")
util.AddNetworkString("CustomTextConfigSync")

local function BroadcastCustomTextConfig()
    net.Start("CustomTextConfigSync")
    net.WriteTable(CustomTextConfig)
    net.Broadcast()
end

net.Receive("CustomTextAdminUpdate", function(len, ply)
    if not IsValid(ply) or not ply:IsAdmin() then return end
    local text = net.ReadString()
    local color = net.ReadString()
    local position = net.ReadString()
    local font = net.ReadString()
    CustomTextConfig = CustomTextConfig or {}
    CustomTextConfig.text = text
    CustomTextConfig.color = color
    CustomTextConfig.position = position
    CustomTextConfig.font = font
    BroadcastCustomTextConfig()
    print("[CustomText] Config updated by admin: " .. ply:Nick())
end)

hook.Add("PlayerInitialSpawn", "CustomTextConfigSyncOnJoin", function(ply)
    timer.Simple(2, function()
        if not IsValid(ply) then return end
        net.Start("CustomTextConfigSync")
        net.WriteTable(CustomTextConfig)
        net.Send(ply)
    end)
end) 