function GM:PlayerTraceAttack( ply, dmginfo, dir, trace )
	return false
end

function GM:PlayerFootstep( ply, vPos, iFoot, strSoundName, fVolume, pFilter )
	if ( IsValid( ply ) and !ply:Alive() ) then
		return true
	end
end

function GM:PlayerStepSoundTime( ply, iType, bWalking )

	local fStepTime = 350
	local fMaxSpeed = ply:GetMaxSpeed()

	if ( iType == STEPSOUNDTIME_NORMAL || iType == STEPSOUNDTIME_WATER_FOOT ) then

		if ( fMaxSpeed <= 100 ) then
			fStepTime = 400
		elseif ( fMaxSpeed <= 300 ) then
			fStepTime = 350
		else
			fStepTime = 250
		end

	elseif ( iType == STEPSOUNDTIME_ON_LADDER ) then

		fStepTime = 450

	elseif ( iType == STEPSOUNDTIME_WATER_KNEE ) then

		fStepTime = 600

	end

	-- Step slower if crouching
	if ( ply:Crouching() ) then
		fStepTime = fStepTime + 50
	end

	return fStepTime

end

function GM:PlayerSwitchWeapon( ply, oldwep, newwep )
	return false
end