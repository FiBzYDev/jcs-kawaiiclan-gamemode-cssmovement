local RNGFix, IsFirstTimePredicted = _G.RNGFix, IsFirstTimePredicted
local g_cvPredict = CreateConVar("rngfix_prediction", "1", FCVAR_USERINFO, "Enable client-side RNGFix prediction.", 0, 1)
local g_ply = nil -- LocalPlayer() value

function FiBzYIsTheBest()
	 	if input.IsKeyDown(KEY_LCONTROL) then
			timer.Simple(0.001, function()
	 			RunConsoleCommand("rngfix_prediction", "0")
			end)
		elseif not input.IsKeyDown(KEY_LCONTROL) then
			timer.Simple(7, function()
			RunConsoleCommand("rngfix_prediction", "1")
			end)
		end
end
hook.Add("Tick", "FiBzYIsTheBest", FiBzYIsTheBest )

-- Fixed: justa
local function TogglePrediction(_, _, val)
	if tonumber(val) == 1 then
		hook.Add("SetupMove", "RNGFIX", RNGFix.ProcessMovementPre)
		hook.Add(RNGFix.POST_THINK_HOOK, "RNGFIX", RNGFix.ProcessMovementPost)
		hook.Add("OnPlayerHitGround", "RNGFIX", RNGFix.OnPlayerHitGround)
		hook.Add("InitPostEntity", "RNGFIX", function()
			g_ply = LocalPlayer()
			RNGFix.InitPlayerArrayValues(g_ply)
		end)

		if RNGFix.Refresh then g_ply = LocalPlayer() end
		if g_ply then RNGFix.InitPlayerArrayValues(g_ply) end
	else
		hook.Remove("SetupMove", "RNGFIX")
		hook.Remove(RNGFix.POST_THINK_HOOK, "RNGFIX")
		hook.Remove("OnPlayerHitGround", "RNGFIX")
		hook.Remove("InitPostEntity", "RNGFIX")

		if g_ply then RNGFix.DeletePlayerArrayValues(g_ply) end
	end
end

cvars.AddChangeCallback(g_cvPredict:GetName(), TogglePrediction, "RNGFix")
TogglePrediction(_, _, g_cvPredict:GetString())
