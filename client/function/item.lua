GetItemMod = function(name)
	for k,v in pairs(config.engineupgrades) do
		if v.item == name and v.mod then
			return v.mod
		end
	end
	return false
end

ItemFunction = function(vehicle,data,menu) -- item use handler
	if not vehicle then vehicle = GetClosestVehicle(GetEntityCoords(cache.ped), 10.0) end
	if menu then
		lib.progressCircle({
			duration = 2000,
			position = 'bottom',
			useWhileDead = false,
			canCancel = false,
			disable = {
				car = true,
				move = true,
			},
			anim = {
				dict = 'mini@repair',
				clip = 'fixing_a_player'
			},
		})
	end
	SetEntityControlable(vehicle)
	local item = data.name
	if config.metadata then
		item = data.metadata?.upgrade or data.name
	end
	local ent = Entity(vehicle).state
	local state, upgrade = GetItemState(item)
	local tires = GetTires(item)
	local drivetrain = GetDriveTrain(item)
	local extras = GetExtras(item)
	local isturbo = isTurbo(item)
	local isnitro = isNitro(item)
	local ECU = item == 'ecu'
	-- tires
	if tires then

		local tires_index = {}
		for i = 1 , GetVehicleNumberOfWheels(vehicle) do
			tires_index[i] = 100.0
		end
		ent:set('tires', {type = tires, tirehealth = tires_index}, true)
	elseif drivetrain then
		ent:set('drivetrain', drivetrain, true)
	elseif extras then
		SaveStateFlags(vehicle,ent,extras)
	elseif isturbo then
		TriggerServerEvent('renzu_turbo:AddTurbo',NetworkGetNetworkIdFromEntity(vehicle),item)
	elseif isnitro then
		TriggerServerEvent('renzu_nitro:AddNitro',NetworkGetNetworkIdFromEntity(vehicle),item)
	elseif data.engine then
		TriggerServerEvent('renzu_engine:EngineSwap',NetworkGetNetworkIdFromEntity(vehicle),item)
	elseif ECU then
		local boostpergear = {}
		for i = 1, GetVehicleHighGear(vehicle) do
			boostpergear[i] = 1.0
		end
		lib.callback.await('renzu_tuners:Tune',false,{vehicle = NetworkGetNetworkIdFromEntity(vehicle) ,profile = 'Default', tune = {acceleration = 1.0, topspeed = 1.0, engineresponse = 1.0, gear_response = 1.0, boostpergear = boostpergear}})
		Wait(1000)
		local plate = string.gsub(GetVehicleNumberPlateText(vehicle), '^%s*(.-)%s*$', '%1'):upper()
		vehiclestats, vehicletires, mileages, ecu = lib.callback.await('renzu_tuners:vehiclestats', 0, plate)
	else
		local oldval = ent[state]
		ent:set(state,math.random(1,77),true)
		RemoveDuplicatePart(vehicle,state)
		if upgrade then
			ent:set(upgrade,false,true)
		end
		while Entity(vehicle).state[state] == oldval do Wait(1110) end
		Wait(1000)
		if upgrade then
			ent:set(upgrade,true,true)
		end
		if state == 'engine_oil' then
			ent:set('mileage', 0, true)
		end
		
		local getmod = GetItemMod(item)
		if getmod then
			SetVehicleModKit(vehicle,0)
			local current = GetVehicleMod(vehicle,getmod.index)
			SetVehicleMod(vehicle,getmod.index,current+getmod.add,false)
		end
		ent:set(state,100,true)
		plate = string.gsub(GetVehicleNumberPlateText(vehicle), '^%s*(.-)%s*$', '%1'):upper()
		HandleEngineDegration(vehicle,ent,plate)
	end
	lib.notify({description = 'You Install '..data.label})
end

GetItemState = function(name)
	local state = name
	local upgrade = nil
	for k,v in pairs(config.engineupgrades) do
		if v.item == name and v.state then
			state = v.state
			upgrade = v.item
		end
	end
	return state,upgrade
end