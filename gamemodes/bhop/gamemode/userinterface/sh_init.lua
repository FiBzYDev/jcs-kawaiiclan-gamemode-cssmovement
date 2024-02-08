--[[
  Author: Niflheimrx
  Description: Simple loader for new files so I don't have to manually keep editing files.
	Edited by fibzy for BHOP
--]]

-- Make a new global table, this should make things easy to work with --
Surf = {}
Surf.ServerLogging  = true -- This should always be true, unless you don't want messages showing in chat
Surf.ServerDebug    = true -- Keep this false, unless you want a bunch of blue-colored messages
Surf.ConsoleColor   = { ["error"] = Color( 255, 0, 0 ), ["warning"] = Color( 255, 255, 0 ), ["success"] = Color( 0, 255, 0 ), ["debug"] = Color( 0, 255, 255 ) } -- It is best to not change these

-- Simple console notification messages with colors --
function Surf:Notify( type, message )
  if not Surf.ServerLogging then return end

  local messageType = string.lower( type )
  if messageType == "debug" and not Surf.ServerDebug then return end

  local prefixColor = Surf.ConsoleColor[ messageType ]

  MsgC( prefixColor, "[" .. string.upper( messageType ) .. "] ", message, "\n" )
end