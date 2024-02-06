local meta = FindMetaTable( "Player" )
if ( !meta ) then return end

function meta:AddFrozenPhysicsObject( ent, phys )
	return false
end

local function PlayerUnfreezeObject( ply, ent, object )
	return false
end

function meta:PhysgunUnfreeze()
	return false
end

function meta:UnfreezePhysicsObjects()
	return false
end

local g_UniqueIDTable = {}

function meta:UniqueIDTable( key )

	local id = 0
	if ( SERVER ) then id = self:UniqueID() end

	g_UniqueIDTable[ id ] = g_UniqueIDTable[ id ] or {}
	g_UniqueIDTable[ id ][ key ] = g_UniqueIDTable[ id ][ key ] or {}

	return g_UniqueIDTable[ id ][ key ]

end

function meta:GetEyeTrace()
	return false
end

function meta:GetEyeTraceNoCursor()
	return false
end