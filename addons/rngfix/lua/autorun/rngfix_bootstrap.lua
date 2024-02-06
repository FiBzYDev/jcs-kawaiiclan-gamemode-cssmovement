-- "addons\\rngfix\\lua\\autorun\\rngfix_bootstrap.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
-- [ RNGFix for Garry's mod ]
-- More info: https://github.com/jason-e/rngfix
-- Ported by: https://steamcommunity.com/id/CLazStudio

_G.RNGFix = _G.RNGFix or {}
RNGFix.Version = 202207070 -- YYYYMMDDX
RNGFix.Refresh = (RNGFix.Refresh ~= nil)
RNGFix.POST_THINK_HOOK = "PlayerPostThink"

if SERVER then
	AddCSLuaFile("rngfix/sh_rngfix.lua")
	AddCSLuaFile("rngfix/cl_debug.lua")
	AddCSLuaFile("rngfix/cl_init.lua")

	--include("rngfix/sv_debug.lua")
	--include("rngfix/sv_boosterfix.lua")
	include("rngfix/sh_rngfix.lua")
	include("rngfix/sv_init.lua")
else
	include("rngfix/cl_debug.lua")
	include("rngfix/sh_rngfix.lua")
	include("rngfix/cl_init.lua")
end