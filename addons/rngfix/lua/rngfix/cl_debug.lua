-- "addons\\rngfix\\lua\\rngfix\\cl_debug.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local RNGFix = _G.RNGFix
local print, net, string, pcall = print, net, string, pcall
local Debug = {}

local LASER_WIDTH = 0.5
local LASER_LIFE = 15

local COLORS = {
	CL_1 = Color(255, 166, 0),
	CL_2 = Color(0, 255, 115),
	SV_1 = Color(28, 255, 244),
	SV_2 = Color(162, 0, 255),
}

local DEBUG_HELP = "0 - Off; 1 - Debug messages; 2 - Debug messages and lasers."
local g_cvDebug = CreateConVar("rngfix_debug", "0", FCVAR_REPLICATED + FCVAR_NOTIFY, DEBUG_HELP, 0.0, 2.0)
local g_cvDebugCl = CreateConVar("rngfix_debug_cl", "0", FCVAR_USERINFO + FCVAR_NOTIFY, DEBUG_HELP, 0.0, 2.0)

local lasers = {}
local nextId = 1
local isHooked = false

local function DrawLasers(bDepth, bSkybox)
	if bSkybox then return end

	render.SetColorMaterialIgnoreZ()
	for _, laser in pairs(lasers) do
		render.DrawBeam(laser[1], laser[2], LASER_WIDTH, 0, 0, laser[3])
	end
end

local function AddLaser(p1, p2, col, server)
	local color = col == 1 and COLORS.CL_1 or COLORS.CL_2
	if server then color = col == 1 and COLORS.SV_1 or COLORS.SV_2 end
	local id = tostring(nextId)

	-- TODO: Use debugoverlay.Line
	lasers[id] = { p1, p2, color }
	timer.Simple(LASER_LIFE, function()
		lasers[id] = nil
	end)
	nextId = (nextId + 1) % 1000

	if not isHooked then
		hook.Add("PostDrawTranslucentRenderables", "RNGFix", DrawLasers)
		isHooked = true
	end
end

net.Receive("RNGFIX_DebugLaser", function(len)
	local p1 = net.ReadVector()
	local p2 = net.ReadVector()
	local col = net.ReadUInt(8)
	AddLaser(p1, p2, col, true)
end)

local function DebugMsg(ply, fmt, ...)
	if not IsFirstTimePredicted() then return end
	local tick = RNGFix.g_iTick[ply] % 1000
	local ok, str = pcall(string.format, fmt, ...)
	if not ok then return print("[RNGFix]", fmt, str, tick, ...) end
	print(string.format("[RNGFix] %d", tick), str)
end

local function DebugLog(fmt, ...)
	if istable(fmt) then return PrintTable(fmt) end
	local ok, str = pcall(string.format, fmt, ...)
	if not ok then return print("[RNGFix]", fmt, str, ...) end
	return print("[RNGFix]", str)
end

local function DebugLaser(ply, p1, p2, col)
	if not IsFirstTimePredicted() then return end
	AddLaser(p1, p2, col, false)
end

local function Nothing() end

local function ToggleDebugCl(_, _, val)
	local num = math.Round(tonumber(val) or 0)

	if num ~= 0 and g_cvDebug:GetInt() == 0 then
		DebugLog("%s is disabled!", g_cvDebug:GetName())
		return g_cvDebugCl:SetInt(0)
	end

	Debug.Enabled, Debug.Log = (num > 0), DebugLog

	if num == 1 then
		Debug.Msg, Debug.Laser = DebugMsg, Nothing
	elseif num == 2 then
		Debug.Msg, Debug.Laser = DebugMsg, DebugLaser
	else
		hook.Remove("PostDrawTranslucentRenderables", "RNGFix")
		Debug.Msg, Debug.Laser, Debug.Log = Nothing, Nothing, Nothing
		isHooked = false
	end
end

cvars.AddChangeCallback(g_cvDebugCl:GetName(), ToggleDebugCl, "RNGFix")
cvars.AddChangeCallback(g_cvDebug:GetName(), function()
	ToggleDebugCl(_, _, g_cvDebugCl:GetString())
end, "RNGFix")
ToggleDebugCl(_, _, g_cvDebugCl:GetString())

RNGFix.g_cvDebug = g_cvDebugCl
RNGFix.AddLaser = AddLaser
RNGFix.Debug = Debug
