ENT.Type = "anim"
ENT.Base = "base_anim"

if SERVER then
	AddCSLuaFile()
	
	function ENT:Initialize()
		self:SetModel( "models/hunter/blocks/cube025x025x025.mdl" )
		
		self:SetMoveType( MOVETYPE_NONE )
		self:SetSolid( SOLID_VPHYSICS )

		self:PhysicsInitBox( self.min, self.max )
		self:SetCollisionBounds( self.min, self.max )

		local phys = self:GetPhysicsObject()
		if IsValid( phys ) then
			phys:EnableMotion( false )
		end
end
