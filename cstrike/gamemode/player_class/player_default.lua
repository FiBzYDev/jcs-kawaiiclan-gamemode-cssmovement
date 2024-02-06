AddCSLuaFile()

sqrt = math.sqrt

local PLAYER = {}

PLAYER.DisplayName = "Counter Strike: Source";

PLAYER.WalkSpeed = 260;
PLAYER.RunSpeed = 135.4;

PLAYER.JumpPower = sqrt(2 * 800 * 57.0)

// Expose our interface.
PLAYER.CrouchedWalkSpeed = 0.34;
PLAYER.DuckSpeed = 2/5;
PLAYER.UnDuckSpeed = 1/5;

PLAYER.CanUseFlashlight = false;
PLAYER.MaxHealth = 0;
PLAYER.StartArmor = 0;
PLAYER.StartHealth = 100;

PLAYER.DropWeaponOnDie = true;
PLAYER.TeammateNoCollide = true;
PLAYER.AvoidPlayers = false;

function PLAYER:SetupDataTables()

end

function PLAYER:Init()

end

function PLAYER:Spawn()

end

function PLAYER:Loadout()

	self.Player:Give( "weapon_pistol" )
	self.Player:GiveAmmo( 999, "Pistol", true )

end
player_manager.RegisterClass( "player_default", PLAYER, nil )