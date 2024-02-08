local Trailing = {}
Trailing.Protocol = util.AddNetworkString( "Trailer" )
Trailing.PointSize = Vector( 1, 1, 1 ) / 2
Trailing.LoadedStyles = {}

--[[
	Description: Prevents entity transmission for new players
--]]
function Trailing.HideAllFromPlayer( ply, manual )
	for _,ent in pairs( ents.FindByClass( "game_point" ) ) do
		ent:SetPreventTransmit( ply, true )
	end

	if manual then
		net.Start( "Trailer" )
		net.WriteUInt( 0, 8 )
		net.Send( ply )
	end
end
hook.Add( "PlayerInitialSpawn", "PreventEntityTransmission", Trailing.HideAllFromPlayer )

--[[
	Description: Initializes the trailing systems
--]]
function Trailing.CreateOnStyle( ply, nStyle )
	local ox, _, _, _, _, info = Bot.HandleSpecialBot( nil, "Fetch", nil, nStyle )
	if not ox or not info then return end

	-- Check if they're already spawned
	local fr = info and info.Time and #ox / info.Time or 0
	if info.Time and info.Time == Trailing.LoadedStyles[ nStyle ] then
		-- Make sure they can really load
		for _,ent in pairs( ents.FindByClass( "game_point" ) ) do
			if ent.style == nStyle then
				ent:SetPreventTransmit( ply, false )
			end
		end

		-- And update the style
		net.Start( "Trailer" )
		net.WriteUInt( nStyle, 8 )
		net.WriteUInt( 0, 12 )
		net.WriteDouble( fr )
		net.Send( ply )

		-- Also success! But differently
		return 1
	end

	-- Remove existing game_point entities by the same style
	for _,ent in pairs( ents.FindByClass( "game_point" ) ) do
		if ent.style == nStyle then
			ent:Remove()
		end
	end

	-- Loop over the table in steps of 100
	for i = 1, #ox, 100 do
		-- Creates the entity
		local ent = ents.Create( "game_point" )
		ent:SetPos( Vector( ox[ i ][1], ox[ i ][2], ox[ i ][3] ) )
		ent.min = ent:GetPos() - Trailing.PointSize
		ent.max = ent:GetPos() + Trailing.PointSize
		ent.style = nStyle
		ent.id = i
		ent.neighbors = {}

		-- Set the point velocity
		if info and info.Time and ox[ i + 1 ] then
			ent.vel = (Vector( ox[ i + 1 ][1], ox[ i + 1 ][2], ox[ i + 1 ][3] ) - ent:GetPos()) * fr
		end

		-- Get the neighbors
		for j = i + 10, i + 90, 10 do
			if ox[ j ] then
				ent.neighbors[ #ent.neighbors + 1 ] = Vector( ox[ j ][1], ox[ j ][2], ox[ j ][3] )
			end
		end

		-- And create it
		ent:Spawn()
	end

	-- And hide the newly created entities from everyone
	local list = ents.FindByClass( "game_point" )
	for _,p in pairs( player.GetHumans() ) do
		if p != ply then
			for _,ent in pairs( list ) do
				ent:SetPreventTransmit( p, true )
			end
		end
	end

	-- Allow the points to be drawn
	net.Start( "Trailer" )
	net.WriteUInt( nStyle, 8 )
	net.WriteUInt( 0, 12 )
	net.WriteDouble( fr )
	net.Send( ply )

	-- Save the loaded values
	Trailing.LoadedStyles[ nStyle ] = info.Time

	-- Success!
	return 0
end

--[[
	Description: Handles the bot trail command
--]]
function Trailing.MainCommand( ply, args )
	if !args or (#args == 0) then
		Core:Send(ply, "Print", {"Timer", "You need to provide a Style name or a Style ID to use it"})
	return end

	local textFormat = string.lower(tostring(args[1]))
	if (textFormat == "hide") then
		Trailing.HideAllFromPlayer( ply, true )
    Core:Send(ply, "Print", {"Timer", "All Replay trails have been hidden"})
	return end

	local styleID = tonumber(args[1])
  local convertedArgs = table.concat(args, " ")
	if styleID and !Core:IsValidStyle(styleID) then
    return Core:Send(ply, "Print", {"Timer", "The Style ID provided is not valid, please provide a valid Style ID or name to use it."})
  elseif convertedArgs and !Core:GetStyleID(convertedArgs) then
    return Core:Send(ply, "Print", {"Timer", "The Style name provided is not valid, please provide a valid Style ID or name to use it."})
	end

	if !styleID and convertedArgs then
		styleID = Core:GetStyleID(convertedArgs)
	end

	local res = Trailing.CreateOnStyle( ply, styleID )
	if (res == 0) then
    Core:Send(ply, "Print", {"Timer", "The Replay trail " .. Core:StyleName(styleID) .. " has been generated and is now displayed"})
	elseif (res == 1) then
    Core:Send(ply, "Print", {"Timer", "The Replay trail " .. Core:StyleName(styleID) .. " has been displayed"})
	else
    Core:Send(ply, "Print", {"Timer", "There doesn't seem to be a Replay or trail available for this style, please try again later"})
	end
end
Command:Register({"trail", "trailbot", "bottrail", "botroute", "routecopy", "route", "router", "routing", "path", "botpath"}, Trailing.MainCommand)