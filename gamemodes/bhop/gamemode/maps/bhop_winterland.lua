-- shit lag
__HOOK[ "InitPostEntity" ] = function()
	for _,ent in pairs( ents.FindByClass( "env_sun" ) ) do
		ent:Remove()
	end	
end