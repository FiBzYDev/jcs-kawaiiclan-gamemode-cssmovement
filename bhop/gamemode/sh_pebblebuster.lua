if (CLIENT) then 
	CreateClientConVar("kawaii_debug_pebbles", 0, false, false, "Debug pebble analysis to console", 0, 1)

	function PebbleDebugEnabled()
		return GetConVar("kawaii_debug_pebbles"):GetBool()
	end

	function PebbleDebugOutput(strOutput)
		LocalPlayer():ChatPrint(strOutput)
	end

end

local function ResetPlayerData(objPlayer)
	objPlayer.lastLength = 0
	objPlayer.lastVelocity = Vector(0, 0, 0)
	objPlayer.lastMoveAngles = Angle(0, 0, 0)
	objPlayer.lastPct = 0
	objPlayer.traceData = {}
end

local function DetectPebble(objPlayer, mvData)
	if !IsValid(objPlayer) then return end

	if !objPlayer.lastLength then
		ResetPlayerData(objPlayer)
	end

	if mvData:KeyDown(IN_BACK) || math.Round(mvData:GetVelocity():LengthSqr(), 2) == 0.25 then
		ResetPlayerData(objPlayer)
		return
	end 

	if objPlayer:OnGround() || objPlayer:WaterLevel() > 0 then 
		ResetPlayerData(objPlayer)
		return 
	end

	if (SERVER) && !objPlayer.shouldPebbleBust then
		ResetPlayerData(objPlayer)
		return 
	end

	if objPlayer.lastLength > mvData:GetVelocity():LengthSqr() then
		local raw = objPlayer.lastLength - mvData:GetVelocity():LengthSqr()
		local pct = (raw / objPlayer.lastLength) * 100

		if pct == 100 then -- This doesn't seem to be a natural pebble, or a pebble at all
			ResetPlayerData(objPlayer)
			return 
		end

		if pct > 96 && pct != objPlayer.lastPct then

			-- Simple trace first to detect ceilings
			objPlayer.traceData = util.TraceLine(
				{
					start = objPlayer:GetPos(),
					endpos = objPlayer:GetPos() + Vector(0, 0, 100),
					filter = objPlayer,
					mask = CONTENTS_PLAYERCLIP + MASK_SOLID_BRUSHONLY
				}
			)

			if objPlayer.traceData.HitWorld then
				ResetPlayerData(objPlayer)
				return
			end

			if mvData:GetVelocity():LengthSqr() == 20.25 && objPlayer.lastLength != mvData:GetVelocity():LengthSqr() then
				mvData:SetOrigin(mvData:GetOrigin() + Vector(0, 0, 2) )
				mvData:SetMoveAngles(objPlayer.lastMoveAngles)
				mvData:SetVelocity(objPlayer.lastVelocity)
				objPlayer.lastLength = 20.25
				objPlayer.lastPct = 1
				if (CLIENT) && PebbleDebugEnabled() then
					PebbleDebugOutput(Format("%s (CLIENT) Quick Pebble detected! %% Speed loss: %f. New Speed would have been: %f", os.date(), pct, objPlayer.lastLength))
				end

				return
			end	

			objPlayer.traceData = util.TraceHull(
				{
					start = objPlayer:GetPos(),
					endpos = objPlayer:GetPos() + (objPlayer:GetForward() * 60),
					mins = objPlayer:OBBMins(),
					maxs = objPlayer:OBBMaxs(),
					filter = objPlayer,
					mask = CONTENTS_PLAYERCLIP + MASK_SOLID_BRUSHONLY
				}
			)


			if objPlayer.traceData.HitWorld then
				ResetPlayerData(objPlayer)
				return
			end

			-- Well, we're all good on the forwards front!
			objPlayer.traceData = util.TraceHull(
				{
					start = objPlayer:GetPos(),
					endpos = objPlayer:GetPos(),
					mins = objPlayer:OBBMins() + Vector(-10, -10, -10),
					maxs = objPlayer:OBBMaxs() + Vector(10, 10, 10),
					filter = objPlayer,
					mask = CONTENTS_PLAYERCLIP
				}
			)

			if objPlayer.traceData.HitWorld then
				ResetPlayerData(objPlayer)
				return
			end

			objPlayer.traceData = {}

			if (CLIENT) && PebbleDebugEnabled() then
				PebbleDebugOutput(Format("%s (CLIENT) Pebble detected! %% Speed loss: %f. New Speed would have been: %f", os.date(), pct, mvData:GetVelocity():LengthSqr()))
			end
			if objPlayer.lastLength < 40 then if (CLIENT) && PebbleDebugEnabled() then PebbleDebugOutput("(CLIENT) Last speed too low, not correcting") end return end
			if (CLIENT) && PebbleDebugEnabled() then
				PebbleDebugOutput(Format("%s (CLIENT) Applying last speed: %f (PEBBLE).", os.date(), objPlayer.lastLength))
			end
			mvData:SetOrigin(mvData:GetOrigin() + Vector(0, 0, 2) )
			mvData:SetMoveAngles(objPlayer.lastMoveAngles)
			mvData:SetVelocity(objPlayer.lastVelocity)
			objPlayer.lastPct = pct
			return
		end

	end

	objPlayer.lastLength = mvData:GetVelocity():LengthSqr()
	objPlayer.lastVelocity = mvData:GetVelocity()
	objPlayer.lastMoveAngles = mvData:GetMoveAngles()

end
hook.Add("SetupMove", "DetectPebble", DetectPebble)