if (SERVER) then
	AddCSLuaFile("shared.lua")
end

if (CLIENT) then
	SWEP.PrintName 		= "AWP"
	SWEP.ViewModelFOV		= 77
	SWEP.Slot 			= 3
	SWEP.SlotPos 		= 1
	SWEP.IconLetter 		= "r"

	killicon.AddFont("weapon_awp", "CSKillIcons", SWEP.IconLetter, Color( 255, 80, 0, 255 ))
end

/*-------------------------------------------------------*/


SWEP.Category			= "Counter-Strike"

SWEP.Base				= "weapon_cs_base"

SWEP.HoldType 		= "ar2"

SWEP.Spawnable 			= true
SWEP.AdminSpawnable 		= true

SWEP.ViewModel 			= "models/weapons/v_snip_awp.mdl"
SWEP.WorldModel 			= "models/weapons/w_snip_awp.mdl"

SWEP.Primary.Sound 		= Sound("Weapon_awp.Single")
SWEP.Primary.Damage 		= 80
SWEP.Primary.Recoil 		= 6
SWEP.Primary.NumShots 		= 1
SWEP.Primary.Cone 		= 0.0001
SWEP.Primary.ClipSize 		= 10
SWEP.Primary.Delay 		= 1.2
SWEP.Primary.DefaultClip 	= 40
SWEP.Primary.Automatic 		= false
SWEP.Primary.Ammo 		= "smg1"


-- Weapon Variations
SWEP.UseScope				= true -- Use a scope instead of iron sights.
SWEP.ScopeScale 			= 0.55 -- The scale of the scope's reticle in relation to the player's screen size.
SWEP.ScopeZoom				= 6
--Only Select one... Only one.
SWEP.ScopeReddot		= false
SWEP.ScopeNormal		= true
SWEP.ScopeMs			= false
SWEP.BoltAction			= true --Self Explanatory
-- Accuracy
SWEP.CrouchCone				= 0.0001 -- Accuracy when we're crouching
SWEP.CrouchWalkCone			= 0.5 -- Accuracy when we're crouching and walking
SWEP.WalkCone				= 0.5 -- Accuracy when we're walking
SWEP.AirCone				= 0.5 -- Accuracy when we're in air
SWEP.StandCone				= 0.0001 -- Accuracy when we're standing still