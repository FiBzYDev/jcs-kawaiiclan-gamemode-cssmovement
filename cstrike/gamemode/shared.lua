include( 'obj_player_extend.lua' )
include( 'player_shd.lua' )
include( 'player_class/player_default.lua' )

GM.Name			= "Counter Strike"
GM.Author		= "FiBzY"
GM.Email		= "jwolf2110@gmail.com"
GM.Website		= "cstrike"
GM.TeamBased	= false

function GM:PhysgunPickup( ply, ent )
	return false
end

function GM:PhysgunDrop( ply, ent )
	return false
end

function GM:GetGameDescription()
	return self.Name
end

function GM:CreateTeams()
	if ( !GAMEMODE.TeamBased ) then return end
end

function GM:ShouldCollide( Ent1, Ent2 )
	return false
end

function GM:OnViewModelChanged( vm, old, new )
	return false
end

function GM:CanProperty( pl, property, ent )
	return false
end