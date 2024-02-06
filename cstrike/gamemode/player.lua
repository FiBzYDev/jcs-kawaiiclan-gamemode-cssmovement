function GM:OnPhysgunFreeze( weapon, phys, ent, ply )
	return false
end

function GM:OnPhysgunReload( weapon, ply )
	return false
end

function GM:PlayerAuthed( ply, SteamID, UniqueID )
end

function GM:PlayerCanPickupWeapon( ply, entity )

	return true

end

function GM:PlayerCanPickupItem( ply, entity )

	return true

end

function GM:CanPlayerUnfreeze( ply, entity, physobject )

	return false

end

function GM:PlayerDisconnected( ply )
end

function GM:PlayerSay( ply, text, teamonly )

	return text

end

function GM:PlayerDeathThink( pl )
	return false
end

function GM:PlayerUse( ply, entity )

	return true

end

function GM:PlayerSilentDeath( Victim )
	return false
end

function GM:PlayerDeath( ply, inflictor, attacker )
	return false
end

function GM:PlayerInitialSpawn( pl, transiton )
	return false
end

function GM:PlayerSpawnAsSpectator( pl )

	pl:StripWeapons()

	if ( pl:Team() == TEAM_UNASSIGNED ) then

		pl:Spectate( OBS_MODE_FIXED )
		return

	end

	pl:SetTeam( TEAM_SPECTATOR )
	pl:Spectate( OBS_MODE_ROAMING )

end

function GM:PlayerSpawn( pl, transiton )

	if ( self.TeamBased && ( pl:Team() == TEAM_SPECTATOR || pl:Team() == TEAM_UNASSIGNED ) ) then

		self:PlayerSpawnAsSpectator( pl )
		return

	end

	pl:UnSpectate()

	pl:SetupHands()

	player_manager.OnPlayerSpawn( pl, transiton )
	player_manager.RunClass( pl, "Spawn" )

	if ( !transiton ) then
		hook.Call( "PlayerLoadout", GAMEMODE, pl )
	end

	hook.Call( "PlayerSetModel", GAMEMODE, pl )

end

function GM:PlayerSetModel( pl )

	player_manager.RunClass( pl, "SetModel" )

end

function GM:PlayerSetHandsModel( pl, ent )
	return false
end

function GM:PlayerLoadout( pl )

	player_manager.RunClass( pl, "Loadout" )

end

function GM:PlayerSelectTeamSpawn( TeamID, pl )

	local SpawnPoints = team.GetSpawnPoints( TeamID )
	if ( !SpawnPoints || table.IsEmpty( SpawnPoints ) ) then return end

	local ChosenSpawnPoint = nil

	for i = 0, 6 do

		local ChosenSpawnPoint = table.Random( SpawnPoints )
		if ( hook.Call( "IsSpawnpointSuitable", GAMEMODE, pl, ChosenSpawnPoint, i == 6 ) ) then
			return ChosenSpawnPoint
		end

	end

	return ChosenSpawnPoint

end

function GM:IsSpawnpointSuitable( pl, spawnpointent, bMakeSuitable )
	return false
end

function GM:PlayerSelectSpawn( pl, transiton )

	if ( transiton ) then return end

	if ( self.TeamBased ) then

		local ent = self:PlayerSelectTeamSpawn( pl:Team(), pl )
		if ( IsValid( ent ) ) then return ent end

	end

	if ( !IsTableOfEntitiesValid( self.SpawnPoints ) ) then

		self.LastSpawnPoint = 0
		self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( "info_player_counterterrorist" ) )
		self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( "info_player_terrorist" ) )

	end

	local Count = table.Count( self.SpawnPoints )

	if ( Count == 0 ) then
		Msg("[PlayerSelectSpawn] Error! No spawn points!\n")
		return nil
	end

	for k, v in pairs( self.SpawnPoints ) do

		if ( v:HasSpawnFlags( 1 ) && hook.Call( "IsSpawnpointSuitable", GAMEMODE, pl, v, true ) ) then
			return v
		end

	end

	local ChosenSpawnPoint = nil

	for i = 1, Count do

		ChosenSpawnPoint = table.Random( self.SpawnPoints )

		if ( IsValid( ChosenSpawnPoint ) && ChosenSpawnPoint:IsInWorld() ) then
			if ( ( ChosenSpawnPoint == pl:GetVar( "LastSpawnpoint" ) || ChosenSpawnPoint == self.LastSpawnPoint ) && Count > 1 ) then continue end

			if ( hook.Call( "IsSpawnpointSuitable", GAMEMODE, pl, ChosenSpawnPoint, i == Count ) ) then

				self.LastSpawnPoint = ChosenSpawnPoint
				pl:SetVar( "LastSpawnpoint", ChosenSpawnPoint )
				return ChosenSpawnPoint

			end

		end

	end

	return ChosenSpawnPoint

end

function GM:WeaponEquip( weapon )
	return true
end

function GM:ScalePlayerDamage( ply, hitgroup, dmginfo )
	return false
end

function GM:PlayerDeathSound()
	return true
end

function GM:SetupPlayerVisibility( pPlayer, pViewEntity )
	--AddOriginToPVS( vector_position_here )
end

function GM:OnDamagedByExplosion( ply, dmginfo )
	ply:SetDSP( 35, false )
end

function GM:CanPlayerSuicide( ply )
	return false
end

function GM:CanPlayerEnterVehicle( ply, vehicle, role )
	return true
end

function GM:CanExitVehicle( vehicle, passenger )
	return true
end

function GM:PlayerSwitchFlashlight( ply, SwitchOn )
	return ply:CanUseFlashlight()
end

function GM:PlayerCanJoinTeam( ply, teamid )

	local TimeBetweenSwitches = GAMEMODE.SecondsBetweenTeamSwitches or 10
	if ( ply.LastTeamSwitch && RealTime()-ply.LastTeamSwitch < TimeBetweenSwitches ) then
		ply.LastTeamSwitch = ply.LastTeamSwitch + 1
		ply:ChatPrint( Format( "Please wait %i more seconds before trying to change team again", ( TimeBetweenSwitches - ( RealTime() - ply.LastTeamSwitch ) ) + 1 ) )
		return false
	end

	if ( ply:Team() == teamid ) then
		ply:ChatPrint( "You're already on that team" )
		return false
	end

	return true

end

function GM:PlayerRequestTeam( ply, teamid )

	if ( !GAMEMODE.TeamBased ) then return end

	if ( !team.Joinable( teamid ) ) then
		ply:ChatPrint( "You can't join that team" )
	return end

	if ( !GAMEMODE:PlayerCanJoinTeam( ply, teamid ) ) then
	return end

	GAMEMODE:PlayerJoinTeam( ply, teamid )

end

function GM:PlayerJoinTeam( ply, teamid )

	local iOldTeam = ply:Team()

	if ( ply:Alive() ) then
		if ( iOldTeam == TEAM_SPECTATOR || iOldTeam == TEAM_UNASSIGNED ) then
			ply:KillSilent()
		else
			ply:Kill()
		end
	end

	ply:SetTeam( teamid )
	ply.LastTeamSwitch = RealTime()

	GAMEMODE:OnPlayerChangedTeam( ply, iOldTeam, teamid )

end

function GM:OnPlayerChangedTeam( ply, oldteam, newteam )

	if ( newteam == TEAM_SPECTATOR ) then

		local Pos = ply:EyePos()
		ply:Spawn()
		ply:SetPos( Pos )

	elseif ( oldteam == TEAM_SPECTATOR ) then

		ply:Spawn()

	else

	end

	PrintMessage( HUD_PRINTTALK, Format( "%s joined '%s'", ply:Nick(), team.GetName( newteam ) ) )

end

function GM:PlayerSpray( ply )

	return true

end

function GM:GetFallDamage( ply, flFallSpeed )

	if( GetConVarNumber( "mp_falldamage" ) > 0 ) then
		return ( flFallSpeed - 526.5 ) * ( 100 / 396 )
	end

	return 10

end

function GM:PlayerCanSeePlayersChat( strText, bTeamOnly, pListener, pSpeaker )

	if ( bTeamOnly ) then
		if ( !IsValid( pSpeaker ) || !IsValid( pListener ) ) then return false end
		if ( pListener:Team() != pSpeaker:Team() ) then return false end
	end

	return true

end

local sv_alltalk = GetConVar( "sv_alltalk" )

function GM:PlayerCanHearPlayersVoice( pListener, pTalker )

	local alltalk = sv_alltalk:GetInt()
	if ( alltalk >= 1 ) then return true, alltalk == 2 end

	return pListener:Team() == pTalker:Team(), false

end

function GM:NetworkIDValidated( name, steamid )
	-- MsgN( "GM:NetworkIDValidated", name, steamid )
end

function GM:PlayerShouldTaunt( ply, actid )

	return false

end

function GM:PlayerStartTaunt( ply, actid, length )
	return false
end

function GM:AllowPlayerPickup( ply, object )
	return true
end

function GM:PlayerDroppedWeapon( ply, weapon )
	return true
end

concommand.Add( "changeteam", function( pl, cmd, args ) hook.Call( "PlayerRequestTeam", GAMEMODE, pl, tonumber( args[ 1 ] ) ) end )