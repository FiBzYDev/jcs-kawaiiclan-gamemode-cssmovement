-- shit lag
__HOOK[ "InitPostEntity" ] = function()

	for _,ent in pairs( ents.FindByClass( "prop_static" ) ) do
		ent:Remove()
	end
end