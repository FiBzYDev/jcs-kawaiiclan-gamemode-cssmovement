local lp, ut, ct, mm, Iv, GetVec, MainMask = LocalPlayer, util.TraceLine, CurTime, math.min, IsValid, Vector, MASK_PLAYERSOLID
local DuckSet = Core.GetDuckSet()
local TraceData, ActiveTrace, ViewOffset, ViewOffsetDuck, ViewTwitch = {}, {}, {}, {}

local HullDuck = _C["Player"].HullDuck
local HullStand = _C["Player"].HullStand
local ViewDuck = _C["Player"].ViewDuck
local ViewStand = _C["Player"].ViewStand
local ViewDiff = _C["Player"].ViewOffset
local ViewBase = _C["Player"].ViewBase

local function ExecuteTrace( ply )
	local crouched = ply:Crouching()
	local maxs = crouched and HullDuck or HullStand
	local view = crouched and ViewDuck or ViewStand
	
	local s = ply:GetPos()
	s.z = s.z + maxs.z
	
	TraceData[ ply ].start = s
	
	local e = GetVec( s.x, s.y, s.z )
	e.z = e.z + (12 - maxs.z)
	e.z = e.z + view.z
	TraceData[ ply ].endpos = e
	
	local fraction = ut( TraceData[ ply ] ).Fraction
	if fraction < 1 then
		local est = s.z + fraction * (e.z - s.z) - ply:GetPos().z - 12
		if not crouched then
			local offset = ply:GetViewOffset()
			offset.z = est
			return offset, nil
		else
			local offset = ply:GetViewOffsetDucked()
			offset.z = mm( offset.z, est )
			return nil, offset
		end
	else
		return nil, nil
	end
end

local function InstallView( ply )
	if not Iv( ply ) then return end

	if ActiveTrace[ ply ] then
		local n, d = ExecuteTrace( ply )
		if n != nil or d != nil then
			ViewOffset[ ply ] = n
			ViewOffsetDuck[ ply ] = d
		else
			ActiveTrace[ ply ] = nil
			ViewOffset[ ply ] = nil
			ViewOffsetDuck[ ply ] = nil
		end
	end
	
	ply:SetViewOffset( (ViewOffset[ ply ] or ViewStand) + ViewDiff )
	
	if ViewTwitch then
		ply:SetViewOffsetDucked( ViewOffsetDuck[ ply ] or ViewDuck )
	else
		ply:SetViewOffsetDucked( (ViewOffsetDuck[ ply ] or ViewDuck) + (ViewBase or ViewDiff) )
	end
end
hook.Add( "Move", "InstallView", InstallView )

local function ExecuteTraces()
	local ply = lp()
	if not Iv( ply ) then return end
	
	if not TraceData[ ply ] then TraceData[ ply ] = { filter = ply, mask = MainMask } end
	if ActiveTrace[ ply ] then return end
	
	local n, d = ExecuteTrace( ply )
	if n != nil or d != nil then
		ActiveTrace[ ply ] = true
		ViewOffset[ ply ] = n
		ViewOffsetDuck[ ply ] = d
	else
		ViewOffset[ ply ] = nil
		ViewOffsetDuck[ ply ] = nil
	end
end
timer.Create( "TracePlayerViews", 0.000001, 0, ExecuteTraces )

function Core.UpdateClientViews()
	HullStand = _C["Player"].HullStand
	ViewStand = _C["Player"].ViewStand
	ViewDiff = _C["Player"].ViewOffset
end