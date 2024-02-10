GM.Name = "Bunny Hop"
GM.DisplayName = "Bunny Hop"
GM.Author = "fibzy, Niflheimrx, justa, claz, George, and Gravoius"
GM.Email = "hello@fastdl.me"
GM.Website = "https://fastdl.me/"
GM.TeamBased = true

DeriveGamemode( "base" )
DEFINE_BASECLASS( "gamemode_base" )

_C = _C or {}
_C["Version"] = 1.44
_C["PageSize" ] = 7
_C["GameType"] = "bhop"
_C["ServerName"] = "kawaiiclan"
_C["Identifier"] = "jsc-" .. _C.GameType
_C["SteamGroup"] = ""
_C["MaterialID"] = "flow"

_C["Team"] = { Players = 1, Spectator = TEAM_SPECTATOR }
_C["Style"] = { Normal = 1, SW = 2, HSW = 3, ["W-Only"] = 4, ["A-Only"] = 5, Legit = 6, ["Easy Scroll"] = 7, Bonus = 8, Segment = 9, AutoStrafe = 10 }

-- These constants are defined from Valve's SDK 2013 --
local VEC_HULL_MIN = Vector(-16, -16, 0)
local VEC_HULL_MAX = Vector(16, 16, 64)
local VEC_VIEW     = Vector(0, 0, 62)

local VEC_DUCK_HULL_MIN = Vector(-16, -16, 0)
local VEC_DUCK_HULL_MAX = Vector(16, 16, 47)
local VEC_DUCK_VIEW     = Vector(0, 0, 45)

local DUCK_SPEED_MULTIPLIER = 0.34

local TIME_TO_UNDUCK = 0.2
local TIME_TO_DUCK   = 0.4

local EYE_CLEARANCE = 12

// rounding error ported - hulls are higher on CS:S
local DIST_EPSILON = (0.031311) - (0.031250)
local DIST_EPSILON2 = (0.031296) - (0.031250)

local viewDeltaBase, viewDelta, hullSizeNormal, hullSizeCrouch, g_cspos_view, newOrigin, flGroundFactor = 0.5, -0.5, 45, 62, 62, 0.5 + 1.47, 1.5

_C["Player"] = {
	DefaultModel = "models/player/overgrowth/rabbit_playermodel.mdl",
	DefaultWeapon = "weapon_glock",
	ScrollPower = 268.4,
	StepSize = 18,

	JumpHeightDefault = math.sqrt(2 * 800 * 57.0) - flGroundFactor,
	JumpHeight = math.sqrt(2 * 800 * 57.0),
	StrafeMultiplier = 30 or 32.4,
	AirAcceleration = 1000,

	HullMin = Vector( -16, -16, 0 ),
	HullDuck = Vector( 16, 16, 45 ),
	HullStand = Vector( 16, 16, game.GetMap() == "bhop_kz_backalley" and viewDeltaBase * ( hullSizeNormal - hullSizeCrouch ) + 62 + 0.5 + 1.445313 or viewDeltaBase * ( hullSizeNormal - hullSizeCrouch ) + 62 + 0.5 + 0.1 ),
	HullMax = Vector( 16, 16, 62 ),
	ViewDuck = Vector( 0, 0, DIST_EPSILON2 + 47 ),
	ViewStand = Vector( 0, 0, DIST_EPSILON + viewDeltaBase * ( hullSizeNormal - hullSizeCrouch ) + 64 or 64 ),
	ViewOffset = Vector( 0, 0, viewDelta * ( hullSizeNormal - hullSizeCrouch ) or 0 ),
	ViewBase = Vector( 0, 0, 0 )
}

_C["Prefixes"] = {
	["Timer"] = Color( 52, 131, 218 ),
	["Server"] = Color( 156, 91, 26 ),
	["Admin"] = Color( 156, 91, 26 ),
	["Notification"] = Color( 156, 91, 26 ),
	[_C["ServerName"]] = Color( 46, 204, 113 ),
	["Radio"] = Color( 230, 126, 34 ),
	["VIP"] = Color( 174, 0, 255 ),
	["jAntiCheat"] = Color(186, 85, 211)
}

_C["Ranks"] = {
	{ "Starter", Color( 255, 255, 255 ) },
	{ "Slave", Color( 166, 166, 166 ) },
	{ "Grunt", Color( 255, 255, 98 ) },
	{ "Squire", Color( 101, 67, 33 ) },
	{ "Snail", Color( 250, 218, 221 ) },
	{ "Freshman", Color( 80, 80, 80 ) },
	{ "Amateur", Color( 0, 8, 8 ) },
	{ "Crawler", Color( 96, 16, 176 ) },
	{ "Private", Color( 206, 255, 157 ) },
	{ "Peasant", Color( 128, 128, 128 ) },
	{ "Learning", Color( 255, 192, 203 ) },
	{ "Advanced", Color( 0, 50, 32 ) },
	{ "Experienced", Color( 0, 0, 60 ) },
	{ "Mortal", Color( 196, 255, 196 ) },
	{ "Impressive", Color( 255, 128, 0 ) },
	{ "Professional", Color( 0, 0, 139 ) },
	{ "Centurion", Color( 196, 255, 196 ) },
	{ "Admired", Color( 30, 166, 48 ) },
	{ "Executioner", Color( 98, 0, 0 ) },
	{ "Elite", Color( 255, 255, 0 ) },
	{ "Legendary", Color( 128, 0, 128 ) },
	{ "Famous", Color( 0, 168, 255 ) },
	{ "Champion", Color( 255, 101, 0 ) },
	{ "Zombie", Color( 0, 255, 128 ) },
	{ "Genius", Color( 170, 0, 0 ) },
	{ "Brawler", Color( 0, 255, 191 ) },
	{ "Lunatic", Color( 139, 0, 0 ) },
	{ "Bishop", Color( 190, 255, 0 ) },
	{ "Psycho", Color( 255, 0, 255 ) },
	{ "Demon", Color( 255, 0, 0 ) },
	{ "Pharaoh", Color( 92, 196, 207 ) },
	{ "Immortal", Color( 255, 235, 0 ) },
	{ "Insane", Color( 0, 255, 0 ) },
	{ "Beast", Color( 0, 0, 255 ) },
	{ "Colossus", Color( 0, 255, 255 ) },
	{ "Nightmare", Color( 255, 0, 42 ) },
	
	[-1] = { "Retrieving...", Color( 255, 255, 255 ) },
	[-2] = { "Record Replay", Color( 255, 0, 0 ) }
}


-- Hogs
hook.Add("InitPostEntity","RemoveWidgets",function()
	hook.Remove("PlayerTick", "TickWidgets")
end)

hook.Add("Move","Move",function()
	hook.Remove("Move", "Move")
end)

hook.Add("CreateMove","CreateMove",function()
	hook.Remove("CreateMove", "CreateMove")
end)

hook.Add("SetupMove","SetupMove",function()
	hook.Remove("SetupMove", "SetupMove")
end)

hook.Add("FinishMove","FinishMove",function()
	hook.Remove("FinishMove", "FinishMove")
end)

hook.Add("StartMove","StartMove",function()
	hook.Remove("StartMove", "StartMove")
end)

function GM:PlayerButtonDown( ply, btn ) return true end
function GM:PlayerButtonUp( ply, btn ) return true end

hook.Add("PlayerButtonDown","PlayerButtonDown",function()
	hook.Remove("PlayerButtonDown", "PlayerButtonDown")
end)

hook.Add("PlayerButtonUp","PlayerButtonUp",function()
	hook.Remove("PlayerButtonUp", "PlayerButtonUp")
end)

function GM:OnUndo() return true end
function GM:CreateMove( ply, mv, cmd ) return true end
function GM:Move( ply, mv ) return true end
function GM:SetupMove( ply, mv, cmd ) return true end
function GM:FinishMove( ply, mv, cmd ) return false end
function GM:StartMove( ply, mv, cmd ) return true end
function GM:EntityEmitSound() return true end

-- Normal GMod AirDensity 
physenv.SetAirDensity( 0 )

-- Custom client run commands for different maps
timer.Create( "ratefix", 2, 1, function()
for k,v in pairs(player.GetAll()) do
		v:ConCommand( "rate 1000000000" )
	end
end)

timer.Create( "interp", 2, 1, function()
for k,v in pairs(player.GetAll()) do
		v:ConCommand( "cl_interp 0.100000 " )
	end
end)

timer.Create( "cmdrate", 2, 1, function()
for k,v in pairs(player.GetAll()) do
		v:ConCommand( "cl_cmdrate 80000000000000000000000000000000000000" )
	end
end)

timer.Create( "painter", 2, 1, function()
	for k,v in pairs(player.GetAll()) do
		v:ConCommand( "r_decals 100" )
	end
end)

timer.Create( "nervy", 2, 1, function()
	for k,v in pairs(player.GetAll()) do
 	if game.GetMap() == "bhop_nervosity2" then
			v:ConCommand( "kawaii_map_brightness .8" )
		end
	end
end)

timer.Create( "dicy", 2, 1, function()
	for k,v in pairs(player.GetAll()) do
	if game.GetMap() == "bhop_dice" then
			v:ConCommand( "kawaii_map_brightness 1.16" )
		end
	end
end)

KAWAIISTMAPCHANGE = {}
KAWAIISTMAPCHANGE.Enabled = CreateClientConVar( "kawaii_mapchangestriggers", "1", true, false, "Enables map change show triggers" )

local KAWAIISTMAPCHANGE = KAWAIISTMAPCHANGE.Enabled:GetBool()
timer.Create( "mapchangest", 1, 1, function()
	for k,v in pairs(player.GetAll()) do
		if KAWAIISTMAPCHANGE then
			v:ConCommand( "showtriggers_enabled 1" )
		end
	end
end)

timer.Create( "mody", 2, 1, function()
	for k,v in pairs(player.GetAll()) do
	if game.GetMap() == "bhop_moderated" then
			v:ConCommand( "kawaii_map_brightness 1.3" )
		end
	end
end)

timer.Create( "bloody", 2, 1, function()
	for k,v in pairs(player.GetAll()) do
 	if game.GetMap() == "bhop_bloodflow" then
			v:ConCommand( "kawaii_map_color 1.8" )
		end
	end
end)

timer.Create( "calm", 2, 1, function()
	for k,v in pairs(player.GetAll()) do
 	if game.GetMap() == "bhop_calming" then
			v:ConCommand( "kawaii_map_color 1.3" )
		end
	end
end)

timer.Create( "overy", 3, 1, function()
	for k,v in pairs(player.GetAll()) do
 	if game.GetMap() == "bhop_overline" then
			v:ConCommand( "kawaii_map_color 2" )
		end
	end
end)

timer.Create( "forrq", 2, 1, function()
	for k,v in pairs(player.GetAll()) do
	 if game.GetMap() == "bhop_0000" then
			v:ConCommand( "kawaii_map_brightness 3" )
		end
	end
end)

timer.Create( "forvehnex1", 3, 1, function()
	for k,v in pairs(player.GetAll()) do
	if game.GetMap() == "bhop_overline" then
			v:ConCommand( "mat_bloomscale 0" )
		end
	end
end)

timer.Create( "forvehnex2", 2, 1, function()
	for k,v in pairs(player.GetAll()) do
	if game.GetMap() == "bhop_overline_sof" then
			v:ConCommand( "mat_bloomscale 0" )
		end
	end
end)

timer.Create( "forvehnex", 2, 1, function()
	for k,v in pairs(player.GetAll()) do
	if game.GetMap() == "bhop_alt_univaje" then
			v:ConCommand( "mat_bloomscale 1" )
		 end
	end
end)

if game.GetMap() == "bhop_aux_a9" then
	_C.Player.JumpPower = math.sqrt( 2 * 800 * 57.0 )
end

util.PrecacheModel( _C.Player.DefaultModel )

include( "core_player.lua" )

local mc, mp = math.Clamp, math.pow
local bn, ba, bo = bit.bnot, bit.band, bit.bor
local sl, ls = string.lower, {}
local lp, ft, ct, gf = LocalPlayer, FrameTime, CurTime, {}

function GM:PlayerNoClip( ply )
	if game.GetMap() == "bhop_exodus" then return false end
	local nStyle = SERVER and ply.Style or Timer.Style

	-- Edited: new practice 
	local practice = ply:GetNWInt("inPractice", false)
	if (not practice) and (ply.Tn) or (ply.Tb) then 
		if (SERVER) then 
			Core:Send(ply, "Print", {"Timer", "Your timer has been stopped due to the use of noclip."})
			ply:StopAnyTimer()
			ply:SetNWInt("inPractice", true)

			return true
		end
	end

	return practice
end

function GM:PlayerUse( ply )
	if game.GetMap() == "bhop_cobblestone" then return false end
	if not ply:Alive() then return false end
	if ply:Team() == TEAM_SPECTATOR then return false end
	if ply:GetMoveType() != MOVETYPE_WALK then return false end
	
	return true
end

function GM:CreateTeams()
	team.SetUp( _C.Team.Players, "Players", Color( 255, 50, 50, 255 ), false )
	team.SetUp( _C.Team.Spectator, "Spectators", Color( 50, 255, 50, 255 ), true )
	team.SetSpawnPoint( _C.Team.Players, { "info_player_terrorist", "info_player_counterterrorist" } )
end

-- Useful metafunctions, mainly here to easily use them in movement code --
do
	local META = FindMetaTable "Player"

	function META:FullyDucked()
		return self:KeyDown(IN_DUCK) and self:IsFlagSet(FL_DUCKING)
	end

	function META:Ducking()
		return self:KeyDown(IN_DUCK) and !self:IsFlagSet(FL_DUCKING)
	end

	function META:UnDucking()
		return !self:KeyDown(IN_DUCK) and self:IsFlagSet(FL_DUCKING)
	end

	function META:NotDucked()
		return !self:Ducking() and !self:FullyDucked() and !self:UnDucking()
	end

	function META:HoldingSpace()
		return self:KeyDown(IN_JUMP)
	end

	-- This will prune (slow) player's movement at their current location --
	function META:PruneMovement()
		local vel = self:GetVelocity()
		local dir = vel:GetNormalized()

		self:SetVelocity(-vel + dir * 290)
	end

	-- This is used for some styles in order to override gravity changes --
	function META:OverrideGravity(gravity)
		local currentGravity = self:GetGravity()
		if self.Freestyle then
			self:SetGravity(0)
		elseif (math.floor(currentGravity * 10) / 10 != gravity) then
			if (currentGravity == 0) then
				self:SetGravity(gravity)
			elseif (currentGravity == 1) then
				-- Runs on the next tick --
				timer.Simple(0, function()
					self:SetGravity(gravity)
				end)
			end
		end
	end
end

-- Set MaxSpeed to the highest possabile for better movement smoothness
hook.Add( "Move", "SetMaxSpeed", function( ply, mv, usrcmd )
	if ply:IsOnGround() and ply:Crouching() then 
	else
		mv:SetMaxSpeed( math.huge )
	end
end )

-- JSS Base
local mabs, matan, mdeg, NormalizeAngle = math.abs, math.atan, math.deg, math.NormalizeAngle

local function GetPerfectYaw(mv, speed)
	return speed == 0 and 0 or mabs(mdeg(matan(mv/speed)))
end

-- Taken from justa's
local StrafeAxis = 0 -- Saves the last eye angle yaw for checking mouse movement
local StrafeButtons = nil -- Saves the buttons from SetupMove for displaying
local StrafeCounter = 0 -- Holds the amount of strafes
local StrafeLast = nil -- Your last strafe key for counting strafes
local StrafeDirection = nil -- The direction of your strafes used for displaying
local StrafeStill = 0 -- Counter to reset mouse movement

local function norm( i ) if i > 180 then i = i - 360 elseif i < -180 then i = i + 360 end return i end -- Custom function to normalize eye angles
local StrafeData -- Your Sync value is stored here
local KeyADown, KeyDDown -- For displaying on the HUD
local MouseLeft, MouseRight --- For displaying on the HUD
local LastUpdate = CurTime()

-- Strafe angles
local function StrafeInput( ply, data )
	local ang = data:GetAngles().y

	if not ply:IsFlagSet(FL_ONGROUND + FL_INWATER) and ply:GetMoveType() == MOVETYPE_WALK then 
		local difference = norm( ang - StrafeAxis )
		local l, r = bit.band( data:GetOldButtons(), IN_MOVELEFT ) > 0, bit.band( data:GetOldButtons(), IN_MOVERIGHT ) > 0

		if difference != 0 then 
			if l or r then 
				if LastUpdate + 0.02 > CurTime() then return end 
				LastUpdate = CurTime() + 0.02
				if difference > 0 then
					if (l and not r) and StrafeDirection != IN_MOVELEFT and data:GetSideSpeed() < 0 then 
						StrafeDirection = IN_MOVELEFT 
					end
				elseif difference < 0 then
					if (r and not l) and StrafeDirection != IN_MOVERIGHT and data:GetSideSpeed() > 0 then 
						StrafeDirection = IN_MOVERIGHT 
					end
				end
			end
		end
	end

	StrafeAxis = ang 
end
hook.Add( "SetupMove", "StrafeInput", StrafeInput )

hook.Add("SetupMove","SetMaxClientSpeed", function( ply, mv )
	 if ply:KeyDown(IN_WALK) then 
		 mv:SetMaxClientSpeed( 150 )
	 end

	 if ply:KeyDown(IN_DUCK) and !ply:IsFlagSet(FL_DUCKING) then 
		 mv:SetMaxClientSpeed( 88.4 )
	 end
end )

-- Bunny Hop Movement --
-- The following below is movement from Flow v10.0 --
do

	local mc, ft = math.Clamp, FrameTime
	function GM:Move(ply, data)
		-- Does the player exist in this tick? --
		if !IsValid(ply) then return end

		-- Reduce clientside computes by checking if the player is alive and only checking the localplayer --
		if !ply:Alive() then return end
		if lpc and (lpc != ply) then return end

		-- This hook shouldn't run if we are on the ground --
		if ply:OnGround() then return end

		-- Default CSS Bunny Hop Settings --
		local aa, mv = 1000.0, 30
		local aim = data:GetMoveAngles(ply:GetAngles() - Angle(-100, -100, 0))
		local forward, right = aim:Forward(), aim:Right()
		local fmove, smove = data:GetForwardSpeed(), data:GetSideSpeed()

		local st = ply.Style
		local sideadd, foreadd = 100000, 100000
		local styleAirAccelerate, styleGain, styleGravity, styleSide, styleFore = ply.Style
		if styleSide or styleFore then
			sideadd = styleSide or sideadd
			foreadd = styleFore or foreadd
		end

		if styleAirAccelerate or styleGain or styleGravity then
			aa, mv = styleAirAccelerate or aa, styleGain or mv

			if styleGravity then
				ply:OverrideGravity(styleGravity)
			end
		end

		if st == 1 then
			if data:KeyDown( IN_MOVERIGHT ) then
				smove = (smove* 10) + 100000
			elseif data:KeyDown( IN_MOVELEFT ) then
				smove = (smove* 10) - 100000
			end
		end

		if st == 8 then
			if data:KeyDown( IN_MOVERIGHT ) then
				smove = (smove* 10) + 100000
			elseif data:KeyDown( IN_MOVELEFT ) then
				smove = (smove* 10) - 100000
			end
		end

		if st == 9 then
			if data:KeyDown( IN_MOVERIGHT ) then
				smove = (smove* 10) + 100000
			elseif data:KeyDown( IN_MOVELEFT ) then
				smove = (smove* 10) - 100000
			end
		end

		-- Some styles might have limits on specific movement angles, this properly gives strafe speed if we aren't limited --
		if (smove != 0) then
			if data:KeyDown(IN_MOVERIGHT) then smove = smove + sideadd end
			if data:KeyDown(IN_MOVELEFT) then smove = smove - sideadd end
		end

		-- Has to be in another if statement because there's a possibility we are being limited on both angles --
		if (fmove != 0) then
			if data:KeyDown(IN_FORWARD) then fmove = fmove + foreadd end
			if data:KeyDown(IN_BACK) then fmove = fmove - foreadd end
		end

		forward.z, right.z = 0,0
		forward:Normalize(ply:GetAngles() - Angle(-100, -100, 0))
		right:Normalize(ply:GetAngles() - Angle(-100, -100, 0))

		local wishvel = forward * fmove + right * smove
		wishvel.z = 0

		local wishspeed = wishvel:Length(ply:GetAngles() - Angle(-100, -100, 0))
		if wishspeed > data:GetMaxSpeed(ply:GetAngles() - Angle(-100, -100, 0)) then
			wishvel = wishvel * (data:GetMaxSpeed(ply:GetAngles() - Angle(-100, -100, 0)) / wishspeed)
			wishspeed = data:GetMaxSpeed(ply:GetAngles() - Angle(-100, -100, 0))
		end

		local vel = data:GetVelocity()
		local wishspd = wishspeed

		wishspd = mc( wishspd, 0, mv )

		local wishdir = wishvel:GetNormal(ply:GetAngles() - Angle(-100, -100, 0))
		local current = vel:Dot(wishdir)

		-- Gain Stats
		if SERVER and (not ply:IsBot()) then 
			local gaincoeff = 0
			ply.tick = (ply.tick or 0) + 1
	
		if (current ~= 0) and (wishspd ~= 0) and (current < 30) then 
			gaincoeff = (wishspd - math.abs(current)) / wishspd
			ply.rawgain = ply.rawgain + gaincoeff

			JAC:CheckFrame(ply, gaincoeff, smove)
			end
		end

		local addspeed = wishspd - current
		if addspeed <= 0 then return end

		local accelspeed = aa * ft() * wishspeed
		if accelspeed > addspeed then
			accelspeed = addspeed
		end

		vel = vel + (wishdir * accelspeed)

		if not game.GetMap() == "bhop_kasvihuone" then
			vel.z = vel.z - (ply:GetGravity() * 800 * FrameTime() * 0.5)
		end

		data:SetVelocity(vel)

		return false
	end
end

local lp, Iv, Ip, ft, ic, is, isl, ct, gf, ds, du, pj, og = LocalPlayer, IsValid, IsFirstTimePredicted, FrameTime, CLIENT, SERVER, MOVETYPE_LADDER, CurTime, {}, {}, {}, {}, {}

local BHOP_TIME = 12
local g_groundTicks = {}
local g_storedVelocity = {}
local g_longGround = {}

local function ChangeMove(ply, data)
	if not IsValid( ply ) or ply:IsBot() then return end

	if not g_groundTicks[ ply ] then
		g_groundTicks[ ply ] = 0

		return
	end

	local st = ply.Style

	if not ply:IsOnGround() then
		if g_groundTicks[ ply ] ~= 0 then
			g_groundTicks[ ply ] = 0
			g_storedVelocity[ ply ] = nil
			g_longGround[ ply ] = false

			ply:SetDuckSpeed( 0.4 )
			ply:SetUnDuckSpeed( 0.2 )

			if _C.Player.HullStand != _C.Player.HullMax then
				ply:SetHull( _C.Player.HullMin, _C.Player.HullStand )
			end

		end

		if not ply.Freestyle and ply:GetMoveType() != 8 then
			if st == _C.Style["SW"] or st == _C.Style["W-Only"] or st == _C.Style["S-Only"] then
				data:SetSideSpeed( 0 )

				if st == _C.Style["W-Only"] and data:GetForwardSpeed() < 0 then
					data:SetForwardSpeed( 0 )
				elseif st == _C.Style["S-Only"] and data:GetForwardSpeed() > 0 then
					data:SetForwardSpeed( 0 )
				end
			elseif st == _C.Style["A-Only"] then
				data:SetForwardSpeed( 0 )

				if data:GetSideSpeed() > 0 then
					data:SetSideSpeed( 0 )
				end
			elseif st == _C.Style["D-Only"] then
				data:SetForwardSpeed( 0 )

				if data:GetSideSpeed() < 0 then
					data:SetSideSpeed( 0 )
				end
			elseif st == _C.Style["HSW"] then
				if ib and ba( data:GetButtons(), 16 ) > 0 then
					local bd = data:GetButtons()
					if ba( bd, 512 ) > 0 or ba( bd, 1024 ) > 0 then
						data:SetForwardSpeed( 0 )
						data:SetSideSpeed( 0 )
					end
				end

				if data:GetForwardSpeed() == 0 or data:GetSideSpeed() == 0 then
					data:SetForwardSpeed( 0 )
					data:SetSideSpeed( 0 )
				end
			elseif st == _C.Style["SHSW"] then
				if ( data:GetForwardSpeed() >= 0 and data:GetSideSpeed() >= 0 ) then
					data:SetSideSpeed( 0 )
					data:SetForwardSpeed( 0 )
				end


				if ( data:GetForwardSpeed() <= 0 and data:GetSideSpeed() <= 0 ) then
					data:SetSideSpeed( 0 )
					data:SetForwardSpeed( 0 )
				end
			end
		end

		if ic and ply.Gravity != nil then
			if ply.Gravity or ply.Freestyle then
				ply:SetGravity( 0 )
			else
				ply:SetGravity( plg )
			end
		end

		return
	end

	if g_groundTicks[ ply ] > BHOP_TIME then
		if g_longGround[ ply ] then return end

		if st == _C.Style["Easy Scroll"] then
			ply:SetJumpPower( _C.Player.JumpPower )
		end

		if _C.Player.HullStand != _C.Player.HullMax and not util.TraceLine( { filter = ply, mask = MASK_PLAYERSOLID, start = ply:EyePos(), endpos = ply:EyePos() + Vector( 0, 0, 24 ) } ).Hit then
			ply:SetHull( _C.Player.HullMin, _C.Player.HullMax )
		end

		if _C.Player.HullStand != _C.Player.HullMax and util.TraceLine( { filter = ply, mask = MASK_PLAYERSOLID, start = ply:EyePos(), endpos = ply:EyePos() + Vector( 0, 0, 14 ) } ).Hit then
			ply:SetMaxSpeed( 88.40 )
			ply:SetRunSpeed( 2.30 )
		end

		ply:SetDuckSpeed( 0.4 )
		ply:SetUnDuckSpeed( 0.2 )

		g_longGround[ ply ] = true

		return
	end

	if Core.Util:GetPlayerJumps( ply ) == 0 then
		ply:SetJumpPower( _C.Player.JumpHeightDefault )
	end

	g_groundTicks[ ply ] = g_groundTicks[ ply ] + 1

	-- player will land this tick
	if g_groundTicks[ ply ] == 1 || Core.Util:GetPlayerJumps( ply ) == 0 then
		g_storedVelocity[ ply ] = data:GetVelocity()

		if st == _C.Style["Easy Scroll"] then
			ply:SetJumpPower( _C.Player.ScrollPower )
		end

		if ((Core.Util:GetPlayerJumps( ply ) % 2) == 1) then
			ply:SetJumpPower( _C.Player.JumpHeightDefault )
		else
			ply:SetJumpPower( _C.Player.JumpHeight )
		end

		if pj[ ply ] then
			pj[ ply ] = pj[ ply ] + 1
		end
	elseif g_groundTicks[ ply ] > 1 and data:KeyDown( 2 ) and st != _C.Style["Legit"] and st != _C.Style["Easy Scroll"] then
		if ic and g_groundTicks[ ply ] < 4 then return end

		-- CrouchBug fix?
		local vel = g_storedVelocity[ ply ] or data:GetVelocity()
		vel.z = ply:GetJumpPower()
		data:SetVelocity( vel )
	end
end
hook.Add( "SetupMove", "ChangeMove", ChangeMove )

local nojump = {}
local njpos = {}
local njang = {}

local function MoveNoclip(ply, mv)
	if !IsValid(ply) then return end

	local isNoclipping = (ply:GetMoveType() == MOVETYPE_NOCLIP) and not ply:IsOnGround()

	if !isNoclipping then return end

	local deltaTime = FrameTime()

	local noclipSpeed, noclipAccelerate = GetConVar "sv_noclipspeed", GetConVar "sv_noclipaccelerate"
	local speedValue, accelValue = noclipSpeed:GetInt(), noclipAccelerate:GetInt()

	local ang = mv:GetMoveAngles()
	local acceleration = (ang:Forward() * mv:GetForwardSpeed()) + (ang:Right() * mv:GetSideSpeed()) + (ang:Up() * mv:GetUpSpeed())

	local accelSpeed = math.min(acceleration:Length(), ply:GetMaxSpeed())
	local accelDir = acceleration:GetNormal()
	acceleration = accelDir * accelSpeed * speedValue

	local multiplier = 4
	local isSpeeding, isDucking = mv:KeyDown(IN_SPEED), mv:KeyDown(IN_DUCK)
	if isSpeeding then
		multiplier = 0.0001
	elseif isDucking then
		multiplier = 32
	end

	local newVelocity = mv:GetVelocity() + acceleration * deltaTime * accelValue
	newVelocity = newVelocity * (0.95 - deltaTime * multiplier)

	mv:SetVelocity(newVelocity)

	local newOrigin = mv:GetOrigin() + newVelocity * deltaTime
	mv:SetOrigin(newOrigin)

	return true
end
hook.Add("Move", "MoveNoclip", MoveNoclip)

local s1, s2 = _C.Style["Easy Scroll"], _C.Style.Legit
local function AutoHop( ply, data )
	if lp and ply != lp() then return end
	if not ply.Style then ply.Style = Timer.Style end
	
	if ply.Style != s1 and ply.Style != s2 then
		local ButtonData = data:GetOldButtons()
		if ba( ButtonData, IN_JUMP ) > 0 then
			if ply:WaterLevel() < 2 and ply:GetMoveType() != MOVETYPE_LADDER and ply:OnGround() then
				data:SetOldButtons( ba( ButtonData, bn( IN_JUMP ) ) )
			end
		end
	end
end
hook.Add( "SetupMove", "AutoHop", AutoHop )

function GM:CreateMove( cmd ) 
	if LocalPlayer().Style == _C.Style.AutoStrafe then
		if cmd:KeyDown( IN_JUMP ) then
			if cmd:GetMouseX() < 0 then
				cmd:SetSideMove(-10000)
			elseif cmd:GetMouseX() > 0 then
				cmd:SetSideMove(10000)
			end
		end
	end
	if CLIENT and (bit.band(cmd:GetButtons(), IN_ATTACK) > 0) and LocalPlayer():Team() != _C.Team.Spectator and NoAmmoConVar and NoAmmoConVar:GetInt() == 1 then 
		cmd:SetButtons( cmd:GetButtons() - IN_ATTACK )
	end
end

function GM:SetupMove() end
function GM:FinishMove() end

PlayerJumps = {}
local P1, P2 = _C.Player.ScrollPower, _C.Player.JumpPower

local function PlayerGround( ply, inWater, onFloater, flFallSpeed )
	if lp and ply != lp() then return end
	if not ply.Style then ply.Style = Timer.Style or 1 end
	
	if ply.Style == s1 or ply.Style == s2 then
		ply:SetJumpPower( P1 or _C.Player.ScrollPower )
		timer.Simple( 0.3333333333333333333333333333333333333333333333333333333333, function() if not IsValid( ply ) or not ply.SetJumpPower or not _C.Player.JumpPower then return end ply:SetJumpPower( P2 or _C.Player.JumpPower ) end )
	end

	if PlayerJumps[ ply ] then
		PlayerJumps[ ply ] = PlayerJumps[ ply ] + 1
			JAC:StartCheck(ply)
	end

	if (SERVER) then 
		local observers = {ply}

		for k, v in pairs(player.GetHumans()) do 
			if IsValid(v:GetObserverTarget()) and (v:GetObserverTarget() == ply) then 
				table.insert(observers, v)
			end
		end

		Core:Send(observers, "jump_update", {ply, PlayerJumps[ply]})

		if (flFallSpeed) > 300 then return true end
	end
end
hook.Add( "OnPlayerHitGround", "HitGround", PlayerGround )

local function StripMovements( ply, data )
	if lp and ply != lp() then return end
	
	local st = ply.Style
	if not ply.Freestyle and st and st > 1 and st < 7 and ply:GetMoveType() != MOVETYPE_NOCLIP then
		if ply:OnGround() then
			if st == 6 then
				local vel = data:GetVelocity()
				local ts = ls[ ply ] or 700
				if vel:Length2D() > ts then
					local diff = vel:Length2D() - ts
					vel:Sub( Vector( vel.x > 0 and diff or -diff, vel.y > 0 and diff or -diff, 0 ) )
				end
				
				data:SetVelocity( vel )
				return false
			end
			
			return
		end
		
		if st == 2 or st == 4 then
			data:SetSideSpeed( 0 )
				
			if st == 4 and data:GetForwardSpeed() < 0 then
				data:SetForwardSpeed( 0 )
			end
		elseif st == 5 then
			data:SetForwardSpeed( 0 )
				
			if data:GetSideSpeed() > 0 then
				data:SetSideSpeed( 0 )
			end
		elseif (st == 3  and bit.band(data:GetButtons(), 16) > 0) then
			local bd = data:GetButtons()
			if (bit.band(bd, 512) > 0) or (bit.band(bd, 1024) > 0) then
				data:SetForwardSpeed(0)
				data:SetSideSpeed(0)
			end
		end
		if (data:GetForwardSpeed() == 0) or (data:GetSideSpeed() == 0) then
			data:SetForwardSpeed(0)
			data:SetSideSpeed(0)
		end
	end
end
hook.Add( "SetupMove", "StripIllegal", StripMovements )

-- Core

Core = {}

local StyleNames = {}
for name,id in pairs( _C.Style ) do
	StyleNames[ id ] = name
end

function Core:StyleName( nID )
	return StyleNames[ nID ] or "No Style"
end

function Core:IsValidStyle( nStyle )
	return not not StyleNames[ nStyle ]
end

function Core:GetStyleID( szStyle )
	for s,id in pairs( _C.Style ) do
		if sl( s ) == sl( szStyle ) then
			return id
		end
	end
	
	return 0
end

function Core:Exp( c, n )
	return c * mp( n, 2.9 )
end

function Core:Optimize()
	hook.Remove( "PlayerTick", "TickWidgets" )
	hook.Remove( "PreDrawHalos", "PropertiesHover" )
end

local MainStand, IdleActivity, round = ACT_MP_STAND_IDLE, ACT_HL2MP_IDLE, math.Round
function GM:CalcMainActivity() return MainStand, -1 end
function GM:TranslateActivity() return IdleActivity end

Core.Util = {}
function Core.GetDuckSet()
	return ds, au
end

function Core.Util:GetPlayerJumps( ply )
	return PlayerJumps[ ply ] or 0
end

function Core.Util:SetPlayerJumps( ply, nValue )
	PlayerJumps[ ply ] = nValue
end

function Core.Util:SetPlayerLegit( ply, nValue )
	ls[ ply ] = nValue
end

function Core.Util:StringToTab( szInput )
	local tab = string.Explode( " ", szInput )
	for k,v in pairs( tab ) do
		if tonumber( v ) then
			tab[ k ] = tonumber( v )
		end
	end
	return tab
end

function Core.Util:TabToString( tab )
	for i = 1, #tab do
		if not tab[ i ] then
			tab[ i ] = 0
		end
	end
	return string.Implode( " ", tab )
end

function Core.UpdateSetting( k, v )
	local o = Core.ServerSettings
	v = tonumber( v )

	if k == "CSSJumps" then
		o[ k ] = v == 1
		_C.Player.JumpPower = v == 1 and math.sqrt( 2 * 800 * 57.81 ) or 290
	elseif k == "CSSGains" then
		if not _C.IsBhop or v != 1 then return end
		o[ k ] = true

		paa, pmv = 1200, 30
		_C.Player.AirAcceleration = paa
		_C.Player.StrafeMultiplier = pmv
	elseif k == "CSSDuck" then
		if v != 1 then return end
		o[ k ] = true

		_C["Player"].HullStand.z = viewDeltaBase * ( hullSizeNormal - hullSizeCrouch ) + 62 + newOrigin
		_C["Player"].ViewStand.z = DIST_EPSILON + viewDeltaBase * ( hullSizeNormal - hullSizeCrouch ) + 64
		_C["Player"].ViewOffset.z = viewDelta * ( hullSizeNormal - hullSizeCrouch )

		Core.SetDuckDiff()
		Core.UpdateClientViews()

		local lpc = LocalPlayer()
		if IsValid( lpc ) then
			lpc:SetViewOffset( _C["Player"].ViewStand )
			lpc:SetViewOffsetDucked( _C["Player"].ViewDuck )
			lpc:SetHull( _C["Player"].HullMin, _C["Player"].HullStand )
			lpc:SetHullDuck( _C["Player"].HullMin, _C["Player"].HullDuck )
		end
	elseif k == "Checkpoints" then
		o[ k ] = true

		for i = 1, 100 do
			StyleNames[ 100 + i ] = "Checkpoint " .. i
		end
	elseif k == "StartLimit" or k == "SpeedLimit" or k == "WalkSpeed" then
		o[ k ] = v .. " u/s"
	end
end

function Core.Util:RandomColor()
	local r = math.random
	return Color( r( 0, 255 ), r( 0, 255 ), r( 0, 255 ) )
end

function Core.Util:VectorToColor( v )
	return Color( v.x, v.y, v.z )
end

function Core.Util:ColorToVector( c )
	return Color( c.r, c.g, c.b )
end

function Core.Util:NoEmpty( tab )
	for k,v in pairs( tab ) do
		if not v or v == "" then
			table.remove( tab, k )
		end
	end
	
	return tab
end

-- Gravity Prediction Fixes --
do
	local GravityPredictionNetwork = "sm_gravity_prediction"

	if SERVER then
		local g_CVar_sv_gravity = GetConVar("sv_gravity"):GetInt()

		local g_flClientGravity = {}
		local g_flClientActualGravity = {}

		local g_bLadder = {}

		local function OnPluginStart()
			g_CVar_sv_gravity = GetConVar("sv_gravity"):GetInt()
		end
		hook.Add("PostGamemodeLoaded", "sm_gravpredfix_OnPluginStart", OnPluginStart)

		local function RestoreGravity(ply)
			g_bLadder[ply] = false

			net.Start(GravityPredictionNetwork)
				net.WriteFloat(g_flClientGravity[ply] or 1)
			net.Send(ply)
		end

		-- OnGameFrame, but a little later --
		local function OnGameFrame()
			local flSVGravity = g_CVar_sv_gravity

			for _,ply in ipairs(player.GetHumans()) do
				if !IsValid(ply) or !ply:Alive() then
					g_flClientGravity[ply] = 1
					g_bLadder[ply] = false
				continue end

				if (ply:GetMoveType() == MOVETYPE_LADDER) and !g_bLadder[ply] then
					g_bLadder[ply] = true
				continue end

				if g_bLadder[ply] then continue end

				local flClientGravity = ply:GetGravity()
				if (flClientGravity == 0.0) then continue end

				g_flClientGravity[ply] = flClientGravity

				local flClientActualGravity = (flClientGravity * flSVGravity)

				if (flClientActualGravity != g_flClientActualGravity[ply]) then

					g_flClientActualGravity[ply] = g_flClientActualGravity
				end
			end
		end
		hook.Add("Think", "sm_gravpredfix_OnGameFrame", OnGameFrame)

		local function OnPostGameFrame(ply)
			if ply:IsBot() then return end

			if IsValid(ply) and g_bLadder[ply] then
				RestoreGravity(ply)
			end
		end
		hook.Add("PlayerPostThink", "sm_gravpredfix_OnPostGameFrame", OnPostGameFrame)
	elseif CLIENT then
		local gravityMultiplier = 1

		local function GravityController(ply)
			if !IsValid(LocalPlayer()) then return end
			if (LocalPlayer() != ply) then return end

			ply:SetGravity(gravityMultiplier)
		end
		hook.Add("SetupMove", "sm_gravpredfix_GravityController", GravityController)
	end
end

do
	local result = {}
	local fudge  = Vector(1, 1, 0)
	local trace  = {
		mask           = MASK_PLAYERSOLID,
		collisiongroup = COLLISION_GROUP_PLAYER_MOVEMENT,
		output         = result,
	}

	-- THis handles duck view, it smooths out the camera view as they are holding duck --
	function GM:FinishMove(ply, data)
		if ply:Alive() then
			local min = Vector(ply:FullyDucked() and VEC_DUCK_HULL_MIN or VEC_HULL_MIN)
			local max = Vector(ply:FullyDucked() and VEC_DUCK_HULL_MAX or VEC_HULL_MAX)

			min.z = 0

			local startpos = data:GetOrigin()
			startpos.z = startpos.z + max.z

			local endpos = startpos
			endpos.z = endpos.z + (EYE_CLEARANCE - max.z)
			endpos.z = endpos.z + (ply:FullyDucked() and VEC_DUCK_VIEW or VEC_VIEW).z

			max.z = 0

			min:Add(fudge)
			max:Sub(fudge)

			trace.start = startpos
			trace.endpos = endpos
			trace.filter = ply

			util.TraceHull(trace)
			local fraction = result.Fraction

			if fraction < 1 then
				/*local est = startpos.z + fraction * (endpos.z - startpos.z) - data:GetOrigin().z - EYE_CLEARANCE
				local offset = ply:GetCurrentViewOffset()

				if ply:NotDucked() then
					offset.z = est
				else
					offset.z = math.min(est, offset.z)
				end

				ply:SetCurrentViewOffset(offset)*/
			else
				if ply:NotDucked() then
					ply:SetCurrentViewOffset(VEC_VIEW)
				elseif ply:FullyDucked() then
					ply:SetCurrentViewOffset(VEC_DUCK_VIEW)
				end
			end
		end
	end
end

RNGFix = {}
RNGFix.Enabled = CreateConVar("rngfix_enabled", "1", FCVAR_NOTIFY, "Enable RNGFix", 0, 1):GetBool()
RNGFix.Telehop = CreateConVar("rngfix_telefix", "1", FCVAR_NOTIFY, "Enable TeleFix", 0, 1):GetBool()
RNGFix.Debug = CreateConVar("rngfix_debug", "0", {128, 8192}, "Enable RNGFix debug messages", 0, 1):GetBool()

LAND_HEIGHT = 2.0
NON_JUMP_VELOCITY = 140.0
MIN_STANDABLE_ZNRM = 0.7
DEFAULT_JUMP_IMPULSE = 301.99337741
SERVER_GRAVITY = 800

TRIGGER_PUSH = 1
TRIGGER_BASEVEL = 2
TRIGGER_TELEPORT = 3

g_vecMins = VEC_HULL_MIN
g_vecMaxsUnducked = VEC_HULL_MAX
g_vecMaxsDucked = VEC_DUCK_HULL_MAX
g_flDuckDelta = (g_vecMaxsUnducked.z - g_vecMaxsDucked.z) / 2

g_iTick = {}
g_flFrameTime = {}
g_iTouchingTrigger = {}
g_iButtons = {}
g_vVel = {}
g_vAngles = {}
g_iOldButtons = {}

g_iLastTickPredicted = {}
g_iLastCollisionTick = {}
g_vPrecollisionVelocity = {}
g_vLastBaseVelocity = {}
g_iLastGroundEnt = {}
g_iLastLandTick = {}
g_iLastMapTeleportTick = {}
g_bMapTeleportedSequentialTicks = {}
g_vCollisionPoint = {}
g_vCollisionNormal = {}

g_eTriggers = {}
g_bIsSurfMap = string.StartWith(game.GetMap(), "surf_") and true or false

local sft = string.format
local bb = bit.band

cvars.AddChangeCallback("rngfix_enabled", function(_, _, newValue)
	newValue = tonumber(newValue)

	RNGFix.Enabled = tobool(newValue)
end)

cvars.AddChangeCallback("rngfix_telefix", function(_, _, newValue)
	newValue = tonumber(newValue)

	RNGFix.Telehop = tobool(newValue)
end)

cvars.AddChangeCallback("rngfix_debug", function(_, _, newValue)
	newValue = tonumber(newValue)

	RNGFix.Debug = tobool(newValue)
end)

function RNGFix:DebugMsg(ply, message, ...)
	if !RNGFix.Debug then return end
	if ply:IsBot() then return end

	local name = IsValid(ply) and ply:Nick() or "Unknown Entity"

	message = sft(message, ...)
	print(sft("[%s] %s", name, message))
end

local function SetupPlayer(ply)
	g_iTick[ply] = 1
	g_iLastGroundEnt[ply] = nil
	g_iButtons[ply] = 0
	g_iLastCollisionTick[ply] = 0
	g_iLastGroundEnt[ply] = nil
	g_iLastMapTeleportTick[ply] = 0

	RNGFix:DebugMsg(ply, "Loaded essentials for player: %s [%s]", ply:Nick(), ply:AccountID())
end

local function TracePlayerBBoxForGround(ply, origin, originBelow, mins, maxs)
	local origMins, origMaxs = Vector(mins), Vector(maxs)
	local nrm, tr, pos

	mins = origMins
	maxs = Vector(math.min(origMaxs.x, 0.0), math.min(origMaxs.y, 0.0), origMaxs.z)
	tr = util.TraceHull({
		start = origin,
		endpos = originBelow,
		mins = mins,
		maxs = maxs,
		mask = MASK_PLAYERSOLID_BRUSHONLY,
	})
	if tr.Hit then
		nrm = tr.HitNormal
		pos = tr.HitPos
		if (nrm.z >= MIN_STANDABLE_ZNRM) then return true, nrm, pos end
	end

	mins = Vector(math.max(origMins.x, 0.0), math.max(origMins.y, 0.0), origMins.z)
	maxs = origMaxs
	tr = util.TraceHull({
		start = origin,
		endpos = originBelow,
		mins = mins,
		maxs = maxs,
		mask = MASK_PLAYERSOLID_BRUSHONLY
	})
	if tr.Hit then
		nrm = tr.HitNormal
		pos = tr.HitPos
		if (nrm.z >= MIN_STANDABLE_ZNRM) then return true, nrm, pos end
	end

	mins = Vector(origMins.x, math.max(origMins.y, 0.0), origMins.z)
	maxs = Vector(math.min(origMaxs.x, 0.0), origMaxs.y, origMaxs.z)
	tr = util.TraceHull({
		start = origin,
		endpos = originBelow,
		mins = mins,
		maxs = maxs,
		mask = MASK_PLAYERSOLID_BRUSHONLY
	})
	if tr.Hit then
		nrm = tr.HitNormal
		pos = tr.HitPos
		if (nrm.z >= MIN_STANDABLE_ZNRM) then return true, nrm, pos end
	end

	mins = Vector(math.max(origMins.x, 0.0), origMins.y, origMins.z)
	maxs = Vector(origMaxs.x, math.min(origMaxs.y, 0.0), origMaxs.z)
	tr = util.TraceHull({
		start = origin,
		endpos = originBelow,
		mins = mins,
		maxs = maxs,
		mask = MASK_PLAYERSOLID_BRUSHONLY
	})
	if tr.Hit then
		nrm = tr.HitNormal
		pos = tr.HitPos
		if (nrm.z >= MIN_STANDABLE_ZNRM) then return true, nrm, pos end
	end

	return false, nrm, pos
end

	function Duck(ply, origin, mins, max)
		local ducking = ply:Crouching()
		local nextducking = ducking

		if !ducking and bb(g_iButtons[ply], IN_DUCK) != 0 then
			origin.z = origin.z + g_flDuckDelta
			nextducking = true
		elseif bb(g_iButtons[ply], IN_DUCK) == 0 and ducking then
			origin.z = origin.z - g_flDuckDelta

			local tr = util.TraceHull{
				start = origin,
				endpos = origin,
				mins = g_vecMaxsDucked,
				maxs = g_vecMaxsUnducked,
				mask = MASK_PLAYERSOLID_BRUSHONLY,
				filter = ply
			}

			if tr.Hit then
				origin.z = origin.z + g_flDuckDelta
			else
				nextducking = false
			end
		end

		mins = VEC_DUCK_HULL_MIN
		max = nextducking and g_vecMaxsDucked or g_vecMaxsUnducked
		return origin, mins, max
	end

	function StartGravity(ply, velocity)
		local gravity = ply:GetGravity()
		if (gravity == 0.0) then gravity = 1.0 end

		local baseVelocity = ply:GetBaseVelocity()
		velocity.z = velocity.z + (baseVelocity.z - gravity * SERVER_GRAVITY * 0.5) * FrameTime()

		return velocity
	end

	function FinishGravity(ply, velocity)
		local gravity = ply:GetGravity()
		if (gravity == 0.0) then gravity = 1.0 end

		velocity.z = velocity.z - gravity * SERVER_GRAVITY * 0.5 * FrameTime()

		return velocity
	end

	function CanJump(ply)
		if !g_iButtons[ply] or !g_iOldButtons[ply] then return true end

		if (bb(g_iButtons[ply] or 0, IN_JUMP) == 0) then return false end
		if (bb(g_iOldButtons[ply] or 0, IN_DUCK) != 0) then return false end

		return true
	end

	function CheckWater(ply)
		return ply:WaterLevel() < 1
	end

	function ClipVelocity(velocity, nrm)
		local backOff = velocity:Dot(nrm)
		local out = Vector()

		for i = 1, 3 do
			out[i] = velocity[i] - nrm[i] * backOff
		end

		return out
	end

	local function SetVelocity(ply, velocity, dontUseTeleportEntity)
		velocity:Sub(g_vLastBaseVelocity[ply])

		if (dontUseTeleportEntity and !IsValid(ply:GetMoveParent())) then
			ply:SetAbsVelocity(velocity)
			ply:SetVelocity(velocity)
		else
			local baseVelocity = ply:GetBaseVelocity()

			ply:SetAbsVelocity(Vector())
			ply:SetAbsVelocity(baseVelocity)
		end

		RNGFix:DebugMsg(ply, "SetVelocity: %.2f %.2f %.2f", velocity.x, velocity.y, velocity.z)
	end

	function PreventCollision(ply, mv, origin, collisionPoint, velocity_tick)
		local newOrigin = collisionPoint - velocity_tick
		newOrigin.z = newOrigin.z + 0.1

		g_iLastCollisionTick[ply] = 0
		mv:SetOrigin(newOrigin)

		local adjustment = newOrigin - origin
		RNGFix:DebugMsg(ply, "Moved: %.2f %.2f %.2f", adjustment.x, adjustment.y, adjustment.z)
	end

	function RunPreTickChecks(ply, mv)
		local isAlive = (ply and IsValid(ply) and ply:Alive())
		if !isAlive then return end

		local movetype = ply:GetMoveType()
		if (movetype != MOVETYPE_WALK) then return end

		local validWater = CheckWater(ply)
		if !validWater then return end

		g_iLastGroundEnt[ply] = ply:GetGroundEntity()
		if (g_iLastGroundEnt[ply]:IsWorld() and !CanJump(ply)) then return end

		g_iOldButtons[ply] = mv:GetOldButtons()
		g_iButtons[ply] = mv:GetButtons()
		g_iLastTickPredicted[ply] = g_iTick[ply]

		g_vVel[ply] = mv:GetVelocity()
		g_vAngles[ply] = mv:GetAngles()

		local velocity = mv:GetVelocity()
		local baseVelocity = ply:GetBaseVelocity()
		local origin = mv:GetOrigin()

		local nextOrigin, mins, maxs = origin * 1, ply:OBBMins(), ply:OBBMaxs()
		nextOrigin, mins, maxs = Duck(ply, origin, mins, maxs)
	
		baseVelocity.z = 0
		g_vLastBaseVelocity[ply] = baseVelocity
		velocity:Add(baseVelocity)

		g_vPrecollisionVelocity[ply] = velocity

		local velocity_tick = velocity * g_flFrameTime[ply]
		nextOrigin = nextOrigin + velocity_tick

		local tr = util.TraceHull({
			start = origin,
			endpos = nextOrigin,
			mins = mins,
			maxs = maxs,
			mask = MASK_PLAYERSOLID_BRUSHONLY,
			filter = ply
		})

		local nrm = tr.HitNormal
		if tr.Hit and !tr.HitNonWorld then
			if ((g_iLastCollisionTick[ply] or 0) < g_iTick[ply] - 1) then
				RNGFix:DebugMsg(ply, "Collision predicted! (normal: %.3f %.3f %.3f)", nrm.x, nrm.y, nrm.z)
			end

			local collisionPoint = tr.HitPos
			g_iLastCollisionTick[ply] = g_iTick[ply]
			g_vCollisionPoint[ply] = collisionPoint
			g_vCollisionNormal[ply] = nrm

			if (velocity.z > NON_JUMP_VELOCITY) then return end
			if (nrm.z < MIN_STANDABLE_ZNRM or nrm.z >= 1) then return end

			if (nrm.z < 1.0 and (nrm.x * velocity.x + nrm.y * velocity.y) < 0.0) then
				local shouldDoDownhillFixInstead = false

				local newVelocity = ClipVelocity(velocity, nrm)

				if (newVelocity.x * newVelocity.x + newVelocity.y * newVelocity.y > velocity.x * velocity.x + velocity.y * velocity.y) then
					shouldDoDownhillFixInstead = true
				end

				if (!shouldDoDownhillFixInstead) then
					RNGFix:DebugMsg(ply, "DO FIX: Uphill Incline")
					PreventCollision(ply, mv, origin, collisionPoint, velocity_tick)
				return end
			end

			local fraction_left = 1.0 - tr.Fraction
			local tickEnd = Vector()

			if (nrm.z == 1.0) then
				tickEnd = collisionPoint + velocity_tick * fraction_left
				tickEnd.z = collisionPoint.z
			else
				local velocity2 = ClipVelocity(velocity, nrm)
				if (velocity2.z > NON_JUMP_VELOCITY) then
					return
				else
					velocity2 = velocity2 * g_flFrameTime[ply] * fraction_left
					tickEnd = collisionPoint + velocity2
				end
			end

			local tickEndBelow = tickEnd
			tickEndBelow.z = tickEnd.z - LAND_HEIGHT

			local tr_edge = util.TraceHull{
				start = tickEnd,
				endpos = tickEndBelow,
				mins = mins,
				maxs = maxs,
				mask = MASK_PLAYERSOLID,
				filter = ply
			}

			if (tr_edge.Hit) then
				local nrm2 = tr_edge.HitNormal
				if nrm2.z >= MIN_STANDABLE_ZNRM then return end
				if TracePlayerBBoxForGround(ply, tickEnd, tickEndBelow, mins, maxs) then return end
			end

			RNGFix:DebugMsg(ply, "DO FIX: Edge Bug")
			PreventCollision(ply, mv, origin, collisionPoint, velocity_tick)
		end
	end

	local function ProcessMovementPre(ply, mv)
		g_iTick[ply] = g_iTick[ply] and g_iTick[ply] + 1 or 1
		g_flFrameTime[ply] = (engine.TickInterval() * ply:GetLaggedMovementValue())
		g_bMapTeleportedSequentialTicks[ply] = false

		g_iButtons[ply] = 0
		g_iOldButtons[ply] = 0

		g_iLastTickPredicted[ply] = 0

		local treadmill = ply:GetBaseVelocity():Length2D()
		if (treadmill > 0) then return end

		if !RNGFix.Enabled then return end
		RunPreTickChecks(ply, mv)
	end
	hook.Add("SetupMove", "sm_rngfix_runpretickchecks", ProcessMovementPre)

	local function Hook_PlayerGroundEntChanged(ply)
		if (ply:GetGroundEntity() == Entity(0)) then
			g_iLastLandTick[ply] = g_iTick[ply]
			RNGFix:DebugMsg(ply, "Landed")
		end
	end
	hook.Add("OnPlayerHitGround", "sm_rngfix_playergroundentchanged", Hook_PlayerGroundEntChanged)

	local function DoInclineCollisionFixes(ply, mv, nrm)
		if (g_iLastTickPredicted[ply] != g_iTick[ply]) then return end
		if (nrm.z == 1.0) then return end

		local velocity = g_vPrecollisionVelocity[ply]
		local dot = (nrm.x * velocity.x + nrm.y * velocity.y)

		local downhillFixIsBeneficial = false
		local newVelocity = ClipVelocity(velocity, nrm)

		if (newVelocity.x * newVelocity.x + newVelocity.y * newVelocity.y > velocity.x * velocity.x + velocity.y * velocity.y) then
			downhillFixIsBeneficial = true
		end

		if (dot <= 0) and !downhillFixIsBeneficial then return end

		RNGFix:DebugMsg(ply, "DO FIX: Incline Collision (%s) (z-normal: %.3f)", downhillFixIsBeneficial and "Downhill" or "Uphill", nrm.z)
		newVelocity.z = 0

		mv:SetVelocity(newVelocity)
	end

	local function PostPlayerThink(ply, mv)
		if !RNGFix.Enabled then return end

		local isAlive = (ply and IsValid(ply) and ply:Alive())
		if !isAlive then return end

		local movetype = ply:GetMoveType()
		if (movetype != MOVETYPE_WALK) then return end

		local validWater = CheckWater(ply)
		if !validWater then return end

		local landed = ply:GetGroundEntity()
		local origin, landingMins, landingMaxs, nrm, tr

		if landed then
			origin = mv:GetOrigin()
			landingMins = ply:OBBMins()
			landingMaxs = ply:OBBMaxs()

			local originBelow = origin * 1
			originBelow.z = originBelow.z - LAND_HEIGHT

			tr = util.TraceHull({
				start = origin,
				endpos = originBelow,
				mins = landingMins,
				maxs = landingMaxs,
				mask = MASK_PLAYERSOLID_BRUSHONLY,
				filter = ply
			})

			if (!tr.Hit) then
				landed = false
			else
				nrm = tr.HitNormal

				if (nrm.z < MIN_STANDABLE_ZNRM) then
					local tracedGround, newnrm, _ = TracePlayerBBoxForGround(ply, origin, originBelow, landingMins, landingMaxs)
				if tracedGround then
					nrm = newnrm
				else
					landed = false
				end

				RNGFix:DebugMsg(ply, "Used bounding box quadrant to find ground (z-normal: %.3f)", nrm.z)
			end
		end
	end

	if (landed and tr.Fraction > 0.0) and !ply:OnGround() then
		landed = false
	end

	if landed then
		DoInclineCollisionFixes(ply, mv, nrm)
	end
end
hook.Add("FinishMove", "sm_rngfix_PostPlayerThink", PostPlayerThink)