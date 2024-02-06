-- HUD
-- by Justa

local surface = surface
local draw = draw
local Color = Color

-- ConVar to select which HUD we want to use
local selected_hud = CreateClientConVar("kawaii_hud", 4, true, false)

-- Font
surface.CreateFont( "HUDTimer", { size = 17, weight = 800, font = "Trebuchet24" } )
surface.CreateFont( "HUDTimer2", { size = 18, weight = 100000, font = "Lato" } )	
surface.CreateFont( "HUDTimerBig", { size = 28, weight = 400, font = "Trebuchet24" } )
surface.CreateFont( "HUDTimerMedThick", { size = 22, weight = 40000, font = "Trebuchet24" } )
surface.CreateFont( "HUDTimerKindaUltraBig", { size = 28, weight = 4000, font = "Trebuchet24" } )

surface.CreateFont( "HUDcsstop2", { size = 40, weight = 1000, antialias = true, font = "FiBuchetMS-Bold" } )
surface.CreateFont( "HUDcss", { size = 21, weight = 800, antialias = true, bold = true, font = "Verdana" } )
surface.CreateFont( "HUDcssBottomTimer", { size = 21.9, weight = 800, antialias = true, bold = true, font = "Verdana" } )
surface.CreateFont( "HUDcssBottom", { size = 21.5, weight = 800, antialias = true, bold = true, font = "Verdana" } )
surface.CreateFont( "HUDcss4", { size = 21, weight = 800, antialias = true, bold = true, font = "Verdana" } )
surface.CreateFont( "HUDcss2", { size = 21, weight = 700, bold = true, antialias = true, font = "Verdana" } )

-- Converting a time
local fl, fo  = math.floor, string.format
local function ConvertTime(ns)
	ns = math.Round(ns, 4)

	if ns > 3600 then
		return fo( "%d:%.2d:%.2d.%.3d", fl( ns / 3600 ), fl( ns / 60 % 60 ), fl( ns % 60 ), fl( ns * 1000 % 1000 ) )
	else
		return fo( "%.2d:%.2d.%.3d", fl( ns / 60 % 60 ), fl( ns % 60 ), fl( ns * 1000 % 1000 ) )
	end
end

local function cCTime(ns)
	ns = math.Round(ns, 4)

	if ns > 3600 then
		return fo( "%d:%.2d%.2d.%.3d", fl( ns / 3600 ), fl( ns / 60 % 60 ), fl( ns % 60 ), fl( ns * 1000 % 1000 ) )
	elseif ns > 60 then 
		return fo( "%.1d:%.2d.%.3d", fl( ns / 60 % 60 ), fl( ns % 60 ), fl( ns * 1000 % 1000 ) )
	else
		return fo( "%.1d.%.3d", fl( ns % 60 ), fl( ns * 1000 % 1000 ) )
	end
end

local function cTime(ns)
	ns = math.Round(ns, 4)

	if ns > 3600 then
		return fo( "%d:%.2d:%.2d.%.1d", fl( ns / 3600 ), fl( ns / 60 % 60 ), fl( ns % 60 ), fl( ns * 10 % 10 ) )
	elseif ns > 60 then 
		return fo( "%.1d:%.2d.%.1d", fl( ns / 60 % 60 ), fl( ns % 60 ), fl( ns * 10 % 10 ) )
	else
		return fo( "%.1d.%.1d", fl( ns % 60 ), fl( ns * 10 % 10 ) )
	end
end

-- Neat :)
HUD = {}
HUD.Ids = {"Counter Strike: Source", "Counter Strike: Source Shavit", "Simple", "Momentum", "Flow Network"}

-- Themes
local sync = "0"

local last = 0
local coll
local lastUp = CurTime()

local RECORDS = {}
local function GetCurrentPlacement(current, s)
	local timetbl = RECORDS[s] or {}
	local c = 1

	for k, v in pairs(timetbl) do 
		if current > v then 
			c = k
		end
	end

	return c
end

HUD.Themes = {
	function(pl, data) -- CS:S
		local base = Color(20, 20, 20, 150)
		local text = color_white

		if (data.strafe) then 
			sync = data.sync or sync
			return
		end

		-- Current Vel
		local velocity = math.floor(pl:GetVelocity():Length2D())

		-- Strings
		local time = "Time: "
		local pb = "PB: "
		local style = pl:GetNWInt("Style", 1)
		local stylename = Core:StyleName(style or 1) .. (pl:IsBot() and " Replay" or "")

		-- Personal best
		local personal = ConvertTime(data.pb or 0)

		-- Current Time
		local current = data.current < 0 and 0 or data.current
		local currentf = cTime(current)

		-- Jumps
		jumps = pl.player_jumps or 0

		-- Activity 
		local activity = current > 0 and 1 or 2
		activity = (pl:GetNWInt("inPractice", false) or (pl.TnF or pl.TbF)) and 3 or activity
		activity = (activity == 1 and (pl:IsBot() and 4 or 1) or activity)

		-- Outer box
		local width = 130
		local height = {124, 64, 44, 84}
		height = height[activity]
		local xPos = (ScrW() / 2) - (width / 2)
		local yPos = ScrH() - height - 60 - (LocalPlayer():Team() == TEAM_SPECTATOR and 50 or 0)

		draw.RoundedBox(16, xPos, yPos, width, height, base)

		-- HUD on the bottom
		if (activity == 1) then 
			draw.SimpleText(stylename, "HUDTimer", ScrW() / 2, yPos + 20, text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)		
			draw.SimpleText(time .. currentf, "HUDTimer", ScrW() / 2, yPos + 40, text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText("Jumps: " .. jumps or 0, "HUDTimer", ScrW() / 2, yPos + 60, text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText("Sync: " .. sync .. "%", "HUDTimer", ScrW() / 2, yPos + 80, text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)	
			draw.SimpleText("Speed: " .. velocity, "HUDTimer", ScrW() / 2, yPos + 100, text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)			
		elseif (activity == 2) then
			draw.SimpleText("In Start Zone", "HUDTimer", ScrW() / 2, yPos + 20, text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText("Speed: " .. velocity, "HUDTimer", ScrW() / 2, yPos + 40, text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)			
		elseif (activity == 3) then
			draw.SimpleText("Speed: " .. velocity, "HUDTimer", ScrW() / 2, yPos + 20, text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)			
		elseif (activity == 4) then 
			draw.SimpleText(stylename, "HUDTimer", ScrW() / 2, yPos + 20, text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)		
			draw.SimpleText(time .. currentf, "HUDTimer", ScrW() / 2, yPos + 40, text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText("Speed: " .. velocity, "HUDTimer", ScrW() / 2, yPos + 60, text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)		
		end

		local wr, wrn
		if (not WorldRecords) or (not WorldRecords[style]) or (#WorldRecords[style] == 0) then 
			wr = "No time recorded"
			wrn = ""
		else 
			wr = ConvertTime(WorldRecords[pl:GetNWInt("Style", 1)][2])
			wrn = "(" .. WorldRecords[pl:GetNWInt("Style", 1)][1] .. ")"
		end

		local pbtext
		if (data.pb) == 0 then 
			pbtext = "No Time"
		else 
			pbtext = cCTime(data.pb or 0)
		end

		-- Top 
		draw.SimpleText("WR: " .. wr .. " " .. wrn, "HUDTimerBig", 10, 6, text)
		draw.SimpleText(pb .. pbtext, "HUDTimerBig", 10, 34, text)	

		-- Spec 
		if (LocalPlayer():Team() == TEAM_SPECTATOR) then 
			-- Draw big box
			surface.SetDrawColor(base)
			surface.DrawRect(0, ScrH() - 80, ScrW(), ScrH())

			-- Name
			local name = pl:Name()

			-- Bot?
			if (pl:IsBot()) then 
				name = Core:StyleName(style or 1) .. " Replay (" .. pl:GetNWString("BotName", "Loading...") .. ")"
			end

			draw.SimpleText(name, "HUDTimer", ScrW() / 2, ScrH() - 40, text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)		
		end	
	end,

	function(pl, data) -- CS:S Shavit
		local ScrWidth, ScrHeight = ScrW, ScrH
		local w, h = ScrWidth(), ScrHeight()
	
			if (data.strafe) then 
				sync = data.sync or sync
				return
			end

			-- Current Vel
			local velocity = math.floor(pl:GetVelocity():Length2D())
	
			if (velocity == 0) then
				velocity = 0
			else
				if (velocity <= 33) then
					velocity = 30
				end 
			end

			-- Strings
			local time = "Time: "
			local pb = "Best: "
			local style = pl:GetNWInt("Style", 1)
			local stylename = Core:StyleName(style or 1) .. (pl:IsBot() and " Replay" or "")
	
			-- Personal best
			local personal = cCTime(data.pb or 0)
	
			-- Current Time
			local current = data.current < 0 and 0 or data.current
			local currentf = cTime(current)

			-- Jumps
			jumps = pl.player_jumps or 0

			local base = Color(0, 0, 0, 70)
			
			local activity = current > 0 and 1 or 2
			activity = (pl:GetNWInt("inPractice", false) or (pl.TnF or pl.TbF)) and 3 or activity
			activity = (activity == 1 and (pl:IsBot() and 4 or 1) or activity)

			local box_y_css = -4
			local box_y_css2 = -8
			local text_y_css = 5
			local text_y_css2 = -22
			local text_y_css4 = 2

			local width = {162, 164, 125, 165}
			local width2 = {162, 164, 38, 165}

			width = width[activity]
			width2 = width2[activity]

			local height = {136, 95, 56, 90}
			height = height[activity]

			local activity_y = {175, 175, 175, 175}
			activity_y = activity_y[activity]

			local xPos = (ScrW()/2) - (width/2)
			local xPos2= (ScrW()/2) - (width2/2)
			local yPos = ScrH() - height - activity_y
			local CSRound2 = 8

			local wrtext = "WR: "

			local wr, wrn
			if (not WorldRecords) or (not WorldRecords[style]) or (#WorldRecords[style] == 0) then 
				wr = "No Record"
				wrn = ""
			else 
				wr = cCTime(WorldRecords[pl:GetNWInt("Style", 1)][2])
				wrn = "(" .. WorldRecords[pl:GetNWInt("Style", 1)][1] .. ")"
			end

			local pbtext
			if (data.pb) == 0 then 
				pbtext = "No Time"
			else 
				pbtext = cCTime(data.pb or 0)
			end

			draw.SimpleText("WR: " .. wr .. " " .. wrn, "HUDcsstop2", 19, 10, color_white, text, TEXT_ALIGN_LEFT)
			draw.SimpleText(pb .. pbtext, "HUDcsstop2", 19, 50, color_white, text, TEXT_ALIGN_LEFT)	

			if (activity == 1) then
				local TimeText = "Time: " .. currentf
				local Vel = "Speed: " .. velocity
				local Scaling = TimeText
				local placement = GetCurrentPlacement(nCurrent, s)

				draw.SimpleText(stylename, "HUDcss4", ScrW() / 2.002, text_y_css + yPos + 19, text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)		
				draw.SimpleText(Scaling .. " (#" .. placement .. ")", "HUDcssBottomTimer", ScrW() / 2, text_y_css + yPos + 39, text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				draw.SimpleText("Jumps: " .. jumps, "HUDcssBottom", ScrW() / 2, text_y_css + yPos + 59, text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				draw.SimpleText("Sync: " .. (sync) .. "%", "HUDcssBottom", ScrW() / 2.002, text_y_css + yPos + 79, text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER) -- Change to Strafes
				draw.SimpleText(Vel, "HUDcssBottom", ScrW() / 2.002, text_y_css + yPos + 99, text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

				local Scaling = surface.GetTextSize(Scaling)

				draw.RoundedBox(CSRound2, ScrW() / 2 - Scaling / 2 - 35 - 15 + 7, yPos + box_y_css, Scaling + 98 - 11, height, base)
			elseif (activity == 2) then
				draw.SimpleText("In Start Zone", "HUDcss", ScrW() / 2.002, text_y_css2 + yPos + 44, text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				draw.SimpleText(velocity, "HUDcss", ScrW() / 2.007, text_y_css2 + yPos + 84, text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				draw.RoundedBox(CSRound2, xPos, yPos + box_y_css2, width, height, base)
			elseif (activity == 3) then
				local Vel2 = velocity

				draw.SimpleText(Vel2, "HUDcss", ScrW() / 2, text_y_css4 + yPos + 22, text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				local Vel2 = surface.GetTextSize(Vel2)

				draw.RoundedBox(CSRound2, xPos2 - (Vel2/2), yPos + box_y_css, width2 + Vel2, height, base)
			elseif (activity == 4) then
				draw.SimpleText(stylename, "HUDcss", ScrW() / 2, text_y_css2 + yPos + 20 + 22, text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				draw.SimpleText("Time: " .. currentf, "HUDcss", ScrW() / 2, text_y_css2 + yPos + 40 + 22, text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				draw.SimpleText("Speed: " .. velocity, "HUDcss", ScrW() / 2, text_y_css2 + yPos + 60 + 22, text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				draw.RoundedBox(CSRound2, xPos, yPos + box_y_css, width, height, base)
			end
	end,

	-- Simple
	function(pl, data)
		local base = Color(20, 20, 20, 150)
		local text = color_white

		local width = 200
		local height = 100
		local xPos = (ScrW() / 2) - (width / 2)
		local yPos = ScrH() - 90 - height

		if (data.strafe) then 
			sync = data.sync or sync
			return
		end

		local theme = Momentum
		local box = Color(0, 0, 0, 100)
		local tc = color_white
		local tc2 = Color(0, 160, 200)
		local su = Color(0, 160, 200)
		local sd = Color(200, 0, 0)
		local start = false

		local current = data.current < 0 and 0 or data.current
		local time = ConvertTime(current)

		local personal = data.pb 
		local personalf = ConvertTime(personal) .. data.recTp

		local status = "No Timer"

		-- Current Vel
		local velocity = math.floor(pl:GetVelocity():Length2D())

		if (velocity == 0) then
			velocity = 0
		else
			if (velocity <= 33) then
				velocity = 30
			end 
		end

		-- Jumps
		jumps = pl.player_jumps or 0
	
		-- Strings
		local style = pl:GetNWInt("Style", 1)
		local stylename = Core:StyleName(style or 1) .. (pl:IsBot() and " Replay" or "")

		-- Personal best
		local personal = ConvertTime(data.pb or 0)

		-- Current Time
		local current = data.current < 0 and 0 or data.current
		local currentf = ConvertTime(current)

		-- Jumps
		jumps = pl.player_jumps or 0

		local current = data.current < 0 and 0 or data.current
		local time = ConvertTime(current)

		local szStyle = Core:StyleName(pl:GetNWInt("Style", _C.Style.Normal))

		local personal = data.pb 
		local personalf = ConvertTime(personal) .. data.recTp

		local status = "Disabled"

		if current > 0.01 then
			status = time
		end

		if (pl.TnF or pl.TbF) then 
			status = ConvertTime(current)

			if pl.TnF or pl.TbF then 
				draw.SimpleText("Map Completed", "HUDTimer2", ScrW() / 2, yPos + 24, tc, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end 
		end

		draw.SimpleText("Time: " .. status, "HUDTimer2", ScrW() / 2, yPos + 60, tc, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

		if current < 0.01 and not pl:GetNWInt("inPractice", true) and pl:GetMoveType() != MOVETYPE_NOCLIP then 
			draw.SimpleText("Start Zone", "HUDTimer2", ScrW() / 2, yPos + 92, tc, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText("Unranked", "HUDTimer2", ScrW() / 2, yPos + 123, tc, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText(velocity .. " u/s", "HUDTimer2", ScrW() / 2, yPos - 520, tc, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		else
			draw.SimpleText(szStyle, "HUDTimer2", ScrW() / 2, yPos + 92, tc, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText(velocity .. " u/s", "HUDTimer2", ScrW() / 2, yPos - 520, tc, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

			draw.SimpleText("Sync: " .. sync .. "%", "HUDTimer2", 1755, 1000, tc)
			draw.SimpleText("Jumps: " .. jumps or 0, "HUDTimer2", 100, 1000, tc)
		end

		if not pl:IsBot() and pl:GetNWInt("inPractice", true) then 
			draw.SimpleText("Practicing", "HUDTimer2", ScrW() / 2, yPos + 24, tc, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end

		local wr, wrn
		if (not WorldRecords) or (not WorldRecords[style]) or (#WorldRecords[style] == 0) then 
			wr = "No time recorded"
			wrn = ""
		else 
			wr = ConvertTime(WorldRecords[pl:GetNWInt("Style", 1)][2])
			wrn = "(" .. WorldRecords[pl:GetNWInt("Style", 1)][1] .. ")"
		end

		local pbtext
		if (data.pb) == 0 then 
			pbtext = "No time recorded"
		else 
			pbtext = ConvertTime(data.pb or 0)
		end

		-- Top 
		draw.SimpleText("Map: " .. game.GetMap(), "HUDTimer2", 10, 8, tc, TEXT_ALIGN_LEFT)
		draw.SimpleText("World Record: " .. wr .. " " .. wrn, "HUDTimer2", 9, 28, tc)
		draw.SimpleText("Personal Best: " .. pbtext, "HUDTimer2", 10, 48, tc)	

		-- In spec
		if LocalPlayer():Team() == TEAM_SPECTATOR then
			local ob = pl
			if IsValid( ob ) and ob:IsPlayer() then
				local nStyle = ob:GetNWInt( "Style", _C.Style.Normal )
				local szStyle = Core:StyleName( nStyle )

				if ob:IsBot() then
					draw.SimpleText("Status: Playing (1x)", "HUDTimer", ScrW() / 2, yPos + 48, text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				end

				local header, pla
				if ob:IsBot() then
					header = "Spectating"
					pla =  szStyle .. " Replay " .. "(" .. ob:GetNWString("BotName", "Loading...") .. ")"
				else
					header = "Spectating"
					pla = szStyle .. " (" .. ob:Name() .. ")"
				end

	  		 	 if (velocity == 0) then
		 			   	velocity = 0
	       			 else
	    				if (velocity <= 33) then
		  	 		 	velocity = 30
		  			  end 
	   			 end

       			 if last < velocity then
       			     coll = Color(0, 160, 200)
      			  end
       			 if last > velocity then
        		    coll = Color(255,0,0)
      			  end
       			 if last == velocity then
         		   if CurTime() > (lastUp + 0.5) then
          		      coll = Color(255, 255, 255)
         		       lastUp = CurTime()
         		   end
       			 end

				local width = 200
				local height = 100
				local xPos = (ScrW() / 2) - (width / 2)
				local yPos = ScrH() - height - 60 - (LocalPlayer():Team() == TEAM_SPECTATOR and 50 or 0)

      			last = current
       			draw.SimpleText(string.Split(velocity, ".")[1], "HUDTimerKindaUltraBig", ScrW() / 2, yPos - 110 + 50, coll, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				draw.SimpleText( header, "HUDHeaderBig", ScrW() / 2, 15, Color(25, 25, 25, 255), TEXT_ALIGN_CENTER )
				draw.SimpleText( header, "HUDHeaderBig", ScrW() / 2, 15, Color(0, 160, 200, 255), TEXT_ALIGN_CENTER )
				draw.SimpleText( pla, "HUDHeader", ScrW() / 2, 56, Color(25, 25, 25, 255), TEXT_ALIGN_CENTER )
				draw.SimpleText( pla, "HUDHeader", ScrW() / 2, 56, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER )
			end
		end
	end,

	function(pl, data) -- Momentum
		local base = Color(20, 20, 20, 150)
		local text = color_white

		local width = 200
		local height = 100
		local xPos = (ScrW() / 2) - (width / 2)
		local yPos = ScrH() - 90 - height

		if (data.strafe) then 
			sync = data.sync or sync
			return
		end

		local theme = Momentum
		local box = Color(0, 0, 0, 100)
		local tc = color_white
		local tc2 = Color(0, 160, 200)
		local su = Color(0, 160, 200)
		local sd = Color(200, 0, 0)
		local start = false

		local current = data.current < 0 and 0 or data.current
		local time = cTime(current)

		local personal = data.pb 
		local personalf = ConvertTime(personal) .. data.recTp

		local status = "No Timer"

    	if not (LocalPlayer():Team() == TEAM_SPECTATOR) then 
		if current > 1.42 then
			draw.SimpleText("Sync", "HUDTimerMedThick", ScrW() / 2, yPos + height + 10, tc, TEXT_ALIGN_CENTER)
			draw.SimpleText(sync or 0, "HUDTimerKindaUltraBig", ScrW() / 2, yPos + height + 34, col, TEXT_ALIGN_CENTER)

		if (sync ~= 0) and (type(sync) == 'number') then 
			local col = sync > 93 and su or tc 
			col = sync < 90 and sd or col
			col = sync == 0 and color_white or col

			-- Sync bar thingy
			local barwidth = sync / 100 * (width + 10)
				surface.SetDrawColor(col)
				surface.DrawRect(xPos - 10, ScrH() - 24, barwidth, 16)
			end
				surface.SetDrawColor(Color(200, 0, 0))
			end
		end

		-- Current Vel
		local velocity = math.floor(pl:GetVelocity():Length2D())

		-- Strings
		local style = pl:GetNWInt("Style", 1)
		local stylename = Core:StyleName(style or 1) .. (pl:IsBot() and " Replay" or "")

		-- Personal best
		local personal = ConvertTime(data.pb or 0)

		-- Current Time
		local current = data.current < 0 and 0 or data.current
		local currentf = cTime(current)

		-- Jumps
		jumps = pl.player_jumps or 0

		-- Speedometer
		local speed = LocalPlayer():GetVelocity():Length2D()

		pl.speedcol = pl.speedcol or tc
		pl.current = pl.current or 0 
		local diff = speed - pl.current
		if pl.current == speed or speed == 0 then 
			pl.speedcol = tc
		elseif diff > -2 then 
			pl.speedcol = su
		elseif diff < -2 then
			pl.speedcol = sd
		end

		local width = 200
		local height = 100
		local xPos = (ScrW() / 2) - (width / 2)
		local yPos = ScrH() - height - 60

		-- Activity 
		local activity = current > 0 and 1 or 2
		activity = (pl:GetNWInt("inPractice", false) or (pl.TnF or pl.TbF)) and 3 or activity
		activity = (activity == 1 and (pl:IsBot() and 4 or 1) or activity)

		surface.SetDrawColor(Color(200, 0, 0))

		surface.SetDrawColor(box)
		surface.DrawRect(xPos, yPos - 30, width, height)

		local current = data.current < 0 and 0 or data.current
		local time = cTime(current)

		local personal = data.pb 
		local personalf = ConvertTime(personal) .. data.recTp

		local status = "No Timer"

		if current > 0.01 then
			status = time
		end

		if (pl.TnF or pl.TbF) then 
			status = cTime(current)

			if pl.TnF or pl.TbF then 
				draw.SimpleText("Map Completed", "HUDTimer", ScrW() / 2, yPos - 40, tc, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end 
		end

		draw.SimpleText(status, "HUDTimerKindaUltraBig", ScrW() / 2, yPos - 10, tc, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

		if current < 0.01 and not pl:GetNWInt("inPractice", true) and pl:GetMoveType() != MOVETYPE_NOCLIP then 
			draw.SimpleText("Start Zone", "HUDTimer", ScrW() / 2, yPos - 40, tc, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end

		if not pl:IsBot() and pl:GetNWInt("inPractice", true) then 
			draw.SimpleText("Practicing", "HUDTimer", ScrW() / 2, yPos - 40, tc, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end

		local wr, wrn
		if (not WorldRecords) or (not WorldRecords[style]) or (#WorldRecords[style] == 0) then 
			wr = "No time recorded"
			wrn = ""
		else 
			wr = ConvertTime(WorldRecords[pl:GetNWInt("Style", 1)][2])
			wrn = "(" .. WorldRecords[pl:GetNWInt("Style", 1)][1] .. ")"
		end

		local pbtext
		if (data.pb) == 0 then 
			pbtext = "No time recorded"
		else 
			pbtext = ConvertTime(data.pb or 0)
		end

		-- Top 
		draw.SimpleText("Map: " .. game.GetMap(), "HUDTimer", 10, 8, tc, TEXT_ALIGN_LEFT)
		draw.SimpleText("World Record: " .. wr .. " " .. wrn, "HUDTimer", 9, 28, tc)
		draw.SimpleText("Personal Best: " .. pbtext, "HUDTimer", 10, 48, tc)	

		local current = LocalPlayer():GetVelocity():Length2D()
		if not (LocalPlayer():Team() == TEAM_SPECTATOR) then 
		if (current == 0) then
					current = 0
				else
				if (current <= 33) then
					current = 30
				end 
			end
			local width = 200
			local height = 100
			local xPos = (ScrW() / 2) - (width / 2)
			local yPos = ScrH() - height - 60 - (LocalPlayer():Team() == TEAM_SPECTATOR and 50 or 0)
			if (CurTime() < (lastUp + 0.060)) then
				draw.SimpleText(string.Split(current, ".")[1], "HUDTimerKindaUltraBig", ScrW() / 2, yPos - 110, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			return end
		
		local maxVel = 80000000000000000000000000000000000000

		if (current > 0) then
				if (current >= maxVel) then
					color = Color(255, 174, 0)
				elseif (current > last + 1) then
					color = Color(0, 255, 255)
				elseif (current < last - 1) then
					color = Color(255, 0, 0)
				elseif (current == last) then
					color = color_white
			else
				color = color_white
			end
	
			lastUp = CurTime()
		else
			color = Color(255, 255, 255, 255)
		end

		last = current
		draw.SimpleText(string.Split(current, ".")[1], "HUDTimerKindaUltraBig", ScrW() / 2, yPos - 110, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
	
		-- In spec
		if LocalPlayer():Team() == TEAM_SPECTATOR then
			local ob = pl
			if IsValid( ob ) and ob:IsPlayer() then
				local nStyle = ob:GetNWInt( "Style", _C.Style.Normal )
				local szStyle = Core:StyleName( nStyle )

				if ob:IsBot() then
					draw.SimpleText("Status: Playing (1x)", "HUDTimer", ScrW() / 2, yPos + 48, text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				end

				local header, pla
				if ob:IsBot() then
					header = "Spectating"
					pla =  szStyle .. " Replay " .. "(" .. ob:GetNWString("BotName", "Loading...") .. ")"
				else
					header = "Spectating"
					pla = szStyle .. " (" .. ob:Name() .. ")"
				end

	  		 	 if (velocity == 0) then
		 			   	velocity = 0
	       			 else
	    				if (velocity <= 33) then
		  	 		 	velocity = 30
		  			  end 
	   			 end

       			 if last < velocity then
       			     coll = Color(0, 160, 200)
      			  end
       			 if last > velocity then
        		    coll = Color(255,0,0)
      			  end
       			 if last == velocity then
         		   if CurTime() > (lastUp + 0.5) then
          		      coll = Color(255, 255, 255)
         		       lastUp = CurTime()
         		   end
       			 end

				local width = 200
				local height = 100
				local xPos = (ScrW() / 2) - (width / 2)
				local yPos = ScrH() - height - 60 - (LocalPlayer():Team() == TEAM_SPECTATOR and 50 or 0)

      			last = current
       			draw.SimpleText(string.Split(velocity, ".")[1], "HUDTimerKindaUltraBig", ScrW() / 2, yPos - 110 + 50, coll, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				draw.SimpleText( header, "HUDHeaderBig", ScrW() / 2, 15, Color(25, 25, 25, 255), TEXT_ALIGN_CENTER )
				draw.SimpleText( header, "HUDHeaderBig", ScrW() / 2, 15, Color(0, 160, 200, 255), TEXT_ALIGN_CENTER )
				draw.SimpleText( pla, "HUDHeader", ScrW() / 2, 56, Color(25, 25, 25, 255), TEXT_ALIGN_CENTER )
				draw.SimpleText( pla, "HUDHeader", ScrW() / 2, 56, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER )
			end
		end
	end,

	-- Flow Network
	function(pl, data)
		-- Size
		local width = 230
		local height = 95

		-- Positions
		local xPos = data.pos[1] 
		local yPos = data.pos[2]

		-- Colours
		local BASE = Settings:GetValue("PrimaryCol")
		local INNER = Settings:GetValue("SecondaryCol")
		local TEXT = Settings:GetValue("TextCol")
		local BAR = Settings:GetValue("AccentCol")
		local OUTLINE = Color(0, 0, 0, 0)

		sync = data.sync or sync

		-- Strafe HUD?
		if (data.strafe) then 
			xPos = xPos + 5

			-- Height/Width is a bit different on this
			height = height + 35
			width = width

			-- Easy calculations
			local x, y, w, h = 0, 0, 0, 0

			-- Draw base 
			surface.SetDrawColor(BASE)
			surface.DrawRect(ScrW() - xPos - width, ScrH() - yPos - height, width + 5, height)

			-- Draw inners
			surface.SetDrawColor(INNER)
			surface.DrawRect(ScrW() - xPos + 5 - width, ScrH() - yPos - (height - 5), width - 5, 55)
			
			-- A
			x, y, w, h = ScrW() - xPos + 5 - width, ScrH() - yPos - (height - 65), (width / 2) - 5, 27
			surface.SetDrawColor(data.a and BAR or INNER)
			surface.DrawRect(x, y, w, h)
			draw.SimpleText("A", "HUDTimer", x + w/2, y + h/2, TEXT, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

			-- D
			x, y = ScrW() - xPos + 5 - width/2, ScrH() - yPos - (height - 65)
			surface.SetDrawColor(data.d and BAR or INNER)
			surface.DrawRect(x, y, w, h)
			draw.SimpleText("D", "HUDTimer", x + w/2, y + h/2, TEXT, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

			-- Left
			x, y = ScrW() - xPos + 5 - width, ScrH() - yPos - (height - 97)
			surface.SetDrawColor(data.l and BAR or INNER)
			surface.DrawRect(x, y, w, h)
			draw.SimpleText("Mouse Left", "HUDTimer", x + w/2, y + h/2, TEXT, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			
			-- Right
			x = ScrW() - xPos + 5 - width/2
			surface.SetDrawColor(data.r and BAR or INNER)
			surface.DrawRect(x, y, w, h)
			draw.SimpleText("Mouse Right", "HUDTimer", x + w/2, y + h/2, TEXT, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

			-- Extra Keys
			x, y = ScrW() - xPos + 15 - width, ScrH() - yPos - (height - 20)
			draw.SimpleText("Extras: ", "HUDTimer", x, y, TEXT, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

			-- Strafes
			draw.SimpleText("Strafes: " .. (data.strafes or 0), "HUDTimer", x, y + 23, TEXT, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

			x = ScrW() - xPos - 10
			draw.SimpleText("Duck", "HUDTimer", x, y, data.duck and BAR or TEXT, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
			draw.SimpleText("Jump", "HUDTimer", x - 42, y, data.jump and BAR or TEXT, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
			draw.SimpleText("S", "HUDTimer", x - 88, y, data.s and BAR or TEXT, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
			draw.SimpleText("W", "HUDTimer", x - 108, y, data.w and BAR or TEXT, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
			draw.SimpleText(("Sync: " .. sync .. "%"), "HUDTimer", x, y + 23, TEXT, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)

			-- Outlines
			surface.SetDrawColor(OUTLINE)
			surface.DrawOutlinedRect(ScrW() - xPos - width, ScrH() - yPos - height, width + 5, height)
			surface.DrawOutlinedRect(ScrW() - xPos + 5 - width, ScrH() - yPos - (height - 5), width - 5, 55)
			surface.DrawOutlinedRect(ScrW() - xPos + 5 - width, ScrH() - yPos - (height - 65), (width / 2) - 5, 27)
			surface.DrawOutlinedRect(ScrW() - xPos + 5 - width/2, ScrH() - yPos - (height - 65), (width / 2) - 5, 27)
			surface.DrawOutlinedRect(ScrW() - xPos + 5 - width, ScrH() - yPos - (height - 97), (width / 2) - 5, 27)
			surface.DrawOutlinedRect(ScrW() - xPos + 5 - width/2, ScrH() - yPos - (height - 97), (width / 2) - 5, 27)

			return 
		end

		-- In spec
		if LocalPlayer():Team() == TEAM_SPECTATOR then
			local ob = pl
			if IsValid( ob ) and ob:IsPlayer() then
				local nStyle = ob:GetNWInt( "Style", _C.Style.Normal )
				local szStyle = Core:StyleName( nStyle )
				
				local header, pla
				if ob:IsBot() then
					header = "Spectating Bot"
					pla =  ob:GetNWString("BotName", "Loading...") .. " (" .. szStyle .. " style)"
				else
					header = "Spectating"
					pla = ob:Name() .. " (" .. szStyle .. ")"
				end

				draw.SimpleText( header, "HUDHeaderBig", ScrW() / 2, ScrH() - 58 - 40, Color(25, 25, 25, 255), TEXT_ALIGN_CENTER )
				draw.SimpleText( header, "HUDHeaderBig", ScrW() / 2, ScrH() - 60 - 40, Color(214, 59, 43, 255), TEXT_ALIGN_CENTER )
				draw.SimpleText( pla, "HUDHeader", ScrW() / 2, ScrH() - 18 - 40, Color(25, 25, 25, 255), TEXT_ALIGN_CENTER )
				draw.SimpleText( pla, "HUDHeader", ScrW() / 2, ScrH() - 20 - 40, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER )
			end
		end

		-- Current Vel
		local velocity = math.floor(pl:GetVelocity():Length2D())

		-- Strings
		local time = "Time: "
		local pb = "PB: "

		-- Personal best
		local personal = data.pb 
		local personalf = ConvertTime(personal) .. data.recTp

		-- Current Time
		local current = data.current < 0 and 0 or data.current
		local currentf = ConvertTime(current) .. data.curTp

		-- Start Zone
		if pl:GetNWInt("inPractice", false) then 
			currentf = ""
			personalf = ""
			time = "Timer Disabled"
			pb = "Practice mode has no timer"
		elseif (current <= 0) and (not pl:IsBot()) then 
			currentf = ""
			personalf = ""
			time = "Timer Disabled"
			pb = "Leave the zone to start timer"
		end

		-- Draw base 
		surface.SetDrawColor(BASE)
		surface.DrawRect(xPos, ScrH() - yPos - 95, width, height)

		-- Draw inners
		surface.SetDrawColor(INNER)
		surface.DrawRect(xPos + 5, ScrH() - yPos - 90, width - 10, 55)
		surface.DrawRect(xPos + 5, ScrH() - yPos - 30, width - 10, 25)

		-- Bar
		local cp = math.Clamp(velocity, 0, 3500) / 3500
		surface.SetDrawColor(BAR)
		surface.DrawRect(xPos + 5, ScrH() - yPos - 30, cp * 220, 25)

		-- Text
		draw.SimpleText(time, "HUDTimer", (currentf != "" and xPos + 12 or xPos + width / 2), ScrH() - yPos - 75, TEXT, (currentf != "" and TEXT_ALIGN_LEFT or TEXT_ALIGN_CENTER), TEXT_ALIGN_CENTER)
		draw.SimpleText(pb, "HUDTimer", (currentf != "" and xPos + 13 or xPos + width / 2), ScrH() - yPos - 50, TEXT, (currentf != "" and TEXT_ALIGN_LEFT or TEXT_ALIGN_CENTER), TEXT_ALIGN_CENTER)
		draw.SimpleText(velocity .. " u/s", "HUDTimer", xPos + 115, ScrH() - yPos - 18, TEXT, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText(currentf, "HUDTimer", xPos + width - 12, ScrH() - yPos - 75, TEXT, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
		draw.SimpleText(personalf, "HUDTimer", xPos + width - 12, ScrH() - yPos - 50, TEXT, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)

		-- Draw Outlines
		surface.SetDrawColor(OUTLINE)
		surface.DrawOutlinedRect(xPos, ScrH() - yPos - 95, width, height)
		surface.DrawOutlinedRect(xPos + 5, ScrH() - yPos - 90, width - 10, 55)
		surface.DrawOutlinedRect(xPos + 5, ScrH() - yPos - 30, width - 10, 25)
	end
}

-- Capture data for ssj 
local JHudStatistics = {0, 0, 0, 0}
local JHudAnnounced = 0
net.Receive("kawaii.secret", function(_, _)
	local jumps = net.ReadInt(16)
	local gain = net.ReadFloat()
	local speed = net.ReadInt(18)
	local jss = net.ReadFloat()

	JHudAnnounced = CurTime()
	JHudStatistics = {jumps, gain, speed, jss}
end)

surface.CreateFont( "JHUDMain", { size = 20, weight = 4000, font = "Trebuchet24" } )
surface.CreateFont( "JHUDMainBIG", { size = 48, weight = 4000, font = "Trebuchet24" } )
surface.CreateFont( "JHUDMainBIG2", { size = 28, weight = 4000, font = "Trebuchet24" } )

local secret = CreateClientConVar("kawaii_secret", 0, true)

-- SSJ hud
local fade = 0

local function SSJ_HUD()
	local jump, gain, speed, jss = unpack(JHudStatistics)

	local color = Color(235, 49, 46, 255)
	local color35 = Color(255, 255, 255)
	local color355 = Color(255, 255, 255)
	local color77 = Color(255, 255, 255)

     if (speed > 0) then
	   if (speed >= 277) then
	   	 color35 = Color(0, 160, 200)
	    else 
		  color35 = Color(255, 255, 255)
		end 
	 end

     if (gain > 0) then
	   if (gain >= 277) then
	   	 color35 = Color(0, 160, 200)
		end 
	 end

     if (JHudAnnounced + 2) < CurTime() then 
        fade = fade + 0.5
        color35.a = math.Clamp(color35.a - fade, 0, 255)
        color35.a = color35.a
     else
        fade = 0
     end

     if (JHudAnnounced + 2) < CurTime() then 
        fade = fade + 0.5
        color355.a = math.Clamp(color355.a - fade, 0, 255)
        color355.a = color355.a
     else
        fade = 0
     end

	 if (JHudAnnounced + 2) < CurTime() then 
        fade = fade + 2
        color77.a = math.Clamp(color77.a - fade, 0, 255)
        color77.a = color77.a
     else
        fade = 0
     end

	if (gain > 0) then
		if (gain >= 80) then
			color = Color(0, 160, 200, 255)
		elseif (gain > 70) and (gain <= 79.99) then
			color = Color(39, 255, 0, 255)
		elseif (gain > 60) and (gain <= 69.99) then
			color = Color(255, 191, 0, 255)
		else 
			color = Color(255, 0, 0, 255)
		end 
	end

	if (JHudAnnounced + 2) < CurTime() then 
		fade = fade + 0.5
		color.a = color.a - fade 
	else 
		fade = 0 
	end

	gain = math.Round(gain, 2) .. "%"

	-- justas Jump Hud Display
	if jump == 2 then 
		if gain == 0 then return end
		if speed == 0 then return end
		draw.SimpleText(math.Round(speed, 0) - math.Round(speed / 10 + 13) - 53, "JHUDMainBIG2", ScrW() / 2, (ScrH() / 2) - 140, color355, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	if jump <= 2 then 
	else 
		draw.SimpleText(math.Round(speed, 0) - math.Round(speed / 10 + 13), "JHUDMainBIG2", ScrW() / 2, (ScrH() / 2) - 140, color355, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	if jump <= 1 then 
		draw.SimpleText(math.Round(speed, 0), "JHUDMainBIG", ScrW() / 2, (ScrH() / 2) - 100, color355, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	else
		draw.SimpleText(math.Round(speed, 0), "JHUDMainBIG", ScrW() / 2, (ScrH() / 2) - 100, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	if jump <= 1 then 
	else
		if gain == 0 then return end
		if speed == 0 then return end
		draw.SimpleText(gain, "JHUDMainBIG2", ScrW() / 2, (ScrH() / 2) - 60, color355, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	JHUDOLD = {}
	JHUDOLD.Enabled = CreateClientConVar( "kawaii_jhudold", "0", true, false, "JHud Old Pos" )
	
	local JHUDOLD = JHUDOLD.Enabled:GetBool()
	if JHUDOLD then
		if gain == 0 then return end
		if speed == 0 then return end

		if kawaiihud == 4 then
			draw.SimpleText(math.Round(speed, 0), "JHUDMain", ScrW() / 2, (ScrH() / 2) + 291, color35, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		if jump <= 1 then 
			else 
				draw.SimpleText("(with " .. gain .. " gain)", "JHUDMain", ScrW() / 2, (ScrH() / 2) + 312, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
		end
	end

	local width = 200
	local height = 100

	local xPos = (ScrW() / 2) - (width / 2)
	local yPos = ScrH() - 90 - height
	local tc = color_white

	kawaiihud = GetConVarNumber("kawaii_hud")

	-- Simple JHud
	if kawaiihud == 1 then return end
	if kawaiihud == 2 then return end
	if kawaiihud == 5 then return end
	if kawaiihud == 4 then return end

	if kawaiihud == 3 and jump <= 0 then 
		if gain == 0 then return end
		if speed == 0 then return end
		draw.SimpleText("", "HUDTimer2", ScrW() / 2, yPos + 123, color77, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	else
		draw.SimpleText(math.Round(speed, 0) .. " (" .. sync .. "%, +" .. math.Round(speed / 10 + 13) .. ")", "HUDTimer2", ScrW() / 2, yPos + 123, color77, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

end

function HUD:Draw(style, client, data) 
	self.Themes[selected_hud:GetInt()](client, data)

	if secret:GetInt() == 1 then 
		SSJ_HUD()
	end
end