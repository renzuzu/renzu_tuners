RegisterCommand('repair', function() -- repair command
	if HasAccess() then
		Repair()
	end
end)

RegisterCommand('upgrades', function() -- upgrade package command
	if HasAccess() then
		UpgradePackage()
	end
end)

RegisterCommand('checkvehicle', function(src,args) -- check current vehicle status, can upgrade if job is met.
	return CheckVehicle(HasAccess())
end)

if config.debug then
	RegisterCommand('setmileage', function(src,args) -- /setmileage 5000 ( set current vehicle mileage to 5000)
		if not args[1] then return end
		local vehicle = GetVehiclePedIsIn(cache.ped)
		local ent = Entity(vehicle).state
		ent:set('mileage', tonumber(args[1]), true)
		print(ent.mileage)
	end)

	RegisterCommand('setfuel', function(src,args) -- /setfuel 100 (only works in ox_fuel)
		if not args[1] then return end
		local vehicle = GetVehiclePedIsIn(cache.ped)
		local ent = Entity(vehicle).state
		ent:set('fuel', tonumber(args[1]), true)
		print(ent.fuel)
	end)

	RegisterCommand('sethandling', function(src,args) -- /sethandling 100 ( set current vehicle all handling status to 100)
		if not args[1] then return end
		local vehicle = GetVehiclePedIsIn(cache.ped)
		local ent = Entity(vehicle).state
		for k,v in ipairs(config.engineparts) do
			ent:set(v.item, tonumber(args[1]), true)
			print('new value for '..v.item..' '..args[1])
		end
	end)
end

RegisterCommand('manualgear', function() -- set manual gearings
	local vehicle = GetVehiclePedIsIn(cache.ped)
	SetVehicleManualGears(vehicle)
end)

RegisterCommand('autogear', function(src,args) -- args[1] is eco (string). if eco vehicle will be shift earlier and will have a speed limit on maxgear
	local vehicle = GetVehiclePedIsIn(cache.ped)
	SetVehicleManualGears(vehicle,false,true,args[1] and true)
end)

RegisterCommand('tuning', function() -- tuning menu command
	return TuningMenu()
end)