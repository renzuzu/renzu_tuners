GetWheelHandling = function(vehicle)
	local handling = {}
	local ent = Entity(vehicle).state
	local label = {
		[1] = 'Front Left',
		[2] = 'Rear Left',
		[3] = 'Front Right',
		[4] = 'Rear Right',
		[5] = 'Rear',
		[6] = 'Rear',

	}
	for i = 1 , GetVehicleNumberOfWheels(vehicle) do
		handling[i] = {label = label[i], health = ent.tires?.tirehealth[i] or 100.0}
	end
	return handling
end

HandleTires = function(vehicle,plate,default,state)
	local ent = state
	local tires = {type = 'default'}
	if ent.tires and ent.tires.tirehealth then
		local typetype = ent.tires.type
		for k,tiredata in pairs(config.tires) do
			if typetype == tiredata.item then
				tires = {type = tiredata.item, handling = tiredata.handling}
			elseif typetype == 'default' then
				tires = {type = 'default', handling = {fLowSpeedTractionLossMult = 1.0,fTractionLossMult = 1.0,fTractionCurveMin = 1.0, fTractionCurveMax = 1.0, fTractionCurveLateral = 1.0}}
			end
		end
	else
		local tiresdata = vehicletires or {}
		if tiresdata[plate] and tiresdata[plate].tirehealth then
			ent:set('tires',tiresdata[plate],false)
		else
			local tirehealth = {}
			local ent = Entity(vehicle).state
			for i = 1 , GetVehicleNumberOfWheels(vehicle) do
				tirehealth[i] = 100.0
			end
			local tiresdata = {
				type = 'default',
				tirehealth = tirehealth
			}
			ent:set('tires',tiresdata,false)
			tires = {type = 'default'}
			Wait(1000)
		end
	end
	local tirehealth = vehicletires[plate] and vehicletires[plate].tirehealth or ent.tires?.tirehealth
	local total = 0
	local wheels = 0
	for i = 1 , GetVehicleNumberOfWheels(vehicle) do
		if tirehealth and math.random(1,100) < 50 then
			tirehealth[i] -= tires?.degrade or 0.1
		end
		if tirehealth then
		    total += tirehealth[i]
		end
		wheels += 1
	end
	gtirehealth = tirehealth
	tiresave += 1
	if tiresave > 60 then
		tiresave = 0
		ent:set('tires', {type = tires.type, tirehealth = gtirehealth}, true)
	end
	local current_tires = ent.tires and ent.tires.type and ent.tires.tirehealth
	if current_tires ~= nil and tires.handling and total > 0 and default and tires.type ~= 'drift_tires' then
		SetVehicleHandlingFloat(vehicle , "CHandlingData", "fLowSpeedTractionLossMult", (default.fLowSpeedTractionLossMult * tires.handling.fLowSpeedTractionLossMult + 0.0) * (total / (wheels * 100))) -- self.start burnout less = traction
		SetVehicleHandlingFloat(vehicle , "CHandlingData", "fTractionLossMult", (default.fTractionLossMult * tires.handling.fTractionLossMult + 0.0) * (total / (wheels * 100)))  -- asphalt mud less = traction
		SetVehicleHandlingFloat(vehicle , "CHandlingData", "fTractionCurveMin", (default.fTractionCurveMin * tires.handling.fTractionCurveMin + 0.0) * (total / (wheels * 100))) -- accelaration grip
		SetVehicleHandlingFloat(vehicle , "CHandlingData", "fTractionCurveMax", (default.fTractionCurveMax * tires.handling.fTractionCurveMax + 0.0) * (total / (wheels * 100))) -- cornering grip
		SetVehicleHandlingFloat(vehicle , "CHandlingData", "fTractionCurveLateral", (default.fTractionCurveLateral * tires.handling.fTractionCurveLateral + 0.0) * (total / (wheels * 100))) -- curve lateral grip
	elseif current_tires ~= nil and tires.handling and total > 0 and default and tires.type == 'drift_tires' then
		local Drift = function(handling)
			for index, value in ipairs(handling) do
				if value[1] == 'fInitialDriveMaxFlatVel' and vehicle ~= 0 then
					--SetVehicleHandlingField(currentveh, "CHandlingData", value[1], tonumber(value[2]))
				elseif value[1] == 'vecInertiaMultiplier' or value[1] == 'vecCentreOfMassOffset' and vehicle ~= 0 then
					SetVehicleHandlingVector(vehicle, "CHandlingData", value[1], tonumber(value[2]))
				elseif value[1] and vehicle ~= 0 then
					SetVehicleHandlingFloat(vehicle, "CHandlingData", value[1], tonumber(value[2]))
				end
				SetVehicleEnginePowerMultiplier(vehicle, 1.0) -- do not remove this, its a trick for flatvel
			end
			applyVehicleMods(vehicle ~= 0 and vehicle or GetVehiclePedIsIn(cache.ped),0.0)
		end
		if mode ~= 'DRIFT' then
			CreateThread(function()
				mode = 'DRIFT'
				while mode == 'DRIFT' and invehicle do
					Drift(config.drift_handlings)
					if angle(vehicle ) >= 5 and angle(vehicle ) <= 38 and GetEntityHeightAboveGround(vehicle ) <= 1.5 then
						SetVehicleHandlingField(vehicle, "CHandlingData", 'fInitialDriveMaxFlatVel', config.drift_handlings[1][2])
						SetVehicleEnginePowerMultiplier(vehicle, 1.0) -- do not remove this, its a trick for flatvel
						ForceVehicleGear (vehicle, GetVehicleCurrentGear(vehicle) > 1 and GetVehicleCurrentGear(vehicle) -1 or GetVehicleCurrentGear(vehicle))
						SetVehicleHighGear(vehicle,GetVehicleHighGear(vehicle))
					else
						SetVehicleHandlingField(vehicle, "CHandlingData", 'fInitialDriveMaxFlatVel', default['fInitialDriveMaxFlatVel'])
						SetVehicleEnginePowerMultiplier(vehicle, 1.0) -- do not remove this, its a trick for flatvel
					end
					Wait(100)
				end
				mode = 'NORMAL'
			end)
	    end
	end
end