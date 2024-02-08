local cv_enabled = CreateClientConVar("wrsfx", "1", true, true, "WR sounds enabled state", 0, 1)
local cv_volume = CreateClientConVar("wrsfx_volume", "0.4", true, false, "WR sounds volume", 0, 1)

net.Receive("WRSFX_Broadcast", function(len, ply)
    if not cv_enabled:GetBool() then return end
    EmitSound("wrsfx/" .. net.ReadString(), vector_origin, -2, CHAN_AUTO, cv_volume:GetFloat())
end)
