include( 'shared.lua' )
include( 'player.lua' )

function GM:DoPlayerDeath( ply, attacker, dmginfo )

	ply:CreateRagdoll()
	
	ply:AddDeaths( 1 )
	
	if ( attacker:IsValid() && attacker:IsPlayer() ) then
	
		if ( attacker == ply ) then
			attacker:AddFrags( -1 )
		else
			attacker:AddFrags( 1 )
		end
	
	end

end

function GM:PlayerShouldTakeDamage( ply, attacker )
	return false
end

function GM:EntityTakeDamage( ent, info )
	return false
end

function GM:PlayerHurt( player, attacker, healthleft, healthtaken )
	return false
end

local function HostnameThink()
	return false
end

function GM:ShowTeam( ply )
	if ( !GAMEMODE.TeamBased ) then return end
end

function GM:VehicleMove( ply, vehicle, mv )
	return false
end