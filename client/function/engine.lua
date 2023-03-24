EngineEfficiency = function(vehicle,stats,tune,turboTorque)
	local rpm = GetVehicleCurrentRpm(vehicle)
	local nitro = Entity(vehicle).state.nitroenable
	local boost = turboTorque or 1.0
	if nitro and turboTorque == 1.0 then boost = 1.0 end
	local ignition_timing = tune.fInitialDriveForce or 1.0
	local fueltable = tune.fDriveInertia or 1.0
	local finalstats = {}
	for k,v in pairs(config.enginestat_default) do
		finalstats[k] = v
	end
	for k,v in pairs(stats) do
		if k == 'duration' then
			finalstats['compression'] -= v
		elseif k == 'fuelpressure' then
			finalstats[k] += v * rpm
			boost -= (v * 0.1)
		elseif k == 'ignition' then
			finalstats[k] += v * rpm
		else
			finalstats[k] += v
		end
	end
	finalstats.ignition *= 1.0 + ((ignition_timing - 1.0) * rpm)
	finalstats.fuelpressure *= 1.0 + ((fueltable - 1.0) * rpm)
	local fuel = (finalstats.fuelpressure / 100) 
	local ignition = (finalstats.ignition / 100) 
	local turbopower = (boost > 1.0 and boost - 1.0 or 1.0)
	local compression = ((finalstats.compression / 100)) * ignition
	local combustion_chamber = compression * ( ignition / fuel )
	local Fuel_Air_Volume = (ignition > fuel and (13.5 * ignition) * combustion_chamber or ((13.5 / fuel) * ignition) * combustion_chamber)
	local maxafr = ((Fuel_Air_Volume) + ((boost) > 1.0 and (boost * compression) or 0.0) * combustion_chamber) + (boost > 1.0 and boost or 0.0)
	local total = 1.0 * (maxafr > 13.5 and (13.5 / maxafr) or (maxafr / 13.5))

	local totalpower = total > 1.0 and 1.0 or total
	local effective_power = (totalpower < 1.0 and totalpower or totalpower) * combustion_chamber
	return totalpower, Fuel_Air_Volume, maxafr
end

HandleEngineDegration = function(vehicle,state,plate)
	if config.sandboxmode then return end
	local ent = state
	local statehandling = ent.defaulthandling
	local plate = plate
	while not statehandling do Wait(100) end
	local handlings = statehandling
	local handlings2 = statehandling
	local turbo = ent.turbo?.turbo
	local turbodeduct = 1.0
	if turbo then
		turbodeduct = turbo == 'Street' and 1.05 or turbo == 'Sports' and 1.15 or turbo == 'Racing' and 1.25 or turbo == 'Ultimate' and 1.3
	end
	local rpm = 1.0 + (GetVehicleCurrentRpm(vehicle) * 0.2)
	upgrade, stats = GetEngineUpgrades(vehicle) -- get current upgraded parts
	tune = GetTuningData(plate) -- get current tuned data
	local gear = GetVehicleCurrentGear(vehicle)
	if not handlings then return end
	for k,v in ipairs(config.engineparts) do
		for k,name in pairs(v.handling) do
			if handlings[name] then
				local currentdegrade = ent[v.item] or 100
				local degrade = v.maxdegrade
				local deduct = (((degrade - (degrade * (currentdegrade / 100))) * turbodeduct) * rpm)
				if name == 'nInitialDriveGears' then
					local gears = round(handlings2[name] * (upgrade[name] or 1.0))
					local maxgears = gears > 9 and 9 or gears
					SetVehicleHandlingInt(vehicle, 'CHandlingData', name, maxgears)
					SetVehicleHighGear(vehicle,maxgears)
					nInitialDriveGears = maxgears
				elseif name ~= 'nInitialDriveGears' then
					handlings[name] -= (handlings2[name] * deduct)
					local newval = (handlings[name] * (upgrade[name] or 1.0)) * (tune[name] or 1.0) * efficiency
					local upgradevalue = handlings[name] == 0.0 and (((handlings[name] + 1.0) * (upgrade[name] or 1.0) * (tune[name] or 1.0) - 1.0) * efficiency) or newval
					if name == 'fInitialDriveMaxFlatVel' then
						upgradevalue = (handlings[name] * (upgrade[name] or 1.0)) * (tune[name] or 1.0)
						fInitialDriveMaxFlatVel = upgradevalue
						SetEntityMaxSpeed(vehicle,(upgradevalue * 1.3) / 3.6)
						SetVehicleMaxSpeed(vehicle,0.0)
						SetVehicleHandlingField(vehicle, 'CHandlingData', name, upgradevalue)
					else
						SetVehicleHandlingField(vehicle, 'CHandlingData', name, upgradevalue)
					end
					if name == 'fDriveInertia' then
						fDriveInertia = upgradevalue
					end
					if name == 'fInitialDriveForce' then
						fInitialDriveForce = upgradevalue
					end
				end
			end
		end
	end
	ModifyVehicleTopSpeed(vehicle,1.0)
	SetVehicleEnginePowerMultiplier(vehicle, 1.0) -- do not remove this, its a trick for flatvel
	SetVehicleCheatPowerIncrease(vehicle,1.0)
	HandleTires(vehicle,plate,handlings,ent)
	localhandling = handlings
end

GetEngineUpgrades = function(vehicle, name)
	local upgrades = {}
	local stats = {}
	local ent = Entity(vehicle).state
	for k,v in pairs(config.engineupgrades) do
		for k,name in pairs(v.handling) do
			if not upgrades[name] then upgrades[name] = 1.0 end
			if ent[v.item] then
				for k,v in pairs(v.stat or {}) do
					if not stats[k] then stats[k] = 0.0 end
					stats[k] += v
				end
				upgrades[name] = upgrades[name] * (not config.tunableonly[name] and v.add or 1.0)
			end
		end
	end
	return upgrades,stats
end

GetTuningData = function(plate)
	local tunes = ecu
	local data = {
		['fInitialDriveMaxFlatVel'] = 1.0,
		['fDriveInertia'] = 1.0,
		['fInitialDriveForce'] = 1.0,
		['fClutchChangeRateScaleUpShift'] = 1.0,
		['fClutchChangeRateScaleDownShift'] = 1.0,

	}
	if tunes and tunes[plate] then
		for k,v in pairs(tunes[plate]?.active or {}) do
			if k == 'topspeed' then
				data['fInitialDriveMaxFlatVel'] = v
			end
			if k == 'engineresponse' then
				data['fDriveInertia'] = v
			end
			if k == 'acceleration' then
				data['fInitialDriveForce'] = v
			end
			if k == 'gear_response' then
				data['fClutchChangeRateScaleUpShift'] = v
				data['fClutchChangeRateScaleDownShift'] = v
			end
		end
	end
	return data
end

RetrieveOldEngine = function(vehicle,engine)
	local ent = Entity(vehicle).state
	local engines = exports.renzu_engine:Engines().Locals
	local custom_engine = exports.renzu_engine:Engines().Custom
	for k,v in pairs(custom_engine) do
		v.model = v.soundname
		v.name = v.label
		engines[k] = v
	end
	local plate = string.gsub(GetVehicleNumberPlateText(vehicle), '^%s*(.-)%s*$', '%1'):upper()
	local model = ent.currentengine ~= 'default' and ent.currentengine or GetEntityModel(vehicle)
	local label = 'Engine'
	for k,v in pairs(engines) do
		if ent.currentengine == 'default' and joaat(v.model) == model or ent.currentengine ~= 'default' and v.model == model then
			model = v.model
			label = v.name
			break
		end
	end
	lib.callback.await('renzu_tuners:OldEngine',false,label,model,plate,NetworkGetNetworkIdFromEntity(vehicle))
	ent:set('currentengine',engine,true)
end

RegisterNetEvent('renzu_engine:OnEngineChange', function(engine) -- repair current parts when installing new engines
	local vehicle = GetClosestVehicle(GetEntityCoords(cache.ped), 10.0)
	local ent = Entity(vehicle).state
    for k,v in pairs(config.engineparts) do
		ent:set(v.item, 99.97, true)
	end
end)