UpgradePackage = function(data,shop,job)
	local options = {}
	local vehicle = GetClosestVehicle(GetEntityCoords(cache.ped), 10.0)
	if not DoesEntityExist(vehicle) then 
		lib.notify({
			description = 'No nearby vehicle', 
			type = 'error'
		})
		return 
	end
	local plate = string.gsub(GetVehicleNumberPlateText(vehicle), '^%s*(.-)%s*$', '%1'):upper()
	local hasmenu = job
	for k,enable in pairs(config.upgradevariation) do
		if enable then
			table.insert(options,{icon = 'box', label = k:gsub("^%l", string.upper)..' Package', description = 'Install Package of '..k, args = k})
		end
	end

	lib.registerMenu({
		id = 'upgradepackage',
		title = 'Upgrade Package',
		position = 'top-right',
		options = options,
	}, function(selected, scrollIndex, args)
		for k,v in pairs(config.engineupgrades) do
			if v.category == args:lower() then
				local hasitem = lib.callback.await('renzu_tuners:checkitem',false,v.item)
				if config.freeupgrade or hasitem then
					ItemFunction(vehicle,{
						name = v.item,
						label = v.label,
					},config.upgradepackageAnimation)
				else
					local required = config.purchasableUpgrade and 'money' or 'item'
					lib.notify({
						description = 'you dont have the '..required, 
						type = 'error'
					})
				end
			end
		end
		CheckVehicle(HasAccess() or type,shop)
	end)

	lib.showMenu('upgradepackage')
end

Options = function(data,shop,job)
	local options = {}
	local vehicle = GetClosestVehicle(GetEntityCoords(cache.ped), 10.0)
	local plate = string.gsub(GetVehicleNumberPlateText(vehicle), '^%s*(.-)%s*$', '%1'):upper()
	local hasmenu = job

	if data.tires then
		for k,v in pairs(config.tires) do
			local desc = 'Upgrade tires to '..v.label
			if config.purchasableUpgrade then
				desc = 'Cost: $ '..v.cost or 100000
			end
			table.insert(options,{icon = imagepath..''..v.item..'.png', label = v.label, description = desc, args = v.item, checked = v.item == data.type})
		end
	elseif data.drivetrain then
		for k,v in pairs(config.drivetrain) do
			local desc = 'Swap Drivetrain to '..v.label
			if config.purchasableUpgrade then
				desc = 'Cost: $ '..v.cost or 100000
			end
			table.insert(options,{icon = imagepath..''..v.item..'.png', label = v.label, description = desc, args = v.item, checked = v.label == data.type})
		end
	elseif data.extras then
		for k,v in pairs(config.extras) do
			local desc = 'Install '..v.label
			if config.purchasableUpgrade then
				desc = 'Cost: $ '..v.cost or 100000
			end
			table.insert(options,{icon = imagepath..''..v.item..'.png', label = v.label, description = desc, args = v.item})
		end
	elseif data.turbo then
		local turbos = turboconfig
		for k,v in pairs(turbos) do
			local desc = 'Install '..v.label
			if config.purchasableUpgrade then
				desc = v.cost and 'Cost: $ '..v.cost or 100000
			end
			table.insert(options,{icon = imagepath..''..v.item..'.png' , label = v.label, description = desc, colorScheme = 'blue', args = v.item})
		end
	elseif data.nitro then
		local nitros = exports.renzu_nitro:nitros()
		for k,v in pairs(nitros) do
			local desc = 'Install '..v.label..' nitro'
			if config.purchasableUpgrade then
				desc = v.cost and 'Cost: $ '..v.cost or 100000
			end
			table.insert(options,{icon = imagepath..''..v.item..'.png' , label = v.label, description = desc, colorScheme = 'blue', args = v.item})
		end
	elseif data.localengine then
		for k,v in pairs(data.value) do
			local desc = 'Install Engine '
			if config.purchasableUpgrade then
				desc = v.cost and 'Cost: $ '..v.cost or 100000
			end
			table.insert(options,{icon = imagepath..'engine.png' , label = v.name or 'engine', description = desc, colorScheme = 'blue', args = v.name})
		end
	elseif data.customengine then
		for k,v in pairs(data.value) do
			local desc = 'Install Engine '..v.label
			if config.purchasableUpgrade then
				desc = v.cost and 'Cost: $ '..v.cost or 100000
			end
			table.insert(options,{icon = imagepath..'engine.png' , label = v.label or 'engine', description = desc, colorScheme = 'blue', args = {engine = true, item = v.soundname}})
		end
	elseif job and not data.ecu and not data.mileage then
		if data.state == data.installed then 
			local desc = 'Repair '..data.label
			if config.purchasableUpgrade then
				desc = 25000
			end
			table.insert(options,{icon = imagepath..''..data.installed..'.png', label = 'Repair '..data.label, description = desc, args = {name = 'repairparts', part = data.installed}})
		else
			local desc = 'Replace '..data.label
			if config.purchasableUpgrade then
				desc = 25000
			end
			table.insert(options,{icon = imagepath..''..data.state..'.png', label = 'Install OEM ', description = desc, args = data.state})
		end
		for k,v in pairs(config.engineupgrades) do
			if config.upgradevariation[v.category] and data.part ~= v.item and v.state == data.state then
				local desc = v.item == data.installed and 'Repair '..v.label or 'Upgrade with '..v.label
				if config.purchasableUpgrade then
					desc = 'Cost: $ '..v.cost
				end
				table.insert(options,{icon = imagepath..''..v.state..'.png', label = v.item == data.installed and 'Repair '..v.label or 'Install to '..v.label, description = desc, args = v.item == data.installed and {name = 'repairparts', part = data.installed, state = v.state} or v.item})
			end
		end
	elseif job and not data.ecu then
		options = {
			{icon = imagepath..''..data.part..'.png', label = 'Change Oil', description = 'Restore to 0 Mileage', args = data.part},
		}
		hasmenu = true
	end
	if job and data.ecu then
		hasmenu = true
		local tune_profiles = ecu[plate] or {}
		if ecu[plate] then
			table.insert(options,{icon = imagepath..'engine.png' , label = 'New Profile', description = 'Create New Tuning Profile', colorScheme = 'blue', args = {tune = true, profile = 'new'}})
			for name,tuning in pairs(tune_profiles) do
				if name ~= 'active' then
					table.insert(options,{icon = imagepath..'engine.png' , label = name, description = 'Load Profile '..name, colorScheme = 'blue', args = {tune = true, profile = name, data = tuning}})
				end
			end
		else
			table.insert(options,{icon = imagepath..'engine.png' , label = ' Programable ECU', description = 'Install Programable ECU', colorScheme = 'blue', args = data.part})
		end
	end
	if hasmenu then
		local jobmoney = lib.callback.await('renzu_tuners:getJobMoney',false,PlayerData?.job?.name)
		lib.registerMenu({
			id = 'upgrade_options',
			title = config.purchasableUpgrade and config.jobmanagemoney and 'Job Money: '..jobmoney or 'Parts Options',
			position = 'top-right',

			onClose = function(keyPressed)
				CheckVehicle(job,shop)
			end,
			onCheck = function(selected, checked, args)
				lib.hideMenu()
				local item = selected == 2 and data.upgrade or data.part or args
				local hasitem = lib.callback.await('renzu_tuners:checkitem',false,item)
				if config.freeupgrade or hasitem then
					ItemFunction(vehicle,{
						name = item,
						label = data.label
					},true)
					CheckVehicle(HasAccess() or type,shop)
				else
					local required = config.purchasableUpgrade and 'money' or 'item'
					lib.notify({
						description = 'you dont have the '..required, 
						type = 'error'
					})
				end
			end,
			options = options,
		}, function(selected, scrollIndex, args)
			local engine = false
			local item = type(args) == 'string' and args or args.item
			if type(args) == 'table' and args.engine then
				engine = args.engine
			end
			if type(args) == 'table' and args.tune then
				if args.profile == 'new' then
					local hasturbo = Entity(vehicle).state.turbo
					local options = {
						{ type = "input", label = "Profile Name", placeholder = "ex. My Drag Tune" },
						{ type = "slider", label = "Ignition Timing", min = -0.5, max = 1.5 , step = 0.001, default = 1.0},
						{ type = "slider", label = "Fuel Table", min = -0.5, max = 1.5 , step = 0.001, default = 1.0},
						{ type = "slider", label = "Gear Response", min = -0.5, max = 1.5 , step = 0.01, default = 1.0},
						{ type = "slider", label = "Final Drive Gear", min = -0.5, max = 1.5 , step = 0.01, default = 1.0},
					}
					local totalgears = GetVehicleHighGear(vehicle)
					local maxgear = GetVehicleHighGear(vehicle)
					if hasturbo then
						for i = 1, totalgears do
							table.insert(options,{ type = "slider", label = "Gear "..i..' Boost', min = -0.5, max = 1.5 , step = 0.01, default = 1.0})
						end
					end
					for i = 1, totalgears do
						table.insert(options,{ type = "input", label = "Gear "..i..' Ratio', default = config.gears[maxgear][i]})
					end
					local input = lib.inputDialog('New Tuning Profile', options)
					local boostpergear = {}
					local gear_ratio = {}
					if hasturbo then
						for i = 6, #input do
							boostpergear[i-5] = input[i]
						end
						for i = 6+totalgears, #input do
							gear_ratio[i-(5+totalgears)] = tonumber(input[i])
						end
					else
						for i = 1, totalgears do
							boostpergear[i] = 1.0
						end
						for i = 6, #input do
							gear_ratio[i-5] = tonumber(input[i])
						end
					end
					if input and input[1] then
						lib.notify({
							description = 'Tune hasbeen applied and saved to '..input[1]..' Profile',   
							type = 'success'
						})
						lib.callback.await('renzu_tuners:Tune',false,{vehicle = NetworkGetNetworkIdFromEntity(vehicle) ,profile = input[1], tune = {acceleration = input[2], topspeed = input[5], engineresponse = input[3], gear_response = input[4], boostpergear = boostpergear, gear_ratio = gear_ratio}})
						Wait(200)
						HandleEngineDegration(vehicle,Entity(vehicle).state,plate)
						local plate = string.gsub(GetVehicleNumberPlateText(GetVehiclePedIsIn(cache.ped)), '^%s*(.-)%s*$', '%1'):upper()
						vehiclestats, vehicletires, mileages, ecu = lib.callback.await('renzu_tuners:vehiclestats', 0, plate)
					else
						lib.notify({
							description = 'Tune is not saved',   
							type = 'error'
						})
					end
				else
					local hasturbo = Entity(vehicle).state.turbo
					local options = {
						{ type = "slider", label = "Ignition Timing", min = -0.5, max = 1.5 , step = 0.001, default = args.data['acceleration']},
						{ type = "slider", label = "Fuel Table", min = -0.5, max = 1.5 , step = 0.001, default = args.data['engineresponse']},
						{ type = "slider", label = "Gear Response", min = -0.5, max = 1.5 , step = 0.01, default = args.data['gear_response']},
						{ type = "slider", label = "Final Drive Gear", min = -0.5, max = 1.5 , step = 0.01, default = args.data['topspeed']},
					}
					local totalgears = GetVehicleHighGear(vehicle)
					local maxgear = GetVehicleHighGear(vehicle)
					if hasturbo then
						for i = 1, totalgears do
							table.insert(options,{ type = "slider", label = "Gear "..i..' Boost', min = -0.5, max = 1.5 , step = 0.01, default = args.data['boostpergear'][i] or 1.0})
						end
					end
					for i = 1, totalgears do
						table.insert(options,{ type = "input", label = "Gear "..i..' Ratio', default = args.data['gear_ratio'][i] or config.gears[maxgear][i]})
					end
					local input = lib.inputDialog('Profile '..args.profile, options)
					local boostpergear = {}
					local gear_ratio = {}
					if hasturbo then
						for i = 5, #input do
							boostpergear[i-4] = input[i]
						end
						for i = 5+totalgears, #input do
							gear_ratio[i-(4+totalgears)] = tonumber(input[i])
						end
					else
						local boostpergear = {}
						for i = 1, totalgears do
							boostpergear[i] = 1.0
						end
						for i = 5, #input do
							gear_ratio[i-4] = tonumber(input[i])
						end
					end
					if input and input[1] then
						lib.notify({
							description = 'Tune has been applied and saved to '..args.profile..' Profile',   
							type = 'success'
						})
						lib.callback.await('renzu_tuners:Tune',false,{vehicle = NetworkGetNetworkIdFromEntity(vehicle) ,profile = args.profile, tune = {acceleration = input[1], topspeed = input[4], engineresponse = input[2], gear_response = input[3], boostpergear = boostpergear, gear_ratio = gear_ratio}})
						Wait(200)
						HandleEngineDegration(vehicle,Entity(vehicle).state,plate)
						local plate = string.gsub(GetVehicleNumberPlateText(GetVehiclePedIsIn(cache.ped)), '^%s*(.-)%s*$', '%1'):upper()
						vehiclestats, vehicletires, mileages, ecu = lib.callback.await('renzu_tuners:vehiclestats', 0, plate)
					else
						lib.notify({
							description = 'Tune is not saved',   
							type = 'error'
						})
					end
				end
			else
				local name = type(args) == 'string' and item or args.name
				local hasitem = false
				if name == 'repairparts' then
					local percent = {}
					local ent = Entity(vehicle).state
					local ismetadataSupport = ESX and GetResourceState('ox_inventory') == 'started' or QBCore or false
					if name == 'repairparts' and ismetadataSupport then
						percent = lib.inputDialog('Repair Engine Parts', {
							{type = 'slider', label = 'Repair Percent', description = 'Percentage of your target repair'},
						})
						if not percent then return end
					end
					local state = args.state or args.part
					local oldvalue = state and ent[state] or 50
					local percent = percent[1] or 100
					local success = lib.callback.await('renzu_tuners:RepairPart',false,percent,ismetadataSupport == false)
					if success == 'item' then return lib.notify({description = 'Failed to repair.  \n  You dont have a repair item', type = 'error'}) end
					if success then
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
						local durability = success or 0
						lib.notify({description = 'Repair Success.  \n  Repair kit Durability is '..durability, type = 'success'})
						local newvalue = (oldvalue + percent)
						ent:set(state,newvalue <= 100 and newvalue or 100,true)
						return CheckVehicle(HasAccess() or type,shop)
					else
						return lib.notify({description = 'Failed to repair.  \n  the current repair parts cannot repair this percentage', type = 'error'})
					end
				else
					hasitem = lib.callback.await('renzu_tuners:checkitem',false,item)
				end
				if config.freeupgrade or hasitem then
					Entity(vehicle).state:set(data.upgrade or '',false,true)
					ItemFunction(vehicle,{
						name = item,
						label = data.label,
						engine = data.localengine or data.customengine or false,
					},true)
					if not engine then
						CheckVehicle(HasAccess() or type,shop)
					end
				else
					local required = config.purchasableUpgrade and 'money' or 'item'
					lib.notify({
						description = 'you dont have the '..required, 
						type = 'error'
					})
				end
			end
		end)

		lib.showMenu('upgrade_options')
	end
end

local upgrades_data = {}
for k,v in pairs(config.engineupgrades) do
	upgrades_data[v.item] = v
end

CheckVehicle = function(menu,shop)
    local vehicle = GetClosestVehicle(GetEntityCoords(cache.ped), 10.0)
	if not DoesEntityExist(vehicle) then 
		lib.notify({
			description = 'No nearby vehicle', 
			type = 'error'
		})
		return 
	end
	local ent = Entity(vehicle).state
	while not ent.vehicle_loaded do Wait(11) end
	local plate = string.gsub(GetVehicleNumberPlateText(vehicle), '^%s*(.-)%s*$', '%1'):upper()
	local default_perf = GetEnginePerformance(vehicle,plate)
	HandleTires(vehicle,plate,default_perf,ent)
	local options = {}
	if not ent.mileage then
		ent:set('mileage',0, true)
	end
	table.insert(options,{icon = 'road', label = 'Mileage', description = ' Current Mileage of the vehicle engine', progress = 100 - (ent.mileage / 10000) * 100, colorScheme = 'blue',  args = {part = ent['racing_oil'] and 'racing_oil' or 'engine_oil', upgrade =  'racing_oil', mileage = Entity(vehicle).state.mileage, label = 'Mileage'}})
	local vehiclestat = vehiclestats[plate] or ent or {}
	if not DoesEntityExist(vehicle) then return end
	local unique = {}
	local upgrades = {}
	local racing = {}
	for k,v in pairs(config.engineupgrades) do
		if string.find(v.item,'racing') then
			racing[v.state] = v.item
		end
		if ent[v.item] and not unique[v.state] then
			unique[v.state] = true
			upgrades[v.item] = true
			local parts = upgrades_data[v.item].label
			local durability = ent[v.state] or 100
			table.insert(options,{icon = imagepath..''..v.state..'.png' , label = parts, description = parts..' Durability: '..durability, progress = durability, colorScheme = 'blue', args = {installed = v.item, state = v.state, label = v.label}})
		end
	end
	for k,v in pairs(config.engineparts) do
		if not unique[v.item] then
			if not ent[v.item] then
				ent:set(v.item, tonumber(vehiclestat[v.item]) or 100, true)
			end
			local durability = ent[v.item] or 100
			table.insert(options,{icon = imagepath..''..v.item..'.png' , label = v.label, description = v.label..' Durability: '..durability..'%', progress = durability, colorScheme = 'blue', args = {installed = v.item, state = v.item, label = v.label}})
		end
	end
	if menu then
		local drivetrain = 	ent.drivetrain or GetVehicleHandlingFloat(vehicle , "CHandlingData", "fDriveBiasFront")
		local drivetraintype = nil
		if drivetrain == 0.0 then
			drivetraintype = 'RWD'
		elseif drivetrain == 1.0 then
			drivetraintype = 'FWD'
		else
			drivetraintype = 'AWD'
		end

		local tiretype = ent.tires and ent.tires?.type or 'Default'
		if GetResourceState('renzu_turbo') == 'started' then
			local turbo = ent['turbo'] and ent['turbo'].turbo or 'Not Installed'
			table.insert(options,{icon = imagepath..'turbostreet.png' ,  label = 'Forced Induction ('..turbo..')', description = ' Installed Custom Turbine', progress = ent['turbo'] and ent['turbo'].durability or 100, colorScheme = 'blue',  args = {turbo = true, label = 'Forced Induction', value = {'turbostreet','turbosports','turboracing','turboultimate'}}})
		end
		if GetResourceState('renzu_nitro') == 'started' then
			table.insert(options,{icon = imagepath..'nitro50shot.png' , label = 'Nitros Oxide System', description = ' Installed Nitros', colorScheme = 'black',  args = {nitro = true, label = 'Nitro', value = {'nitro50shot','nitro100shot','nitro200shot'}}})
		end
		table.insert(options,{icon = imagepath..'street_tires.png' , label = 'Tires '..tiretype, description = ' Current Tires Health of the vehicle', progress = ent?.tires?.tirehealth[1] or 100, colorScheme = 'blue',  args = {tires = true, label = 'Tires', type = tiretype}})
		table.insert(options,{icon = imagepath..'oem_gearbox.png' , label = 'Drivetrain Type '..drivetraintype, description = ' Change Wheel Type', colorScheme = 'black',  args = {drivetrain = true, label = 'Drivetrain Type', type = drivetraintype}})
		table.insert(options,{icon = imagepath..'kers.png' , label = 'Advanced', description = ' Advanced Modification', colorScheme = 'black',  args = {extras = true, label = 'Advanced Modification', value = ent.extras}})
		if GetResourceState('renzu_engine') == 'started' then
			local engine = ent['engine'] or 'Default'
			table.insert(options,{icon = imagepath..'engine.png' , label = 'Engine (Locals) (current: '..engine..')', description = ' Installed Engines', colorScheme = 'black',  args = {localengine = true, label = 'Engine Swap', value = exports.renzu_engine:Engines().Locals}})
			table.insert(options,{icon = imagepath..'engine.png' , label = 'Engine (Customs) (current: '..engine..')', description = ' Installed Engines', colorScheme = 'black',  args = {customengine = true, label = 'Engine Swap', value = exports.renzu_engine:Engines().Custom}})
		end
	end
	table.insert(options,{icon = imagepath..'engine.png' , label = 'ECU', description = ' Tune ECU', colorScheme = 'black',  args = {part = 'ecu', ecu = true, label = 'Engine ECU', value = true}})

	lib.registerMenu({
		id = 'checkvehicle',
		title = menu and '🛠️ Upgrade Vehicle' or 'Engine Status',
		position = 'top-right',
		imageSize = 'large',
		onClose = function(keyPressed)
			if indyno then return end
			FreezeEntityPosition(GetVehiclePedIsIn(cache.ped),false)
		end,
		options = options
	}, function(selected, scrollIndex, args)
		Options(args,shop,menu)
	end)
	lib.showMenu('checkvehicle')
end

CheckPerformance = function()
    local vehicle = GetClosestVehicle(GetEntityCoords(cache.ped), 10.0)
	if not DoesEntityExist(vehicle) then 
		lib.notify({
			description = 'No nearby vehicle', 
			type = 'error'
		})
		return 
	end
	local ent = Entity(vehicle).state
	while not ent.vehicle_loaded do Wait(11) end
	local options = {}
	local plate = string.gsub(GetVehicleNumberPlateText(vehicle), '^%s*(.-)%s*$', '%1'):upper()
	local default_perf = GetEnginePerformance(vehicle,plate)
	HandleEngineDegration(vehicle,ent,plate)
	local unique = {}
	for k,v in pairs(GetAvailableHandlings()) do
		if localhandling[v.handling] and default_perf[v.handling] and not unique[v.affects] then
			local prog = (localhandling[v.handling] / default_perf[v.handling]+0.0) * 100.0
			unique[v.affects] = true
			table.insert(options, {icon = '' , label = v.affects, description = 'current performance of '..v.affects, progress = prog or 100, colorScheme = 'blue'})
		end
	end
	lib.registerMenu({
		id = 'engineperf',
		title = 'Engine Performance',
		position = 'bottom-right',
		options = options
	}, function(selected, scrollIndex, args)

	end)
	lib.showMenu('engineperf')
end

TuningMenu = function()
    local vehicle = GetClosestVehicle(GetEntityCoords(cache.ped), 10.0)
	if not DoesEntityExist(vehicle) then 
		lib.notify({
			description = 'No nearby vehicle', 
			type = 'error'
		})
		return 
	end
	local default = GetDefaultHandling(vehicle)
	local ent = Entity(vehicle).state
	local options = {}
	local plate = string.gsub(GetVehicleNumberPlateText(vehicle), '^%s*(.-)%s*$', '%1'):upper()
	local activeprofile = ecu[plate] and ecu[plate].active
	if not activeprofile and not config.sandboxmode then
		lib.notify({
			description = 'No Programable ECU Install', 
			type = 'error'
		}) 
		return 
	end
	HandleEngineDegration(vehicle,ent,plate)
	for k,v in ipairs(config.tuningmenu) do
		table.insert(options, {icon = v.icon , label = v.label, description = v.description, args = {handling = v.handlingname, label = v.label, type = v.type, min = v.min, max = v.max, attributes = v.attributes}})
	end
	local totalgears = GetVehicleHighGear(vehicle)
	local maxgear = GetVehicleHighGear(vehicle)
	lib.registerMenu({
		id = 'tuningmenu',
		title = 'Tuning System',
		position = 'bottom-right',
		options = options
	}, function(selected, scrollIndex, args)
		local options = {}
		local type = args.type
		local data = {}
		if not config.sandboxmode then
			if not activeprofile.gear_ratio then
				activeprofile.gear_ratio = config.gears[maxgear]
			end
			if not activeprofile.boostpergear then
				local boostpergear = {}
				for i = 1, totalgears do
					boostpergear[i] = 1.0
				end
				activeprofile.boostpergear = boostpergear
			end
			if not activeprofile.suspension then
				local suspension = {}
				for k,v in ipairs(config.tuningmenu[4].attributes) do
					suspension[v.label] = 1.0
				end
				activeprofile.suspension = suspension
			end
			if args.type == 'engine' then
				for k,v in ipairs(args.attributes) do
					table.insert(options, { type = v.type, label = v.label, min = v.min, max = v.max , step = v.step, default = activeprofile[v.name] or v.default})
				end
			elseif args.type == 'turbo' then
				for i = 1, totalgears do
					table.insert(options,{ type = "slider", label = "Gear "..i..' Boost', min = -0.5, max = 1.5 , step = 0.01, default = activeprofile.boostpergear[i] or 1.0})
				end
			elseif args.type == 'gearratio' then
				for i = 1, totalgears do
					table.insert(options,{ type = "input", label = "Gear "..i..' Ratio', default = activeprofile.gear_ratio[i]})
				end
			elseif args.type == 'suspension' then
				for k,v in ipairs(args.attributes) do
					table.insert(options, { type = v.type, label = v.label, min = v.min, max = v.max , step = v.step, default = activeprofile.suspension[v.label] or 1.0})
				end
			end
		else
			local HandlingGetter = function(type,handling,name)
				if type == 'number' then
					return GetVehicleHandlingInt(vehicle,handling,name)
				elseif type == 'input' then
					if name == 'fDriveInertia' and tuning_inertia == nil then
						tuning_inertia = ent.defaulthandling.fDriveInertia
					end
					return name == 'fDriveInertia' and tuning_inertia or GetVehicleHandlingFloat(vehicle,handling,name)
				else
					local vec = GetVehicleHandlingVector(vehicle,handling,name)
					return table.concat({vec.x,vec.y, vec.z},',')
				end
			end
			for k,v in ipairs(args.attributes) do
				table.insert(options, { type = v.type, label = v.label, description = v.description, default = HandlingGetter(v.type,args.handling,v.label)})
			end
		end
		local profile = activeprofile?.profile or 'SANDBOX MODE'
		local input = lib.inputDialog('Profile Name: '..profile, options)
		if not input then return end
		--json.encode(input or {}, {indent = true})
		if type == 'engine' then
			activeprofile.acceleration = input[1]
			activeprofile.topspeed = input[4]
			activeprofile.engineresponse = input[2]
			activeprofile.gear_response = input[3]
		elseif type == 'turbo' then
			for i = 1, totalgears do
				activeprofile.boostpergear[i] = input[i]
			end
		elseif type == 'gearratio' then
			for i = 1, totalgears do
				activeprofile.gear_ratio[i] = input[i]
			end
		elseif type == 'suspension' then
			local suspension = {}
			for i,v in ipairs(args.attributes) do
				suspension[v.label] = input[i]
			end
			activeprofile.suspension = suspension
		end
		if not config.sandboxmode then
			lib.callback.await('renzu_tuners:Tune',false,{vehicle = NetworkGetNetworkIdFromEntity(vehicle) ,profile = activeprofile.profile, tune = activeprofile})
		else
			for k,v in ipairs(args.attributes) do
				if v.type == 'number' then
					SetVehicleHandlingInt(vehicle,args.handling,v.label,tonumber(input[k]))
				elseif v.type == 'input' then
					if v.label == 'fDriveInertia' then
						tuning_inertia = tonumber(input[k])+0.0
					end
					SetVehicleHandlingFloat(vehicle,args.handling,v.label,tonumber(input[k])+0.0)
				else
					local x, y, z = input[k]:match("([^,]+),([^,]+),([^,]+)")
					SetVehicleHandlingVector(vehicle,args.handling,v.label,vec3(tonumber(x),tonumber(y),tonumber(z)))
				end
			end
			ModifyVehicleTopSpeed(vehicle,1.0)
			SetVehicleCheatPowerIncrease(vehicle,1.0)
		end
	end)
	lib.showMenu('tuningmenu')
end

CheckWheels = function()
    local vehicle = GetClosestVehicle(GetEntityCoords(cache.ped), 10.0)
	if not DoesEntityExist(vehicle) then 
		lib.notify({
			description = 'No nearby vehicle', 
			type = 'error'
		})
		return 
	end
	local ent = Entity(vehicle).state
	while not ent.vehicle_loaded do Wait(11) end
	local options = {}
	local plate = string.gsub(GetVehicleNumberPlateText(vehicle), '^%s*(.-)%s*$', '%1'):upper()
	local default_perf = GetEnginePerformance(vehicle,plate)
	HandleTires(vehicle,plate,default_perf,ent)
	for k,v in pairs(GetWheelHandling(vehicle)) do
		table.insert(options, {icon = '' , label = v.label, description = 'current health of '..v.label, progress = v.health or 100, colorScheme = 'blue'})
	end
	local wheeltype = ent.tires?.type or 'Default OEM'
	lib.registerMenu({
		id = 'wheelstatus',
		title = 'Wheel Status ('..wheeltype..')',
		position = 'bottom-right',
		options = options
	}, function(selected, scrollIndex, args)

	end)
	lib.showMenu('wheelstatus')
end

ContextMenuOptions = function(stash,entity,vehicle)
	Wait(1000)
	if GetResourceState('renzu_engine') ~= 'started' then return end
	if #(GetEntityCoords(vehicle) - GetEntityCoords(cache.ped)) > 3 then 
		lib.notify({type = 'error', description = 'You are not near to the vehicle'})
		return 
	end
	TaskTurnPedToFaceEntity(cache.ped,vehicle,5000)
	SetEntityNoCollisionEntity(entity,vehicle,true,false)
	local ent = Entity(vehicle).state
	local items = lib.callback.await('renzu_tuners:GetEngineStorage',false,stash)
	local options = {}
	for k,v in pairs(items) do
		local name = v.metadata?.label or 'Engine'
		local engine = v.metadata.engine
		local metadata = {}
		for k,v in pairs(v.metadata) do
			if type(v) == 'table' then
				table.insert(metadata,v.part..' - '..tostring(v.durability))
			end
		end
		table.insert(options,{
			title = 'Install '..name,
			icon = imagepath..'engine.png',
			description = 'Install this engine to nearby vehicle',
			metadata = metadata,
			arrow = true,
			onSelect = function()
				RetrieveOldEngine(vehicle,engine)
				TaskTurnPedToFaceEntity(cache.ped,vehicle,5000)
				Wait(2000)
				FreezeEntityPosition(cache.ped,true)
				local d21 = GetModelDimensions(GetEntityModel(entity))
				local stand = GetOffsetFromEntityInWorldCoords(entity, 0.0,d21.y+0.2,0.0)
				local z = 1.45
				lib.requestModel(`prop_car_engine_01`)
				enginemodel = CreateObject(`prop_car_engine_01`,stand.x+0.27,stand.y-0.2,stand.z+z,true,true,true)
				while not DoesEntityExist(enginemodel) do Wait(1) end
				SetEntityCompletelyDisableCollision(enginemodel,true,false)
				AttachEntityToEntity(enginemodel,entity ,0,0.0,-1.25,z,0.0,90.0,0.0,true,false,false,false,70,true)
				while z > 0.2 and DoesEntityExist(enginemodel) do
					Wait(1)
					z -= 0.003
					AttachEntityToEntity(enginemodel,entity ,0,0.0,-1.25,z,0.0,90.0,0.0,true,false,false,false,70,true)
				end
				lib.progressBar({
					duration = 8000,
					label = 'Installing Engine',
					useWhileDead = false,
					canCancel = true,
					disable = {
						car = true,
					},
					anim = {
						dict = 'mini@repair',
						clip = 'fixing_a_player'
					}
				})
				DeleteEntity(enginemodel)
				TriggerServerEvent('renzu_engine:EngineSwap',NetworkGetNetworkIdFromEntity(vehicle),engine)
				for k,v in pairs(v.metadata) do
					if type(v) == 'table' then
						local state = GetItemState(v.part)
						RemoveDuplicatePart(vehicle,state)
						ent:set(v.part,true,true)
						ent:set(state,v.durability,true)
					end
				end
				lib.callback.await('renzu_tuners:RemoveEngineStorage',false,{stash = stash, name = v.name, slot = v.slot, metadata = v.metadata})
				FreezeEntityPosition(cache.ped,false)
				lib.notify({type = 'success', description = 'Engine has been installed'})
			end
		})
	end
	lib.registerContext({
		id = 'engine_storage',
		title = 'Engine Lists',
		options = options
	})
	lib.showContext('engine_storage')
end

CraftOption = function(items,craft,label)
	local options = {}
	for k2,item in pairs(items) do
		local materials = {}
		table.insert(materials,'Requirements: ')
		local requires = {}
		local requiredata = {}
		local metadata = {}
		for item,amount in pairs(item.requires) do
			table.insert(materials,item..' x'..amount)
			local state = GetItemState(item)
			local material = config.metadata and state or item
			if config.metadata and state ~= item then
				metadata[material] = item
			end
			table.insert(requires,material)
			requiredata[material] = amount
		end
		local chance = item.chance or 100
		table.insert(materials,'Chances: '..chance..'%')
		table.insert(options,{
			title = item.label,
			metadata = materials,
			icon = craft == 'engine' and imagepath..'engine.png' or imagepath..''..item.name..'.png',
			description = 'Craft '..item.name,
			arrow = true,
			onSelect = function()
				local items = GetInventoryItems(requires)
				local hasitems = true
				local missingitems = ''
				local itemmulti = {}
				local slots = {}
				for item,data in pairs(items) do
					for k,v in pairs(data) do
						if not itemmulti[v.name] then itemmulti[v.name] = 0 end
						if config.metadata and v.metadata?.upgrade == metadata[v.name] then
							itemmulti[v.name] += v.count
							slots[v.name] = v
						elseif not config.metadata and not metadata[v.name] then
							itemmulti[v.name] += v.count
							slots[v.name] = v
						end
					end
				end
				for name,amount in pairs(requiredata) do
					if itemmulti[name] and itemmulti[name] < amount or not itemmulti[name] then
						hasitems = false
						missingitems = metadata[name] or name
					end
				end
				if hasitems then
					lib.progressCircle({
						duration = 5000,
						position = 'bottom',
						useWhileDead = false,
						canCancel = false,
						disable = {
							car = true,
						},
						anim = {
							dict = 'mini@repair',
							clip = 'fixing_a_player'
						}
					})
					local success = lib.callback.await('renzu_tuners:Craft',false,slots,requiredata,item,craft == 'engine' and item)
					if success then
						lib.notify({type = 'success', description = item.name.. ' Has been craft successfully'})
					else
						lib.notify({type = 'error', description = 'Crafting Failed'})
					end
				else
					lib.notify({type = 'error', description = 'missing items '..missingitems})
				end
			end,
		})
	end
	lib.registerContext({
		id = craft..'_menu',
		title = label,
		options = options
	})
	lib.showContext(craft..'_menu')
end