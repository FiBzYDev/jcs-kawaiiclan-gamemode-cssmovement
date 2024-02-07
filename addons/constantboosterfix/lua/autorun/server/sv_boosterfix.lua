Boosterfix = {

	UpdateMessage = "BoosterFix has been updated in 1.6.2 version",

	Hooks = { -- Associate a function to a hook
		SetupData = "PlayerSpawn",
		CheckOnGround = "FinishMove",
		Move = "FinishMove",
		CheckNoClip = "PlayerNoClip",
		Boosterfix = "FinishMove",
		AnalyseBoosters = "FinishMove",
		PrepareBoosters = "FinishMove",
		DisableBoosters = "AcceptInput",
		PrepareTPs = "InitPostEntity",
		PlayerTeleported = "AcceptInput",
	},

	TickRate = 1 / engine.TickInterval(), -- Cache the tickrate
	Boosters = Boosterfix and Boosterfix.Boosters or {}, -- Cache the boosters

	Initialize = function(self) -- Associate functions to hook and create a function to know if a player is allowed to use RNGFix
		local Hooks = self.Hooks
		setmetatable(self, {__index = _G})
		for name, func in pairs(Boosterfix) do
			if not isfunction(func) then continue end
			setfenv(func, self)
			if Hooks[name] then
				hook.Add(Hooks[name], "Boosterfix"..name, func)
			end
		end
		
		local Player = FindMetaTable("Player")
		
		Player.UseBoosterfix = function(ply, functionality)
			return ply.Boosterfix.Enabled
				and (not ply.Spectating)
				and (not ply.Boosterfix.NoClip)
				and not ply:IsBot()
		end

		for _, ply in pairs( player.GetAll() ) do
			self.SetupData(ply)
		end

		timer.Simple(0, function() -- Can be used to notify players about an update
--			Core:Broadcast( "Print", { "Général", self.UpdateMessage } )
		end)
		concommand.Add("update_rngfix", function(ply)
			if not ply:IsValid() then
				include("autorun/server/sv_boosterfix.lua")
			end
		end)
	end,

	AnalyseBoosters = function(ent, k, v) -- Analyse trigger_multiple outputs and store information when the output is used for a booster

		-- Remove Broken Booster Maps
		if game.GetMap() == "bhop_sj" then return end
		if game.GetMap() == "bhop_krsk_final" then return end
		if game.GetMap() == "bhop_theonlylevel" then return end
		if game.GetMap() == "bhop_effigy" then return end
		if game.GetMap() == "kz_bhop_badg3s" then return end
		if game.GetMap() == "kz_bhop_skyworld" then return end
		--if game.GetMap() == "bhop_asko" then return end
		if game.GetMap() == "bhop_orionsbelt_lj" then return end
		if game.GetMap() == "kz_bhop_sakura" then return end
		if game.GetMap() == "bhop_jegg_fix" then return end
		if game.GetMap() == "bhop_badges2" then return end
		if game.GetMap() == "kz_bhop_minimal" then return end
		if game.GetMap() == "kz_bhop_ascend_v2" then return end
		if game.GetMap() == "bhop_cluster_fix" then return end
		if game.GetMap() == "bhop_10aa" then return end
		if game.GetMap() == "bhop_sonder" then return end
		if game.GetMap() == "bhop_ecodus" then return end
		if game.GetMap() == "bhop_vandora" then return end
		if game.GetMap() == "bhop_amoebic_fix" then return end
		if game.GetMap() == "kz_bhop_affinity_gm" then return end
		if game.GetMap() == "bhop_suffer" then return end
		if game.GetMap() == "kz_bhop_north" then return end
		if game.GetMap() == "bhop_sinensis" then return end
		if game.GetMap() == "kz_bhop_industrial" then return end
		if game.GetMap() == "bhop_0003" then return end
		if game.GetMap() == "bhop_horseshit_12" then return end
		if game.GetMap() == "kz_11342" then return end
		if game.GetMap() == "kz_bhop_izanami" then return end
		if game.GetMap() == "bhop_bfur_retextured" then return end
		if game.GetMap() == "bhop_glaze" then return end
		if game.GetMap() == "bhop_yayaya_dump" then return end

		-- Not actually used yet
		if ent:GetClass() == "trigger_push" and k == "pushdir" then
			local pd = string.Explode(" ", v)
			ent.PushDir = Vector(pd[1], pd[2], pd[3])
		elseif ent:GetClass() == "trigger_push" and k == "speed" then
			ent.PushSpeed = tostring(v)
		end
		--

		if ent:GetClass() != "trigger_multiple" then return end
		if not (k == "OnStartTouch" or k == "OnEndTouch") then return end
		
		local a = "!activator,AddOutput,"
		if string.sub(v, 1, #a) != a then return end
		local b = string.Explode( ",", string.sub(v, #a + 1) )
		b[1] = string.Explode(" ", b[1])
		b = {
			Output = k,
			Change = b[1][1],
			Value = b[1][3] and Vector(b[1][2], b[1][3], b[1][4]) or b[1][2],
			Timer = tonumber(b[2])
		}
		if not (b.Change == "basevelocity" or b.Change == "gravity") then
			return
		end

		if not ent.Booster then ent.Booster = {} end
		local booster = ent.Booster
		booster[#booster + 1] = b
	end,

	PrepareBoosters = function() -- Store boosters in a table for a faster TraceHull
		for _, ent in pairs( ents.FindByClass("trigger_push") ) do
			-- print( tostring(ent)..": dir("..tostring(ent.PushDir).."), speed("..tostring(ent.PushSpeed)..")" )
			-- Can be used to log trigger_push values
		end
		for _, ent in pairs( ents.FindByClass("trigger_multiple") ) do
			local booster = ent.Booster
			-- PrintTable{[ent] = booster} -- Can be used to log boosters outputs
			if booster and #booster == 1 and booster[1].Change == "gravity" then
				ent.Booster = nil
			elseif booster then
				Boosters[#Boosters + 1] = ent
			end
		end
	end,

	PrepareTPs = function() -- Hook outputs to trigger_teleport so we can know when a player has been teleported
		for _, ent in pairs( ents.FindByClass("trigger_teleport") ) do
			ent:Fire("AddOutput", "OnStartTouch !activator:teleported:0:0:-1")
			ent:Fire("AddOutput", "OnEndTouch !activator:teleported:0:0:-1")
		end
	end,

	SetupData = function(ply) -- Setup data each time a player spawn
		local enabled
		if ply.Boosterfix then enabled = ply.Boosterfix.Enabled end
		ply.Boosterfix = {
			Enabled = (enabled == nil) and true or enabled,
			PreviousVL = {Vector()},
			PredictedVL = false,
			PreviousPos = Vector(),
			WasOnGround = true,
			Landing = false,
			Landed = false,
			Jumped = false,
			GroundTrace = {},
			InBooster = false,
			OnRamp = false,
			WasOnRamp = false,
			LastOnRamp = 0,
			NoClip = false,
			Teleported = false,
			NextGravity = false,
			NextVelocity = false,
		}
	end,

	CheckNoClip = function(ply, noclip) -- Just to know if a player enabled the noclip
  	  if ply.Practice then
  	      ply.Boosterfix.NoClip = noclip
  	  end
	end,

	DisableBoosters = function(ply, input, activator, caller, arg) -- Say 'shut up' to boosters outputs when RNGFix is enabled on a player
		if ply:IsValid() and ply:IsPlayer() and ply:UseBoosterfix() and caller.Booster then
			return true
		end
	end,

	PlayerTeleported = function(ply, input) -- Called when a player has been teleported
		-- Remove Broken Booster Maps
		if game.GetMap() == "bhop_sj" then return end
		if game.GetMap() == "bhop_krsk_final" then return end
		if game.GetMap() == "bhop_theonlylevel" then return end
		if game.GetMap() == "bhop_effigy" then return end
		if game.GetMap() == "kz_bhop_badg3s" then return end
		if game.GetMap() == "kz_bhop_skyworld" then return end
		--if game.GetMap() == "bhop_asko" then return end
		if game.GetMap() == "bhop_orionsbelt_lj" then return end
		if game.GetMap() == "kz_bhop_sakura" then return end
		if game.GetMap() == "bhop_jegg_fix" then return end
		if game.GetMap() == "bhop_badges2" then return end
		if game.GetMap() == "kz_bhop_minimal" then return end
		if game.GetMap() == "kz_bhop_ascend_v2" then return end
		if game.GetMap() == "bhop_cluster_fix" then return end
		if game.GetMap() == "bhop_10aa" then return end
		if game.GetMap() == "bhop_sonder" then return end
		if game.GetMap() == "bhop_ecodus" then return end
		if game.GetMap() == "bhop_vandora" then return end
		if game.GetMap() == "bhop_amoebic_fix" then return end
		if game.GetMap() == "kz_bhop_affinity_gm" then return end
		if game.GetMap() == "bhop_suffer" then return end
		if game.GetMap() == "kz_bhop_north" then return end
		if game.GetMap() == "bhop_sinensis" then return end
		if game.GetMap() == "kz_bhop_industrial" then return end
		if game.GetMap() == "bhop_0003" then return end
		if game.GetMap() == "bhop_horseshit_12" then return end
		if game.GetMap() == "kz_11342" then return end
		if game.GetMap() == "kz_bhop_izanami" then return end
		if game.GetMap() == "bhop_bfur_retextured" then return end
		if game.GetMap() == "bhop_glaze" then return end
		if game.GetMap() == "bhop_yayaya_dump" then return end

		if ply:IsValid() and ply:IsPlayer() and input == "teleported" then
			ply.Boosterfix.Teleported = true
		end
	end,

	Move = function(ply, mv) -- Whole RNGFix Move function to apply fixes in the correct order
		if not ply:UseBoosterfix() then return end
		local pBFix = ply.Boosterfix

		BoosterFix(ply, mv)

		pBFix.WasOnGround = ply:IsOnGround()
		pBFix.PreviousPos = mv:GetOrigin()

		local pVL = pBFix.PreviousVL
		local max = math.min(#pVL, 9)
		for i = 1, max do
			pVL[i + 1] = pVL[i]
		end
		pVL[1] = mv:GetVelocity()
	end,

	BoosterFix = function(ply, mv) -- Replace the whole booster triggers collision detection (taking filters into account) and apply the outputs at the exact right time

		-- Remove Broken Booster Maps
		if game.GetMap() == "bhop_sj" then return end
		if game.GetMap() == "bhop_krsk_final" then return end
		if game.GetMap() == "bhop_theonlylevel" then return end
		if game.GetMap() == "bhop_effigy" then return end
		if game.GetMap() == "kz_bhop_badg3s" then return end
		if game.GetMap() == "kz_bhop_skyworld" then return end
		--if game.GetMap() == "bhop_asko" then return end
		if game.GetMap() == "bhop_orionsbelt_lj" then return end
		if game.GetMap() == "kz_bhop_sakura" then return end
		if game.GetMap() == "bhop_jegg_fix" then return end
		if game.GetMap() == "bhop_badges2" then return end
		if game.GetMap() == "kz_bhop_minimal" then return end
		if game.GetMap() == "kz_bhop_ascend_v2" then return end
		if game.GetMap() == "bhop_cluster_fix" then return end
		if game.GetMap() == "bhop_10aa" then return end
		if game.GetMap() == "bhop_sonder" then return end
		if game.GetMap() == "bhop_ecodus" then return end
		if game.GetMap() == "bhop_vandora" then return end
		if game.GetMap() == "bhop_amoebic_fix" then return end
		if game.GetMap() == "kz_bhop_affinity_gm" then return end
		if game.GetMap() == "bhop_suffer" then return end
		if game.GetMap() == "kz_bhop_north" then return end
		if game.GetMap() == "bhop_sinensis" then return end
		if game.GetMap() == "kz_bhop_industrial" then return end
		if game.GetMap() == "bhop_0003" then return end
		if game.GetMap() == "bhop_horseshit_12" then return end
		if game.GetMap() == "kz_11342" then return end
		if game.GetMap() == "kz_bhop_izanami" then return end
		if game.GetMap() == "bhop_bfur_retextured" then return end
		if game.GetMap() == "bhop_glaze" then return end
		if game.GetMap() == "bhop_yayaya_dump" then return end

		local pBFix = ply.Boosterfix

		if pBFix.NextGravity then
			local nGravity = pBFix.NextGravity
			nGravity[1] = nGravity[1] - 1
			if nGravity[1] == 0 then
				ply:SetGravity(nGravity[2])
				pBFix.NextGravity = false
			end
		elseif pBFix.NextVelocity then
			local vl = mv:GetVelocity() + pBFix.NextVelocity
			mv:SetVelocity(vl)
			pBFix.NextVelocity = false
		end

		for _, ent in pairs(Boosters) do ent:SetNotSolid(false) end

		local pos = mv:GetOrigin()
		local vl = mv:GetVelocity()
		pos.z = pos.z + (FrameTime() * vl.z)

		local tr = util.TraceHull {
			start = pos,
			endpos = pos,
			mins = ply:OBBMins(),
			maxs = ply:OBBMaxs(),
			mask = MASK_ALL,
			filter = player.GetAll(),
			ignoreworld = true,
		}
		
		local ent = tr.Entity
		if not (ent and ent:IsValid() and ent.Booster) then
			ent = false
			tr.Entity = false
		end
		local cOutput
		if ent and not pBFix.InBooster then
			cOutput = "OnStartTouch"
		elseif pBFix.InBooster and not ent then
			ent = pBFix.InBooster
			cOutput = "OnEndTouch"
		end

		local passesFilter
		if ent and cOutput then
			local filter = ent:GetKeyValues().filtername
			if filter and filter != "" then 
				filter = ents.FindByName(filter)[1]
				passesFilter = (not filter) or filter:PassesFilter(ent, ply)
			else
				passesFilter = true
			end
		end 

		if ent and passesFilter then
			for _, b in pairs(ent.Booster) do
				if cOutput != b.Output then continue end
				if b.Change == "basevelocity" and b.Output == "OnEndTouch" then
					local vl = mv:GetVelocity() + b.Value
					mv:SetVelocity(vl)
				elseif b.Change == "basevelocity" then
					pBFix.NextVelocity = b.Value
				elseif b.Change == "gravity" then
					local v = b.Value
					if v == 1 and ply.Style == _C.Style["Low Gravity"] then v = 0.75 end
					if b.Timer > 0 then
						pBFix.NextGravity = {math.floor(b.Timer * TickRate), b.Value}
					else
						ply:SetGravity(b.Value)
					end
				end
			end
		end

		pBFix.InBooster = tr.Entity
		for _, ent in pairs(Boosters) do ent:SetNotSolid(true) end
	end,
	-- Yes it's stupidly long and monolithic but I don't give a **** because it's one of the best boosterfix made so far

}

Boosterfix:Initialize()