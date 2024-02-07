Client = {}

include "sv_config.lua"
include "core.lua"

include "userinterface/cl_settings.lua"
include "userinterface/cl_themes.lua"
include "userinterface/cl_ui.lua"
include "userinterface/cl_hud.lua"
include( "cl_view.lua" )
include "sh_paint.lua"
include "sh_pebblebuster.lua"
include "cl_timer.lua"
include "cl_receive.lua"
include "cl_gui.lua"

include "modules/cl_admin.lua"
include "modules/cl_strafe.lua"

include "userinterface/sh_init.lua"
include "userinterface/cl_bhoptimer.lua"
include "userinterface/cl_interface.lua"
include "userinterface/cl_extensions.lua"
include "userinterface/cl_help.lua"
include "userinterface/cl_devtools.lua"
include "userinterface/cl_cheats.lua"

include "userinterface/cl_scoreboard.lua"

-- Destroy resource hogs
function GM:UpdateAnimation() end
function GM:GrabEarAnimation() end
function GM:MouthMoveAnimation() end
function GM:DoAnimationEvent() end
function GM:AdjustMouseSensitivity() end
function GM:CalcViewModelView() end
function GM:PreDrawViewModel() end
function GM:PostDrawViewModel() end
function GM:HUDDrawTargetID() end

function GM:Think() return true end
function GM:Tick() return true end
function GM:PlayerTick() return true end

function GM:CanUndo() return true end
function GM:PreUndo() return true end
function GM:PlayerHurt() return true end
function GM:ShowHelp() return true end
function GM:EntityEmitSound() return true end

function GM:OnAchievementAchieved( ply, achid ) return true end
function GM:PostProcessPermitted( str ) return true end
function GM:InputMouseApply( cmd, x, y, angle ) return false end

function GM:PlayerButtonDown( ply, btn ) return true end
function GM:PlayerButtonUp( ply, btn ) return true end

hook.Add("PlayerButtonDown","PlayerButtonDown",function()
	hook.Remove("PlayerButtonDown", "PlayerButtonDown")
end)

hook.Add("PlayerButtonUp","PlayerButtonUp",function()
	hook.Remove("PlayerButtonUp", "PlayerButtonUp")
end)

hook.Add("Think","Think",function()
	hook.Remove("Think", "Think")
end)

hook.Add("Tick","Tick",function()
	hook.Remove("Tick", "Tick")
end)

hook.Add("PlayerTick","PlayerTick",function()
	hook.Remove("PlayerTick", "PlayerTick")
end)

hook.Add("Move","Move",function()
	hook.Remove("Move", "Move")
end)

hook.Add("StartMove","StartMove",function()
	hook.Remove("StartMove", "StartMove")
end)

hook.Add("FinishMove","FinishMove",function()
	hook.Remove("FinishMove", "FinishMove")
end)

local CPlayers = CreateClientConVar( "sl_showothers", "1", true, false )
local CSteam = CreateClientConVar( "sl_steamgroup", "1", true, false )
local CCrosshair = CreateClientConVar( "sl_crosshair", "1", true, false )
local CTargetID = CreateClientConVar( "sl_targetids", "0", true, false )
local Connection = CreateClientConVar( "sl_connection", "0", true, false )

ShowZones = CreateClientConVar( "sl_showzones", "1", true, false, "Toggles the visibility of the server zones. Change this if you want to see the lazer zones." )
ShowAltZones = CreateClientConVar( "sl_showaltzones", "0", true, false, "Toggles the visibility of the alternate server zones. This includes zones outside of the Normal and Bonus zones." )
Prestrafe = CreateClientConVar( "sl_prestrafe", "1", true, false, "Toggles the prestrafe view in your timer." )
Comparison = CreateClientConVar( "sl_comparison_type", "1", true, true, "Toggles the prestrafe view in your timer." )
Velocity = CreateClientConVar( "sl_velocitytype", "1", true, false, "Toggles the velocity type in your timer. 0 represents XY while 1 represents XYZ." )
VelocityBar = CreateClientConVar( "sl_velocitybar", "1", true, false, "Toggles the velocity bar in your timer. 0 disables the color inside the velocity status." )
Blur = CreateClientConVar( "sl_blur", "1", true, false, "Toggles the visibility of blur menus. Use 0 for better performance." )
Decimals = CreateClientConVar( "sl_enumerator", "2", true, false, "Changes the amount of numbers after the decimal in your timer. 2 is the default enumerator." )
PrintPref = CreateClientConVar( "sl_printchat", "1", true, false, "Decides whether or not to print messages to your chatbox. Use 0 if you want your messages to be printed in the console." )
TotalTime = CreateClientConVar( "sl_totaltime", "1", true, true, "Toggles the total time display.")
Footsteps = CreateClientConVar( "sl_footsteps", "1", true, true, "Toggles the footstep sounds for every player in the server." )
ChatTick = CreateClientConVar( "sl_chattick", "default", true, true, "Changes the sound type of the chat ticker. Use \"Default\" as the default ticker." )
MenuClicker = CreateClientConVar( "sl_clicker", "1", true, false, "When pressing a number inside a menu, a sound will play." )
ShowPing = CreateClientConVar( "sl_showping", "0", true, true, "Toggles between the Ping and Style labels and info when clicked on either label button." )
GUILess = CreateClientConVar( "sl_guiless", "0", true, false, "If supported, allows some GUI elements to open a window with easy to browse information similar to the profile menu." )
ForceBloom = CreateClientConVar( "sl_forcebloom", "0", true, false, "If supported, forces the bloom rendering." )
ForceMotion = CreateClientConVar( "sl_forcemotion", "0", true, false, "If supported, forces the rendering of motion blurs." )
ForceFocus = CreateClientConVar( "sl_forcefocus", "0", true, false, "If supported, forces the focus to loosen on the bottom and top of your display." )
GlobalCheckpoints = CreateClientConVar( "sl_globalcheckpoints", "0", true, true, "Enables the usage of creating/loading global checkpoints." )
SpeedStats = CreateClientConVar( "sl_speedstats", "0", true, true, "Displays your Velocity stats when finishing a zone." )
ShowSpecialRanks = CreateClientConVar( "sl_special_ranks", "1", true, true, "Shows players' special ranks whenever possible" )

CustomChat = CreateClientConVar( "sl_customchat", "0", true, false, "Enables the future look of the chatbox." ):GetBool()
CustomSurfTimer = CreateClientConVar( "sl_customsurftimer", "0", true, false, "Allows custom color scheming for SMPanel-based UIs." )
CustomChatColors = CreateClientConVar( "sl_chattheme", "0", true, false, "Changes the color palette for colored chat messages printed from [Surf Timer]." )

SmoothNoclipping = CreateClientConVar( "sl_smoothnoclip", "0", true, true, "Enables the smooth noclip movement." )
UltrawideCenter = CreateClientConVar( "sl_ultracenter", "0", true, false, "Allows aspect ratios higher than 16:9 to render HUD elements in the center rather than the edges" )

local lp, Iv, st, ft, ma, mc, CalcTab, DuckDiff, NullPointer, Thirdperson, CalcAdded, DrawAdded, SilentSave, ViewInterp, SteadyView, NoViewModel = LocalPlayer, IsValid, SysTime, FrameTime, math.abs, math.ceil, { origin = { z = 0 }, frames = 0, last = 1 }, 16, function() end

local HUDItems = { "CHudHealth", "CHudBattery", "CHudAmmo", "CHudSecondaryAmmo", "CHudSuitPower" }

hook.Add( "PostPlayerDraw", "DIST_EPSILON", function( ply )

	// this is limited by the network fractional bits used for coords
	// because net coords will be only be accurate to 5 bits fractional
	
	// Standard collision test epsilon
	// 1/32nd inch collision epsilon
	
		local DIST_EPSILON = 0.031311
		local DIST_EPSILONFix = ( 1 ) + ( DIST_EPSILON )
	
		if not IsValid(ply) or not ply:Alive() then return end
		 if ply:GetModelScale() == DIST_EPSILONFix then return end
	
		ply:SetModelScale( DIST_EPSILONFix )
end )

CreateClientConVar("kawaii_fov", 100)

local newfov =  GetConVarNumber("kawaii_fov")

function GM:CalcView( ply, pos, angles, fov )
	if not Thirdperson then
		angles.r = 0
		
		if not ply:IsOnGround() and ViewInterp then
			local est = CalcTab.origin.z + ply:GetVelocity().z * ft()
			local posdiff = ma( pos.z - est )
			if posdiff - CalcTab.last > DuckDiff and posdiff - CalcTab.last < DuckDiff * 2 then
				pos.z = est
				posdiff = 0
			end
			
			CalcTab.last = posdiff
		end
		
		CalcTab.origin = pos
		CalcTab.angles = angles
		CalcTab.fov = fov
		
		return CalcTab
	elseif ply:Alive() then
		CalcTab.origin = pos - angles:Forward() * 100 + angles:Up() * 40
		CalcTab.angles = ply:GetPos() + angles:Up() * 30 - CalcTab.origin
		CalcTab.angles:Normalize()
		CalcTab.angles = CalcTab.angles:Angle()
		CalcTab.fov = fov
		
		return CalcTab
	end
end

function GM:CalcViewModelView( we, vm, op, oa, p, a )	
	if NoViewModel then
		p = Vector( 0, 64, 0 )
	elseif SteadyView then
		p, a = op, oa
	end
	
	if ViewInterp and CalcTab.last == 0 then
		p.z = CalcTab.origin.z
	end
	
	a.r = 0
	
	return p, a
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
		fStepTime = fStepTime + 1500
	end

	return fStepTime
end

suppress_viewpunch = {}
suppress_viewpunch.Enabled = CreateClientConVar( "kawaii_suppress_viewpunch", "0", true, false, "Suppress viewpunch" )

suppress_viewpunch_wep = {}
suppress_viewpunch_wep.Enabled = CreateClientConVar( "kawaii_suppress_viewpunch_wep_css", "1", true, false, "Suppress viewpunch for weapon" )

steady_view = {}
steady_view.Enabled = CreateClientConVar( "kawaii_steady_view", "0", true, false, "Steady weapon view not moving" )

function GM:RenderScreenspaceEffects()
	if ForceBloom:GetInt() == 1 then
		RunConsoleCommand( "pp_bloom", 1 )
		DrawBloom( 0.65, 3, 9, 9, 1, 1, 1, 1, 1 )
	else
		RunConsoleCommand( "pp_bloom", 0 )
	end

	if ForceMotion:GetInt() == 1 then
		DrawMotionBlur( 0.4, 0.4, 0.01 )
	end

	if ForceFocus:GetInt() == 1 then
		DrawToyTown( 2, ScrH() / 2 )
	end
end

CreateClientConVar("kawaii_css_reloading", 1, true, false)

function BHOPCSSReloader()
	if GetConVar("kawaii_css_reloading"):GetInt() == 1 then
	 	if input.IsMouseDown(MOUSE_RIGHT) then
	 		if LocalPlayer():IsOnGround() then
	 			RunConsoleCommand("+attack2")
	 			timer.Create("Bhop", 0, 0.0001, function()
	 		 	RunConsoleCommand("-attack2")
	 		 	
	 		 	end)
	 		end
	 	end
	end
end
hook.Add("Think", "BHOPCSSReloader", BHOPCSSReloader )

function WRDisplay()
	if input.IsKeyDown(KEY_F4) then
	 	RunConsoleCommand("say", "!wr")
	end
end
hook.Add("Think", "WRDisplay", WRDisplay )

hook.Add("CalcViewModelView", "FixPos", function(wep, vm, oldPos, oldAng, pos, ang)
	pos = pos - ang:Forward() * 5

	if steady_view then
		pos, ang = oldPos - ang:Forward() * 5, oldAng
	end

	local suppress_viewpunch_wep = suppress_viewpunch_wep.Enabled:GetBool()
	if not suppress_viewpunch_wep then
		ang.r = 0
	end

	return pos, ang
end)

local function fov(ply, ori, ang, fov, nz, fz)
	local view = {}

	local suppress_viewpunch = suppress_viewpunch.Enabled:GetBool()
	if suppress_viewpunch then
		ang.r = 0
	end

	view.origin = ori - ang:Forward() * 5
	view.angles = ang
	view.fov = newfov

	return view
end

hook.Remove("CalcView", "fov")
timer.Simple(1, function()
if GetConVarNumber("kawaii_fov") != 0 then
	hook.Add("CalcView", "fov", fov)
end
end)

cvars.AddChangeCallback("kawaii_fov", function() 
	newfov = GetConVarNumber("kawaii_fov")
	if newfov != 0 then
		hook.Add("CalcView", "fov", fov)
	else
		hook.Remove("CalcView", "fov")
	end
end)

local function DispatchChatJoinMSG(um)
	local ply = um:ReadString()
	local mode = um:ReadString()
	local STEAMID = um:ReadString()

	local location = "No Location found"
	local US = "The United States"
	local USB = "The Maybe United States"
	local UK = "The United Kingdom"
	
	if (LocalPlayer():Ping() > 0) then
		if (LocalPlayer():Ping() >= 100) then
			location = UK
	   	  else
	    	if (LocalPlayer():Ping() >= 60) then
				location = USB
			else 
				location = US
			end 
		end
	end

	if mode == "1" then
	if GetConVarNumber( "sm_connection" ) == 1 then
		surface.PlaySound("common/talk.wav")
	end
	elseif mode == "2" then
		chat.AddText(Color(255, 109, 10), "Server | ", Color(255, 255 , 255), ply, Color(255, 255 , 255), " (", Color(255, 109, 10), STEAMID, Color(255, 255 , 255), ")", Color(255, 255 , 255), " has connected from ", Color(255, 109, 10), location .. ".")
	elseif mode == "3" then
		if GetConVarNumber( "sm_connection" ) == 1 then
		chat.AddText(Color(255, 109, 10), "Server | ", Color(255, 255 , 255), ply, Color(255, 255 , 255), " (", Color(255, 109, 10), STEAMID, Color(255, 255 , 255), ")", Color(255, 255 , 255), " has disconnected from ", Color(255, 109, 10), location .. ".")

		surface.PlaySound("common/talk.wav")
		end
	end
end
usermessage.Hook("DispatchChatJoin", DispatchChatJoinMSG)

WRSOUND = {}
WRSOUND.Enabled = CreateClientConVar( "kawaii_recordsound", "1", true, false, "Enables WR Sounds" )

local function DispatchChatWR(um)
	local ply = um:ReadString()
	local mode = um:ReadString()
	local STEAMID = um:ReadString()

	chat.AddText(Color(255, 109, 10), "Server ", Color(255, 255 , 255), "| " .. ply .. "'s run", Color(255, 255 , 255), " as recorded by the ", Color(255, 0, 0), "R", Color(55, 127, 0), "e", Color(255, 255, 0), "c", Color(0, 255, 0), "o", Color(0, 0, 255), "r", Color(75, 0, 130), "d ", Color(148, 0, 211), "B", Color(255, 0 , 0), "o", Color(255, 127, 0), "t", Color(255, 255, 0), "!", Color( 255, 255, 255 ), " Congratulations")

	local WRSOUND = WRSOUND.Enabled:GetBool()
	if !WRSOUND then return end
	surface.PlaySound("common/talk.wav") -- WR Sound Change if you'd like
end
usermessage.Hook("DispatchChatWR", DispatchChatWR)

surface.CreateFont( "FancyChatBox", {font = "ChatFont", extended = false,size = 22,weight = 600,shadow = true} )
surface.CreateFont( "FancyChatBox12", {font = "ChatFont", extended = false,size = 22,weight = 500,shadow = true} )

timer.Simple(0, function()
local myChat = {}
local size1, size2 = ScrW() / 2.8, ScrH() / 4
local pos1, pos2 = 19, ScrH() / 1.65
local chatbox_isteam = false

myChat.dFrame = vgui.Create("DFrame")
myChat.dFrame:SetPos(pos1, pos2)
myChat.dFrame:SetTitle("")
myChat.dFrame:ShowCloseButton(false)
myChat.dFrame:SetAlpha(255)
myChat.dFrame:SetSize(size1, size2)
myChat.dFrame:SetDraggable( false )
myChat.dFrame.Paint = function ()  end
myChat.dFrame:Show()

myChat.dTextEntry = vgui.Create("DTextEntry", myChat.dFrame)
myChat.dTextEntry:SetFont("FancyChatBox")
myChat.dTextEntry:SetPos(0,size2 - size2 / 10)
myChat.dTextEntry:SetSize(size1, ScrH() / 50)
myChat.dTextEntry:SetPaintBackgroundEnabled( true )
myChat.dTextEntry:SetAlpha(0)

myChat.dTextEntry.OnKeyCodeTyped = function( self, code )
	if code == KEY_ESCAPE then
		myChat.closeChatbox()
		gui.HideGameUI()
	elseif code == KEY_ENTER then
		if string.Trim( self:GetText() ) != "" then if !chatbox_isteam then LocalPlayer():ConCommand( "say " .. self:GetText() ) ; else LocalPlayer():ConCommand( "say_team " .. self:GetText() ); end end
		myChat.closeChatbox()
	end
end

myChat.dRichText = vgui.Create("RichText", myChat.dFrame)
myChat.dRichText:SetPos(0,2)
myChat.dRichText:SetSize(size1, size2 - size2 / 10)
myChat.dRichText:SetVerticalScrollbarEnabled( false )
myChat.dRichText.Paint = function(self, w, h) draw.RoundedBox(0, 0, 0, w, h, Color(20,20,20,0)) end
myChat.dRichText:Show()
myChat.dRichText.PerformLayout = function (self)
self:SetFontInternal("FancyChatBox12")
self:SetFGColor( Color(42,42,42,255) )
end

hook.Add( "PlayerBindPress", "overrideChatbind", function( ply, bind, pressed )
    local bTeam = false
	chatbox_isteam = false
    if bind == "messagemode" then
    elseif bind == "messagemode2" then
        bTeam = true
		chatbox_isteam = true
	elseif bind == "cancelselect" then 
		myChat.closeChatbox()
    else
        return
    end

    myChat.openChatbox( bTeam )

    return true 
end )

hook.Add( "ChatText", "serverNotifications", function( index, name, text, type )
    if type == "joinleave" or type == "none" then
        myChat.dRichText:AppendText( text .. "\n" )
    end
end )

hook.Add( "HUDShouldDraw", "noMoreDefault", function( name )
	if name == "CHudChat" then
		return false
	end
end )

local oldAddText = chat.AddText
function chat.AddText( ... )
	local args = {...}
	for _, obj in ipairs( args ) do
		if type( obj ) == "table" then
			myChat.dRichText:InsertColorChange( obj.r, obj.g, obj.b, 255 )
		elseif type( obj ) == "string"  then 
			myChat.dRichText:AppendText( obj )
			myChat.dRichText:InsertFade(8, 2)
		elseif obj:IsPlayer() then
			local col = GAMEMODE:GetTeamColor( obj ) 
			myChat.dRichText:InsertColorChange( col.r, col.g, col.b, 255 )
			myChat.dRichText:AppendText( obj:Nick() )
			myChat.dRichText:InsertFade(8, 2)
		end
	end
	myChat.dRichText:AppendText( "\n" )
	myChat.dRichText:InsertFade(8, 2)
	oldAddText( ... )
end

function myChat.openChatbox(bTeam)
	myChat.dFrame:MakePopup()
	myChat.dFrame:SetMouseInputEnabled( true )

	myChat.dRichText:SetBGColor(42, 42, 42, 255)
	myChat.dRichText:ResetAllFades(true, false, 100000)
	myChat.dRichText:SetVerticalScrollbarEnabled( true)

	if bTeam then myChat.dTextEntry:SetBGColor(Color(34,34,34,255)); else myChat.dTextEntry:SetBGColor(Color(34,34,34,255));end
	myChat.dTextEntry:AlphaTo( 255, 0.25, 0)
	myChat.dTextEntry:RequestFocus()

	hook.Run( "StartChat" )
end

function myChat.closeChatbox()
	myChat.dFrame:SetMouseInputEnabled( false )
	myChat.dFrame:SetKeyboardInputEnabled( false )

	myChat.dTextEntry:SetText( "" )
	myChat.dTextEntry:AlphaTo(0, 0.25, 0)

	myChat.dRichText:ResetAllFades(false, false, 2)
	myChat.dRichText:SetBGColor(20, 20, 20, 0)
	myChat.dRichText:SetVerticalScrollbarEnabled( false )

	gui.EnableScreenClicker( false )

	hook.Run( "FinishChat" )
	hook.Run( "ChatTextChanged", "" )
end
end)

-- Edited: justa
-- convars
local setting_triggers = CreateClientConVar("kawaii_triggers", "0", true, false)
local setting_anticheats = CreateClientConVar("kawaii_anticheats", "0", true, false)
local setting_gunsounds = CreateClientConVar("kawaii_gunsounds", "1", true, false)
local setting_hints = CreateClientConVar("kawaii_hints", "180", true, false)

mousesmoothing = {}
mousesmoothing.Enabled = CreateClientConVar( "kawaii_mousesmoothing", "1", true, false, "Return sensitivity to smoother input." )

function GM:AdjustMouseSensitivity( fDefault )
    local mousesmoothing = mousesmoothing.Enabled:GetBool()
    if !mousesmoothing then return end

	local DIST_EPSILON = 0.03333333333333333333333333333333333333333 + 0.031250 + 0.02
	local ply = LocalPlayer()
	if ( !IsValid( ply ) ) then return 2323 + DIST_EPSILON end

   return 1 + DIST_EPSILON

end

-- Hints
local function AddMessage(message)
	chat.AddText(color_white, "[", Color(0, 200, 200), "Hint", color_white, "] ", message)
end

local hints = {
	"You can toggle anti-cheat visibility with !anticheats",
	"You can edit the style of your HUD with !theme",
	"You can edit the delay between these hints with \"kawaii_hints <delay>\" in your console. 0 will stop hints completely."
}

local lasthint = CurTime() + setting_hints:GetInt()
local hintindex = 1
hook.Add("Think", "Hints", function()
	if (setting_hints:GetInt() == 0) then return end

	if (lasthint < CurTime()) then
		AddMessage(hints[hintindex])

		lasthint = CurTime() + setting_hints:GetInt()
		hintindex = (hintindex == #hints) and 1 or (hintindex + 1)
	end
end)

if SERVER then

	local brightness = "1"

	function SetMapBrightness(value)
		local ply, mult
		if value and isstring(value) then
			mult = value
		elseif value and IsValid(value) then
			ply = value
		end

		if ply then
			if ply:IsBot() then return end
			ply:ConCommand( "kawaii_map_brightness " .. brightness )
		elseif mult then
			brightness = mult
			for _, ply in pairs( player.GetHumans() ) do 
				ply:ConCommand( "kawaii_map_brightness " .. mult )
			end
			sql.Query("UPDATE game_map SET nBrightness = " .. mult .. " WHERE szMap = '" .. game.GetMap() .. "'")
		else
			data = sql.Query("SELECT nBrightness FROM game_map WHERE szMap = '" .. game.GetMap() .. "'")
			if not Core:Assert(data, "nBrightness") then return end
			brightness = tostring(data[1]["nBrightness"])
			for _, ply in pairs( player.GetHumans() ) do 
				ply:ConCommand( "kawaii_map_brightness " .. brightness )
			end
		end
	end

	hook.Add("PlayerInitialSpawn", "SetMapBrightness", SetMapBrightness)

else

	local cc = {
		[ "$pp_colour_addr" ] = 0,
		[ "$pp_colour_addg" ] = 0,
		[ "$pp_colour_addb" ] = 0,
		[ "$pp_colour_brightness" ] = 0,
		[ "$pp_colour_contrast" ] = 1,
		[ "$pp_colour_colour" ] = 1.2,
		[ "$pp_colour_mulr" ] = 0,
		[ "$pp_colour_mulg" ] = 0,
		[ "$pp_colour_mulb" ] = 0
	}

	concommand.Add("kawaii_map_brightness", function(ply, cmd, args)
		cc[ "$pp_colour_contrast" ] = tonumber(args[1]) or 1		
	end)

	concommand.Add("kawaii_map_color", function(ply, cmd, args)
		cc[ "$pp_colour_colour" ] = tonumber(args[1]) or 1		
	end)

	hook.Add("RenderScreenspaceEffects", "MapBrightness", function()
		if cc[ "$pp_colour_contrast" ] == 1 then return end
		DrawColorModify(cc)
	end)

	function GM:PostProcessPermitted()
		return true
	end
	
end

SkyJSC = {}
SkyJSC.Enabled = CreateClientConVar( "kawaii_skybox", "0", true, false, "Rainbow skybox :)" )

CreateClientConVar( "kawaii_skybox_speed", 40 )
local skybox_speed =  GetConVarNumber("kawaii_skybox_speed")

hook.Add("PostDraw2DSkyBox", "coolest", function(PostDraw2DSkyBox)
  local SkyJSC = SkyJSC.Enabled:GetBool()
  if game.GetMap() == "bhop_nevercu" then return false end
  if game.GetMap() == "bhop_esthetic_gay" then return false end
  if game.GetMap() == "bhop_monotonous" then return false end
  if game.GetMap() == "bhop_mars" then return false end
  if game.GetMap() == "bhop_alt_univaje" then return false end
 
  if !SkyJSC then return end
    local col = HSVToColor( RealTime() * skybox_speed % 360, 1, 1 )
		render.Clear(col.r/1.3, col.g/1.3, col.b/1.3, 255)
    return 1
end)

--[[
  Author: justa
  Description: Motion Blur fall
--]]

GetMotionBlur = {}
GetMotionBlur.Enabled = CreateClientConVar( "kawaii_motion", "1", true, false, "Add CS:S Motion Blur." )

if SERVER then
	AddCSLuaFile()
else
	hook.Add("GetMotionBlurValues", "gMotionBlur.Render", function(h, v, f, r)
	  local GetMotionBlur = GetMotionBlur.Enabled:GetBool()
		if GetMotionBlur then
		if LocalPlayer():GetVelocity():Length() > 1200 then
			f = 0.01 + math.sin(CurTime() * 5) * 0.01
		end

		return h, v, f, r
		end
	end)
end

ShowKeys = {}
ShowKeys.Enabled = CreateClientConVar( "kawaii_showkeys", "1", true, false, "Displays the movement keys that are being pressed by the player." )
ShowKeys.Position = CreateClientConVar( "kawaii_showkeys_pos", "1", true, false, "Changes the position of the showkeys module, default is 0 (center)." )
ShowKeys.Color = color_white

local fb, lp = bit.band, LocalPlayer
local isPressing = function( ent, bit ) return ent:KeyDown( bit ) end

local syncData, syncAxis, syncStill = "", 0, 0
local spectatorBits = 0
local isSpecPressing = function( bit ) return fb( spectatorBits, bit ) > 0 end

local jumpTime = 0
local jumpDisplay = 0.25

local function norm( i ) if i > 180 then i = i - 360 elseif i < -180 then i = i + 360 end return i end

local keyStrings = {
  [512] = input.LookupBinding( "+moveleft" ) or "A",
  [1024] = input.LookupBinding( "+moveright" ) or "D",
  [8] = input.LookupBinding( "+forward" ) or "W",
  [16] = input.LookupBinding( "+back" ) or "",
  [4] = "+ DUCK",
  [2] = "+ JUMP",
  [128] = "<",
  [256] = ">",
}

local keyPositions = {
  [0] = {
    [512] = { ScrW() / 2 - 30, ScrH() / 2 },
    [1024] = { ScrW() / 2 + 30, ScrH() / 2 },
    [8] = { ScrW() / 2, ScrH() / 2 - 30 },
    [16] = { ScrW() / 2, ScrH() / 2 + 30 },
    [4] = { ScrW() / 2 - 60, ScrH() / 2 + 30 },
    [2] = { ScrW() / 2 + 60, ScrH() / 2 + 30 },
    [128] = { ScrW() / 2 - 60, ScrH() / 2 },
    [256] = { ScrW() / 2 + 60, ScrH() / 2 }
  },
  [1] = {
    [512] = { ScrW() - 120 - 30, ScrH() - 120 },
    [1024] = { ScrW() - 120 + 30, ScrH() - 120 },
    [8] = { ScrW() - 120, ScrH() - 120 - 30 },
    [16] = { ScrW() - 120, ScrH() - 120 + 30 },
    [4] = { ScrW() - 120 - 60, ScrH() - 120 + 30 },
    [2] = { ScrW() - 120 + 60, ScrH() - 120 + 30 },
    [128] = { ScrW() - 120 - 60, ScrH() - 120 },
    [256] = { ScrW() - 120 + 60, ScrH() - 120 }
  }
}

local function DisplayKeys()
  local wantsKeys = ShowKeys.Enabled:GetBool()
  if !wantsKeys then return end

  local lpc = lp()
  if !IsValid( lpc ) then return end

  local currentPos = ShowKeys.Position:GetInt()

  local isSpectating = lpc:Team() == ts
  local testSubject = lpc:GetObserverTarget()
  local isValidSpectator = isSpectating and IsValid( testSubject ) and testSubject:IsPlayer()

  if isValidSpectator then
    for key, text in pairs( keyStrings ) do
      local willDisplay = isSpecPressing(key)
      if (key == 2) and (jumpTime > RealTime()) then
        local pos = keyPositions[currentPos][key]
        draw.SimpleText( text, "HUDTimerMedThick", pos[1], pos[2], ShowKeys.Color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

        continue
      end

      if !willDisplay then continue end

      local pos = keyPositions[currentPos][key]
      text = string.upper( text )

      if (key == 2) then
        jumpTime = RealTime() + jumpDisplay
      end

      draw.SimpleText( text, "HUDTimerMedThick", pos[1], pos[2], ShowKeys.Color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    end

    local currentAngle = testSubject:EyeAngles().y
    local diff = norm( currentAngle - syncAxis )
    if diff > 0 then
      syncStill = 0

      local pos = keyPositions[currentPos][128]
      draw.SimpleText( "<", "HUDTimerMedThick", pos[1], pos[2], ShowKeys.Color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    elseif diff < 0 then
      syncStill = 0

      local pos = keyPositions[currentPos][256]
      draw.SimpleText( ">", "HUDTimerMedThick", pos[1], pos[2], ShowKeys.Color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    else
      syncStill = syncStill + 1
    end

    syncAxis = currentAngle
  else
    for key, text in pairs( keyStrings ) do
      local willDisplay = isPressing(lpc, key)
      if !willDisplay then continue end

      local pos = keyPositions[currentPos][key]
      text = string.upper( text )

      draw.SimpleText( text, "HUDTimerMedThick", pos[1], pos[2], ShowKeys.Color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

    end

    local currentAngle = lpc:EyeAngles().y
    local diff = norm( currentAngle - syncAxis )
    if diff > 0 then
      syncStill = 0

      local pos = keyPositions[currentPos][128]
      draw.SimpleText( "<", "HUDTimerMedThick", pos[1], pos[2], ShowKeys.Color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    elseif diff < 0 then
      syncStill = 0

      local pos = keyPositions[currentPos][256]
      draw.SimpleText( ">", "HUDTimerMedThick", pos[1], pos[2], ShowKeys.Color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    else
      syncStill = syncStill + 1
    end

    syncAxis = currentAngle

    local pos = { ScrW() - 15, ScrH() - 15 }
  end
end
hook.Add( "HUDPaint", "bhop.ShowKeys", DisplayKeys )

local function ReceiveSpecByte()
  spectatorBits = net.ReadUInt( 11 )
end
net.Receive( "bhop_ShowKeys", ReceiveSpecByte )

Cheats = {}

do
	Cheats.Fullbright = false

	function Cheats.ToggleFullbright(supress)
		Cheats.Fullbright = !Cheats.Fullbright

		if !supress then
			Chat.Print("Fullbright state: ", CL.Y, Cheats.Fullbright and "ON" or "OFF")
		end
	end

	hook.Add("PreRender", "sm_fullbright", function()
		if !Cheats.Fullbright then
			render.SetLightingMode(0)
		return end

		render.SetLightingMode(1)
		render.SuppressEngineLighting(false)
	end)

	hook.Add("PostRender", "sm_fullbright", function()
		render.SetLightingMode(0)
		render.SuppressEngineLighting(false)
	end)

	hook.Add("PreDrawHUD", "sm_fullbright_hudfix", function()
		render.SetLightingMode(0)
	end)

	hook.Add("PreDrawEffects", "sm_fullbright_effectfix", function()
		if !Cheats.Fullbright then return end

		render.SetLightingMode(0)
	end)

	hook.Add("PostDrawEffects", "sm_fullbright_effectfix", function()
		if !Cheats.Fullbright then return end

		render.SetLightingMode(0)
	end)

	hook.Add("PreDrawOpaqueRenderables", "sm_fullbright_opaquefix", function()
		if !Cheats.Fullbright then return end

		render.SetLightingMode(0)
	end)

	hook.Add("PostDrawTranslucentRenderables", "sm_fullbright_transluscentfix", function()
		if !Cheats.Fullbright then return end

		render.SetLightingMode(0)
	end)

	hook.Add("SetupWorldFog", "sm_fullbright_forcebrightworld", function()
		if !Cheats.Fullbright then return end

		render.SuppressEngineLighting(true)
		render.SetLightingMode(1)
		render.SuppressEngineLighting(false)
	end)

	hook.Add("PlayerBindPress", "sm_fullbright_flashlight", function( _, bind)
		local isValidBind = string.StartWith(bind, "impulse 100")

		if isValidBind then
			local bindingKey = input.LookupBinding(bind, true)
			local keyCode = input.GetKeyCode(bindingKey)
			local justReleased = input.WasKeyReleased(keyCode)

			if (isValidBind and !justReleased) then
				Cheats.ToggleFullbright(true)
			return true end
		end
	end)
end

do
	Cheats.Fog = false

	function Cheats.ToggleFog()
		Cheats.Fog = !Cheats.Fog

		Chat.Print("Fog Visibility: ", CL.Y, Cheats.Fog and "OFF" or "ON")
	end

	local function RenderFogs()
		if !Cheats.Fog then return end

		render.FogMode(MATERIAL_FOG_NONE)
		return true
	end
	hook.Add("SetupWorldFog", "sm_cheat_fog", RenderFogs)
end

function GM:HUDShouldDraw( szApp )
	return not HUDItems[ szApp ]
end

function Client:ToggleCrosshair( tabData )
	if tabData then
		for cmd,target in pairs( tabData ) do
			RunConsoleCommand( cmd, tostring( target ) )
		end
		Link:Print( "Notification", "Your crosshair options have been changed!" )
	else
		HUDItems[ "CHudCrosshair" ] = not HUDItems[ "CHudCrosshair" ]
		RunConsoleCommand( "sl_crosshair", HUDItems[ "CHudCrosshair" ] and 1 or 0 )
		Link:Print( "Notification", "Crosshair visibility has been toggled" )
	end
end

function Client:ToggleTargetIDs()
	local nNew = 1 - CTargetID:GetInt()
	RunConsoleCommand( "sl_targetids", nNew )
	Link:Print( "Notification", "You have " .. (nNew == 0 and "disabled" or "enabled") .. " player labels" )
end

function Core.SetDuckDiff()
	DuckDiff = (_C["Player"].HullStand - _C["Player"].HullDuck).z * 0.75
end


function Client:PlayerVisibility( nTarget )
	local nNew = -1
	if CPlayers:GetInt() == nTarget then
		RunConsoleCommand( "sl_showothers", 1 - nTarget )
		timer.Simple( 1, function() RunConsoleCommand( "sl_showothers", nTarget ) end )
		nNew = nTarget
	elseif nTarget < 0 then
		nNew = 1 - CPlayers:GetInt()
		RunConsoleCommand( "sl_showothers", nNew )
	else
		nNew = nTarget
		RunConsoleCommand( "sl_showothers", nNew )
	end

	if nNew >= 0 then
		Link:Print( "Notification", "You have set player visibility to " .. (nNew == 0 and "invisible" or "visible") )
	end
end

function Client:ShowHelp( tab )
	print( "\n\nBelow is a list of all available commands and their aliases:\n\n" )

	table.sort( tab, function( a, b )
		if not a or not b or not a[ 2 ] or not a[ 2 ][ 1 ] then return false end
		return a[ 2 ][ 1 ] < b[ 2 ][ 1 ]
	end )

	for _,data in pairs( tab ) do
		local desc, alias = data[ 1 ], data[ 2 ]
		local main = table.remove( alias, 1 )

		MsgC( Color( 212, 215, 134 ), "\tCommand: " ) MsgC( Color( 255, 255, 255 ), main .. "\n" )
		MsgC( Color( 212, 215, 134 ), "\t\tAliases: " ) MsgC( Color( 255, 255, 255 ), (#alias > 0 and string.Implode( ", ", alias ) or "None") .. "\n" )
		MsgC( Color( 212, 215, 134 ), "\t\tDescription: " ) MsgC( Color( 255, 255, 255 ), desc .. "\n\n" )
	end

	Link:Print( "Notification", "A list of commands and their descriptions has been printed in your console! Press ~ to open." )
end

function Client:ShowEmote( data )
	local ply
	for _,p in pairs( player.GetHumans() ) do
		if tostring( p:SteamID() ) == data[ 1 ] then
			ply = p
			break
		end
	end
	if not IsValid( ply ) then return end

	if ply:GetNWInt( "AccessIcon", 0 ) > 0 then
		local tab = {}
		local VIPNameColor = ply:GetNWVector( "VIPNameColor", Vector( -1, 0, 0 ) )
		if VIPNameColor.x >= 0 then
			local VIPName = ply:GetNWString( "VIPName", "" )
			if VIPName == "" then
				VIPName = ply:Name()
			end

			if VIPNameColor.x == 256 then
				tab = Client:GenerateName( tab, VIPName .. " " )
			elseif VIPNameColor.x == 257 then
				tab = Client:GenerateName( tab, VIPName .. " ", ply )
			else
				table.insert( tab, Core.Util:VectorToColor( VIPNameColor ) )
				table.insert( tab, VIPName .. " " )
			end

			if Client.VIPReveal and VIPName != ply:Name() then
				table.insert( tab, GUIColor.White )
				table.insert( tab, "(" .. ply:Name() .. ") " )
			end
		else
			table.insert( tab, Color( 98, 176, 255 ) )
			table.insert( tab, ply:Name() .. " " )
		end

		table.insert( tab, GUIColor.White )
		table.insert( tab, tostring( data[ 2 ] ) )

		chat.AddText( unpack( tab ) )
	end
end

function Client:VerifyList()
	if file.Exists( Cache.M_Name, "DATA" ) then
		Cache:M_Load()
	end
end

function Client:Mute( bMute )
	for _,p in pairs( player.GetHumans() ) do
		if LocalPlayer() and p != LocalPlayer() then
			if bMute and not p:IsMuted() then
				p:SetMuted( true )
			elseif not bMute and p:IsMuted() then
				p:SetMuted( false )
			end
		end
	end

	Link:Print( "Notification", "All players have been " .. (bMute and "muted" or "unmuted") .. "." )
end

function Client:DoChatMute( szID, bMute )
	for _,p in pairs( player.GetHumans() ) do
		if tostring( p:SteamID() ) == szID then
			p.ChatMuted = bMute
			Link:Print( "Notification", p:Name() .. " has been " .. (bMute and "chat muted" or "unmuted") .. "!" )
		end
	end
end

function Client:DoVoiceGag( szID, bGag )
	for _,p in pairs( player.GetHumans() ) do
		if tostring( p:SteamID() ) == szID then
			p:SetMuted( bGag )
			Link:Print( "Notification", p:Name() .. " has been " .. (bGag and "voice gagged" or "ungagged") .. "!" )
		end
	end
end

function Client:GenerateName( tab, szName, gradient )
	szName = szName:gsub('[^%w ]', '')
	local count = #szName
	local start, stop = Core.Util:RandomColor(), Core.Util:RandomColor()
	if gradient then
		local gs = gradient:GetNWVector( "VIPGradientS", Vector( -1, 0, 0 ) )
		local ge = gradient:GetNWVector( "VIPGradientE", Vector( -1, 0, 0 ) )

		if gs.x >= 0 then start = Core.Util:VectorToColor( gs ) end
		if ge.x >= 0 then stop = Core.Util:VectorToColor( ge ) end
	end

	for i = 1, count do
		local percent = i / count
		table.insert( tab, Color( start.r + percent * (stop.r - start.r), start.g + percent * (stop.g - start.g), start.b + percent * (stop.b - start.b) ) )
		table.insert( tab, szName[ i ] )
	end

	return tab
end

function Client:ToggleChat()
	local nTime = GetConVar( "hud_saytext_time" ):GetInt()
	if nTime > 0 then
		Link:Print( "Notification", "The chat has been hidden." )
		RunConsoleCommand( "hud_saytext_time", 0 )
	else
		Link:Print( "Notification", "The chat has been restored." )
		RunConsoleCommand( "hud_saytext_time", 12 )
	end
end

function Client:SpecVisibility( arg )
	local nNew = nil
	if not arg then
		nNew = 1 - Timer:GetSpecSetting()
	else
		nNew = tonumber( arg ) or 1
	end

	if nNew then
		RunConsoleCommand( "sl_showspec", nNew )
		Link:Print( "Notification", "You have set spectator list visibility to " .. (nNew == 0 and "invisible" or "visible") )
	end
end

function Client:ChangeWater()
	local a = GetConVar( "r_waterdrawrefraction" ):GetInt()
	local b = GetConVar( "r_waterdrawreflection" ):GetInt()
	local c = 1 - a

	RunConsoleCommand( "r_waterdrawrefraction", c )
	RunConsoleCommand( "r_waterdrawreflection", c )
	Link:Print( "General", "Water reflection and refraction have been " .. (c == 0 and "disabled" or "re-enabled") .. "!" )
end

function Client:Sky()
	local a = GetConVar( "r_skybox" ):GetInt()
	local b = GetConVar( "r_skybox" ):GetInt()
	local c = 1 - a

	RunConsoleCommand( "r_skybox", c )
	RunConsoleCommand( "r_skybox", c )
	Link:Print( "Notification", "Skybox is now " .. (c == 0 and "disabled" or "re-enabled") .. "!" )
end

function Client:Fog()
	RunConsoleCommand( "fog_enable", 0 )
	RunConsoleCommand( "fog_override", 1 )

	Link:Print( "Notification", "Fog is now disabled!" )
end

function Client:Simple()
	RunConsoleCommand( "mat_picmip", 99999999999999 )

	Link:Print( "Notification", "Simple textures is now " .. (c == 0 and "disabled" or "re-enabled") .. "!" )
end

function Client:ClearDecals()
	RunConsoleCommand( "r_cleardecals" )
	Link:Print( "Notification", "All players decals have been cleared from your screen." )
end

function Client:ToggleReveal()
	Client.VIPReveal = not Client.VIPReveal
	Link:Print( "Notification", "True VIP names will now " .. (Client.VIPReveal and "" or "no longer ") .. "be shown" )
end

function Client:DoFlipWeapons()
	local n = 0
	for _,wep in pairs( LocalPlayer():GetWeapons() ) do
		if wep.ViewModelFlip != Client.FlipStyle then
			wep.ViewModelFlip = Client.FlipStyle
		end

		n = n + 1
	end
	return n
end

function Client:FlipWeapons( bRestart )
	if IsValid( LocalPlayer() ) then
		if not bRestart then
			Client.Flip = not Client.Flip
			Client.FlipStyle = not Client.Flip

			local n = Client:DoFlipWeapons()
			if n > 0 then
				Link:Print( "Notification", "Your weapons have been flipped!" )
			else
				Link:Print( "Notification", "You had no weapons to flip. Flip again to revert back." )
			end
		elseif Client.Flip then
			timer.Simple( 0.1, function()
				Client:DoFlipWeapons()
			end )
		end
	end
end

function Client:ToggleSpace( bStart )
	if bStart then
		Client.SpaceToggle = not Client.SpaceToggle
	else
		if not IsValid( LocalPlayer() ) then return end
		if not Client.SpaceEnabled then
			Client.SpaceEnabled = true
			LocalPlayer():ConCommand( "+jump" )
		else
			LocalPlayer():ConCommand( "-jump" )
			Client.SpaceEnabled = nil
		end
	end
end

function Client:ServerSwitch( data )
	Link:Print( "Notification", "Now connecting to: " .. data[ 2 ] )
	Derma_Query( 'Are you sure you want to connect to ' .. data[ 2 ] .. '?', 'Connecting to different server', 'Yes', function() LocalPlayer():ConCommand( "connect " .. data[ 1 ] ) end, 'No', function() end)
end

function InitializeClient()
	timer.Create("SetHullAndView", 1, 0, SetHullAndViewOffset)
end
hook.Add( "Initialize", "CInitialize", InitializeClient )

local viewset = false
function SetHullAndViewOffset()
	local ent = LocalPlayer()
	if(LocalPlayer() && LocalPlayer():IsValid() && LocalPlayer().SetHull && LocalPlayer().SetHullDuck) then
		if(LocalPlayer().SetViewOffset && LocalPlayer().SetViewOffsetDucked && !viewset) then
			ent:SetViewOffset( _C["Player"].ViewStand )
			ent:SetViewOffsetDucked( _C["Player"].ViewDuck )
			viewset = true
		end
		ent:SetHull( _C["Player"].HullMin, _C["Player"].HullStand )
		ent:SetHullDuck( _C["Player"].HullMin, _C["Player"].HullDuck )
	end
end

local function ClientTick()
	if not IsValid( LocalPlayer() ) then timer.Simple( 1, ClientTick ) return end
	timer.Simple( 5, ClientTick )
	Core.SetDuckDiff()
	local ply = LocalPlayer()
	ply:SetHull( _C["Player"].HullMin, _C["Player"].HullStand )
	ply:SetHullDuck( _C["Player"].HullMin, _C["Player"].HullDuck )
end

local function ChatEdit( nIndex, szName, szText, szID )
	if szID == "joinleave" then
		return true
	end
end
hook.Add( "ChatText", "SuppressMessages", ChatEdit )

local function ChatTag( ply, szText, bTeam, bDead )
	if ply.ChatMuted then
		print( "[CHAT MUTE] " .. ply:Name() .. ": " .. szText )
		return true
	end

	local tab = {}
	if bTeam then
		table.insert( tab, Color( 30, 160, 40 ) )
		table.insert( tab, "(TEAM) " )
	end

	if ply:GetNWInt( "Spectating", 0 ) == 1 then
		table.insert( tab, Color( 189, 195, 199 ) )
		table.insert( tab, "*SPEC* " )
	end

	local nAccess = 0
	if IsValid( ply ) and ply:IsPlayer() then
		nAccess = ply:GetNWInt( "AccessIcon", 0 )
		local ID = ply:GetNWInt( "Rank", 1 )
		table.insert( tab, GUIColor.White )

		-- Edited by Niflheimrx
		-- Support custom titles with viptags
		-- Minor updates to rank colors

		local VIPTag, VIPTagColor = ply:GetNWString( "VIPTag", "" ), ply:GetNWVector( "VIPTagColor", Vector( -1, 0, 0 ) )
		if nAccess > 0 and VIPTag != "" and VIPTagColor.x >= 0 then
			table.insert( tab, Core.Util:VectorToColor( VIPTagColor ) )
			table.insert( tab, VIPTag )
			table.insert( tab, " | " )
			table.insert( tab, GUIColor.White )
		else
			table.insert( tab, _C.Ranks[ ID ][ 2 ] )
			table.insert( tab, _C.Ranks[ ID ][ 1 ] )
					table.insert( tab, GUIColor.White )
			table.insert( tab, " | " )
			table.insert( tab, GUIColor.White )
		end

		if nAccess > 0 then
			local VIPNameColor = ply:GetNWVector( "VIPNameColor", Vector( -1, 0, 0 ) )
			if VIPNameColor.x >= 0 then
				local VIPName = ply:GetNWString( "VIPName", "" )
				if VIPName == "" then
					VIPName = ply:Name()
				end

				if VIPNameColor.x == 256 then
					tab = Client:GenerateName( tab, VIPName )
				elseif VIPNameColor.x == 257 then
					tab = Client:GenerateName( tab, VIPName, ply )
				else
					table.insert( tab, Core.Util:VectorToColor( VIPNameColor ) )
					table.insert( tab, VIPName )
				end

				if Client.VIPReveal and VIPName != ply:Name() then
					table.insert( tab, GUIColor.White )
					table.insert( tab, " (" .. ply:Name() .. ")" )
				end
			else
				table.insert( tab, Color( 98, 176, 255 ) )
				table.insert( tab, ply:Name() )
			end
		else
			table.insert( tab, Color( 98, 176, 255 ) )
			table.insert( tab, ply:Name() )
		end
	else
		table.insert( tab, "Console" )
	end

	table.insert( tab, GUIColor.White )
	table.insert( tab, ": " )

	if nAccess > 0 then
		local VIPChat = ply:GetNWVector( "VIPChat", Vector( -1, 0, 0 ) )
		if VIPChat.x >= 0 then
			table.insert( tab, Core.Util:VectorToColor( VIPChat ) )
		end
	end

	table.insert( tab, szText )

	chat.AddText( unpack( tab ) )
	return true
end
hook.Add( "OnPlayerChat", "TaggedChat", ChatTag )

local function EntityCheckPost( ply )

	local ply = LocalPlayer()

	if ( ply ) then
		ply:SetViewOffset( _C["Player"].ViewStand )
		ply:SetViewOffsetDucked( _C["Player"].ViewDuck )
	end

	hook.Remove( "PostDrawOpaqueRenderables", "PlayerMarkers" )
	RunConsoleCommand( "sl_targetids", 0 )
end
hook.Add( "InitPostEntity", "StartEntityCheck", EntityCheckPost )

local function VisibilityCallback( CVar, Previous, New )
	if tonumber( New ) == 1 then
		for _,ent in pairs( ents.FindByClass("env_spritetrail") ) do
			ent:SetNoDraw( false )
		end
		for _,ent in pairs( ents.FindByClass("beam") ) do
			ent:SetNoDraw( false )
		end
	else
		for _,ent in pairs( ents.FindByClass("env_spritetrail") ) do
			ent:SetNoDraw( true )
		end
		for _,ent in pairs( ents.FindByClass("beam") ) do
			ent:SetNoDraw( true )
		end
	end
end
cvars.AddChangeCallback( "sl_showothers", VisibilityCallback )

local function PlayerVisiblityCheck( ply )
	ply:SetNoDraw(not CPlayers:GetBool())
	if not CPlayers:GetBool() then return true end
end
hook.Add( "PrePlayerDraw", "PlayerVisiblityCheck", PlayerVisiblityCheck )

local function Initialize()
	Core.SetDuckDiff()
	timer.Simple( 5, ClientTick )
	timer.Simple( 5, function() Core:Optimize() end )

	for _,str in pairs( HUDItems ) do
		HUDItems[ str ] = true

		if str == "CHudCrosshair" then
			HUDItems[ str ] = CCrosshair:GetBool()
		end
	end

	Client:VerifyList()

	if CSteam:GetBool() and _C.SteamGroup != "" then
		timer.Simple( 1, function()
			Derma_Query( "Welcome to " .. _C.ServerName .. "!\nDo you want to join our public Garry's Mod Steam Group?\n\nClick Yes to join!\nIf you want to play a bit first, press No.\nIf you don't want to see this message any more, click Hide.",
			"Steam Group Invitation", "Yes", function()
				gui.OpenURL( _C.SteamGroup )
				RunConsoleCommand( "sl_steamgroup", 0 )
			end, "No", function() end, "Hide", function()
				RunConsoleCommand( "sl_steamgroup", 0 )
			end )
		end )
	end

end
hook.Add( "Initialize", "ClientBoot", Initialize )

-- Edited: justa
-- Show/Remove triggers
-- Show/Remove anti-cheats

hook.Add("Think", "WillBeRemoved", function()
	if IsValid(LocalPlayer()) then
		timer.Simple(0.5, function()
			for _, ent in pairs(ents.FindByClass("trigger_teleport")) do
				ent:AddEffects(EF_NODRAW)
			end

			for _, ent in pairs(ents.FindByClass("trigger_multiple")) do
				ent:AddEffects(EF_NODRAW)
			end
		end)

		hook.Remove("Think", "WillBeRemoved")
	end
end)


concommand.Add("bhop_toggletriggers", function(client, command, args)
	local triggers = GetConVar("kawaii_triggers")
	triggers:SetInt(triggers:GetInt() == 1 and 0 or 1)
	for _, ent in pairs(ents.FindByClass("trigger_*")) do
		if (triggers) then
			ent:RemoveEffects(EF_NODRAW)
		elseif (not triggers) then
			ent:AddEffects(EF_NODRAW)
		end
	end
end)

concommand.Add("_toggleanticheats", function(client, command, args)
	local acs = GetConVar("kawaii_anticheats")
	acs:SetInt(acs:GetInt() == 1 and 0 or 1)
end)

concommand.Add("_togglegunsounds", function()
	local gunshots = GetConVar("kawaii_gunsounds")
	gunshots:SetInt(gunshots:GetInt() == 1 and 0 or 1)
end)
