function GM:CalcView( ply, origin, angles, fov, znear, zfar )
	return true
end

function GM:Initialize()
	GAMEMODE.ShowScoreboard = false
end

function GM:HUDShouldDraw( name )
	return false
end

function GM:HUDPaint()
	return false
end

function GM:GUIMouseDoublePressed( mousecode, AimVector )
	return false
end

function GM:GetTeamColor( ent )

	local team = TEAM_UNASSIGNED
	if ( ent.Team ) then team = ent:Team() end
	return GAMEMODE:GetTeamNumColor( team )

end

function GM:GetTeamNumColor( num )

	return team.GetColor( num )

end

function GM:OnPlayerChat( player, strText, bTeamOnly, bPlayerIsDead )

	local tab = {}

	if ( bPlayerIsDead ) then
		table.insert( tab, Color( 255, 30, 40 ) )
		table.insert( tab, "*DEAD* " )
	end

	if ( bTeamOnly ) then
		table.insert( tab, Color( 30, 160, 40 ) )
		table.insert( tab, "(TEAM) " )
	end

	if ( IsValid( player ) ) then
		table.insert( tab, player )
	else
		table.insert( tab, "Console" )
	end

	table.insert( tab, Color( 255, 255, 255 ) )
	table.insert( tab, ": " .. strText )

	chat.AddText( unpack(tab) )
	
	surface.PlaySound("common/talk.wav")
	return true

end

function GM:OnChatTab( str )

	str = string.TrimRight(str)

	local LastWord
	for word in string.gmatch( str, "[^ ]+" ) do
		LastWord = word
	end

	if ( LastWord == nil ) then return str end

	for k, v in pairs( player.GetAll() ) do

		local nickname = v:Nick()

		if ( string.len( LastWord ) < string.len( nickname ) && string.find( string.lower( nickname ), string.lower( LastWord ), 0, true ) == 1 ) then

			str = string.sub( str, 1, ( string.len( LastWord ) * -1 ) - 1 )
			str = str .. nickname
			return str

		end

	end

	return str

end

function GM:StartChat( teamsay )

	return false

end

function GM:ChatText( playerindex, playername, text, filter )

	if ( filter == "chat" ) then
		Msg( playername, ": ", text, "\n" )
	else
		Msg( text, "\n" )
	end

	return false

end

function GM:PlayerStepSoundTime( ply, iType, bWalking )

	local fStepTime = 300
	local fMaxSpeed = ply:GetMaxSpeed()

	if ( iType == STEPSOUNDTIME_NORMAL || iType == STEPSOUNDTIME_WATER_FOOT ) then
		if ( fMaxSpeed <= 100 ) then
			fStepTime = 400
		elseif ( fMaxSpeed <= 300 ) then
			fStepTime = 300
		else
			fStepTime = 300
		end
	elseif ( iType == STEPSOUNDTIME_ON_LADDER ) then
		fStepTime = 350
	elseif ( iType == STEPSOUNDTIME_WATER_KNEE ) then
		fStepTime = 600
	end

	if ( ply:Crouching() ) then
		fStepTime = fStepTime + 500
	end

	return fStepTime

end

function GM:OnAchievementAchieved( ply, achid )
	return false
end

function GM:PreDrawViewModel( ViewModel, Player, Weapon )

	if ( !IsValid( Weapon ) ) then return false end

	player_manager.RunClass( Player, "PreDrawViewModel", ViewModel, Weapon )

	if ( Weapon.PreDrawViewModel == nil ) then return false end
	return Weapon:PreDrawViewModel( ViewModel, Weapon, Player )

end

function GM:PostDrawViewModel( ViewModel, Player, Weapon )

	if ( !IsValid( Weapon ) ) then return false end

	if ( Weapon.UseHands || !Weapon:IsScripted() ) then

		local hands = Player:GetHands()
		if ( IsValid( hands ) && IsValid( hands:GetParent() ) ) then

			if ( not hook.Call( "PreDrawPlayerHands", self, hands, ViewModel, Player, Weapon ) ) then

				if ( Weapon.ViewModelFlip ) then render.CullMode( MATERIAL_CULLMODE_CW ) end
				hands:DrawModel()
				render.CullMode( MATERIAL_CULLMODE_CCW )

			end

			hook.Call( "PostDrawPlayerHands", self, hands, ViewModel, Player, Weapon )

		end

	end

	player_manager.RunClass( Player, "PostDrawViewModel", ViewModel, Weapon )

	if ( Weapon.PostDrawViewModel == nil ) then return false end
	return Weapon:PostDrawViewModel( ViewModel, Weapon, Player )

end

function GM:DrawPhysgunBeam( ply, weapon, bOn, target, boneid, pos )
	return false
end

function GM:PreventScreenClicks( cmd )
	return false
end

function GM:PlayerClassChanged( ply, newID )

	if ( newID < 1 ) then return end

	local classname = util.NetworkIDToString( newID )
	if ( !classname ) then return end

	player_manager.SetPlayerClass( ply, classname )

end