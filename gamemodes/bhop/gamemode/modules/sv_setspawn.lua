-- Code for set spawn style
-- by justa and fibzy

-- module 
SetSpawn = {}

-- Setup waypoints
function SetSpawn:WaypointSetup(client)

	if (not client.waypoints) then 
		client.waypoints = {}
		client.lastWaypoint = 0
		client.lastTele = 0
	end

end

-- Set a waypoint
function SetSpawn:SetWaypoint(client)

	-- Set up if not already
	if client.Style == 2 then return end
	if client.Style == 3 then return end
	if client.Style == 4 then return end
	if client.Style == 5 then return end
	if client.Style == 6 then return end
	if client.Style == 7 then return end
	if client.Style == 9 then return end
	if client.Style == 10 then return end

	-- Set up waypoints
	self:WaypointSetup(client)

	if client.Tn then
		Core:Send(client, "Print", {"Timer", "You can only set spawn point in a zone."})
		return 
	end

	-- Too fast
	if (client.lastWaypoint > CurTime()) then 
		return
	end

	-- Set waypoint
	table.insert(client.waypoints, {
		frame = Bot:GetFrame(client),
		pos = client:GetPos(),
		angles = client:EyeAngles(),
		vel = client:GetVelocity(),
	})

	-- Lil' inform 
	Core:Send(client, "Print", {"Timer", "New spawn set."})

	-- Last waypoint
	client.lastWaypoint = CurTime() + 0.5
end

-- Goto waypoint
function SetSpawn:GotoWaypoint(client)
	-- Set up waypoints
	self:WaypointSetup(client)

	-- Do we even have a waypoint
	if (#client.waypoints < 1) then 
		Core:Send(client, "Print", {"Timer", "Waiting for you to set a spawn point."})
		return
	end

	-- Too fast
	if (client.lastTele > CurTime()) then 
		return
	end

	-- Get waypoint
	local waypoint = client.waypoints[#client.waypoints]

	-- Set player values
	client:SetPos(waypoint.pos)
	client:SetLocalVelocity(waypoint.vel)
	client:SetEyeAngles(waypoint.angles)

	Spectator:PlayerRestart(client)

	-- Strip bot frames 
	Bot:StripFromFrame(client, waypoint.frame)

	-- Last tele
	client.lastTele = 0
end