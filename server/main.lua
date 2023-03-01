local db = import('server/sql')
local vehiclestats = {}
local defaulthandling = {}
local controller = {}
local vehicleupgrades = {}
local vehicletires = {}
local mileages = {}
local drivetrain = {}
local advancedflags = {}
local ecu = {}
local currentengine = {}
local dyno_net = {}
local ramp = {}

SpawnDyno = function(index)
	local rampmodel = config.dynoprop
	for k,v in ipairs(config.dynopoints) do
		local object = CreateObjectNoOffset(rampmodel,v.platform.x,v.platform.y,v.platform.z-1.2,true,true)
		while not DoesEntityExist(object) do Wait(1) end
		Wait(500)
		SetEntityRoutingBucket(object,config.routingbucket)
		Wait(100)
		FreezeEntityPosition(object,true)
		SetEntityHeading(object,v.platform.w)
		dyno_net[k] = NetworkGetNetworkIdFromEntity(object)
		ramp[k] = object
		Wait(1000)
		Entity(object).state:set('ramp', {ts = os.time(), heading = v.platform.w}, true)
	end
end

lib.callback.register('renzu_tuners:CheckDyno', function(src,dynamometer,index)
	local dyno = NetworkGetEntityFromNetworkId(dyno_net[index])
	--if dynoInuse then return false end
	if not DoesEntityExist(dyno) or not dynamometer then
		SpawnDyno(index)
		Wait(2000)
		return true
	end
	return true
end)

-- send specific vehicle data to client. normaly i do check globalstate data in client. but somehow its acting weird on live enviroments and data is not getting sync if server has been up for too long, this is only a work around in state bag issue when data is large.
lib.callback.register('renzu_tuners:vehiclestats', function(src, plate) -- only the efficient way to send data to client. normaly people will just fetch sql every time player goes into vehicle. which is not performant.
	local stats = {[plate] = vehiclestats[plate] or {}}
	local tires = {[plate] = vehicletires[plate] or {}}
	local mileage = {[plate] = mileages[plate] or 0}
	local tune = {[plate] = ecu[plate]}
	return stats, tires, mileage, tune
end)

CreateThread(function()
    Wait(2000)
	SpawnDyno()
	local cache = db.fetchAll()
	local stats = {}
	for k,v in pairs(cache.vehiclestats or {}) do
		if string.find(k, 'ESX') ~= 1 or string.find(k,config.plateprefix) ~= 1 then
			stats[k] = v
		end
	end
	vehiclestats = stats

	vehicletires = cache.vehicletires or {}

	defaulthandling = cache.defaulthandling or {}

	vehicleupgrades = cache.vehicleupgrades or {}

	mileages = cache.mileages or {}

	drivetrain = cache.drivetrain or {}

	advancedflags = cache.advancedflags or {}

	GlobalState.ecu = cache.ecu or {}
	ecu = GlobalState.ecu

	currentengine = cache.currentengine or {}

    local vehicles = GetAllVehicles()
    for k,v in pairs(vehicles) do
		Wait(0)
		if DoesEntityExist(v) and GetEntityPopulationType(v) == 7 then
			local plate = string.gsub(GetVehicleNumberPlateText(v), '^%s*(.-)%s*$', '%1'):upper()
			if not vehiclestats[plate] then vehiclestats[plate] = {} end
			local ent = Entity(v).state
			vehiclestats[plate].active = true
			vehiclestats[plate].plate = plate
			for k,v2 in pairs(config.engineparts) do
				Wait(0)
				ent:set(v2.item, tonumber(vehiclestats[plate][v2.item] or 100), true)
			end
			if mileages[plate] then
				local ent = Entity(v).state
				ent:set('mileage', tonumber(mileages[plate]), true)
			end
		end
    end
    while true do
        Wait(60000)
		for k,v in pairs(defaulthandling) do
			if string.find(k,'ESX') or string.find(k,config.plateprefix) then
				defaulthandling[k] = nil
			end
		end
		local datas = {
			vehiclestats = vehiclestats,
			defaulthandling = defaulthandling,
			vehicleupgrades = vehicleupgrades,
			mileages = mileages
		}
		GlobalState.mileages = mileages
		db.saveall(datas)
    end
end)

CurrentEngine = function(value,bagName)
	if not value then return end
    local net = tonumber(bagName:gsub('entity:', ''), 10)
	local vehicle = NetworkGetEntityFromNetworkId(net)
	local plate = string.gsub(GetVehicleNumberPlateText(vehicle), '^%s*(.-)%s*$', '%1'):upper()
	if DoesEntityExist(vehicle) and string.find(plate,config.plateprefix) ~= 1 or config.debug then
		currentengine[plate] = value
		db.save('currentengine','plate',plate,value)
	end
end

AddStateBagChangeHandler('currentengine' --[[key filter]], nil --[[bag filter]], function(bagName, key, value, _unused, replicated)
    Wait(0)
    CurrentEngine(value,bagName)
end)

AddStateBagChangeHandler('engine' --[[key filter]], nil --[[bag filter]], function(bagName, key, value, _unused, replicated)
    Wait(0)
    CurrentEngine(value,bagName)
end)

AddStateBagChangeHandler('drivetrain' --[[key filter]], nil --[[bag filter]], function(bagName, key, value, _unused, replicated)
    Wait(0)
    if not value then return end
    local net = tonumber(bagName:gsub('entity:', ''), 10)
	local vehicle = NetworkGetEntityFromNetworkId(net)
	if DoesEntityExist(vehicle) then
		local plate = string.gsub(GetVehicleNumberPlateText(vehicle), '^%s*(.-)%s*$', '%1'):upper()
		drivetrain[plate] = value
		db.save('drivetrain','plate',plate,value)
	end
end)

AddStateBagChangeHandler('advancedflags' --[[key filter]], nil --[[bag filter]], function(bagName, key, value, _unused, replicated)
    Wait(0)
    if not value then return end
    local net = tonumber(bagName:gsub('entity:', ''), 10)
	local vehicle = NetworkGetEntityFromNetworkId(net)
	if DoesEntityExist(vehicle) then
		local plate = string.gsub(GetVehicleNumberPlateText(vehicle), '^%s*(.-)%s*$', '%1'):upper()
		advancedflags[plate] = value
		db.save('advancedflags','plate',plate,json.encode(advancedflags[plate]))
	end
end)

AddStateBagChangeHandler('mileage' --[[key filter]], nil --[[bag filter]], function(bagName, key, value, _unused, replicated)
    Wait(0)
    if not value then return end
    local net = tonumber(bagName:gsub('entity:', ''), 10)
	local vehicle = NetworkGetEntityFromNetworkId(net)
	if DoesEntityExist(vehicle) then
		local plate = string.gsub(GetVehicleNumberPlateText(vehicle), '^%s*(.-)%s*$', '%1'):upper()
		if string.find(plate,config.plateprefix) ~= 1 or config.debug then
			mileages[plate] = value
		end
	end
end)

for k,v in pairs(config.engineparts) do
	local name = v.item
	AddStateBagChangeHandler(name --[[key filter]], nil --[[bag filter]], function(bagName, key, value, _unused, replicated)
		Wait(0)
		if not value then return end
		local net = tonumber(bagName:gsub('entity:', ''), 10)
		local vehicle = NetworkGetEntityFromNetworkId(net)
		if DoesEntityExist(vehicle) then
			local plate = string.gsub(GetVehicleNumberPlateText(vehicle), '^%s*(.-)%s*$', '%1'):upper()
			if string.find(plate,config.plateprefix) ~= 1 or config.debug then
				if not vehiclestats[plate] then vehiclestats[plate] = {} end
				vehiclestats[plate][name] = value
				vehiclestats[plate].plate = plate
				vehiclestats[plate].active = true
			end
		end
	end)
end

for k,v in pairs(config.engineupgrades) do
	local name = v.item
	AddStateBagChangeHandler(name --[[key filter]], nil --[[bag filter]], function(bagName, key, value, _unused, replicated)
		Wait(0)
		if not value then return end
		local net = tonumber(bagName:gsub('entity:', ''), 10)
		local vehicle = NetworkGetEntityFromNetworkId(net)
		if DoesEntityExist(vehicle) then
			local plate = string.gsub(GetVehicleNumberPlateText(vehicle), '^%s*(.-)%s*$', '%1'):upper()
			if not vehicleupgrades[plate] then vehicleupgrades[plate] = {} end
			vehicleupgrades[plate][name] = value
			db.save('vehicleupgrades','plate',plate,json.encode(vehicleupgrades[plate]))
		end
	end)
end

AddStateBagChangeHandler('defaulthandling' --[[key filter]], nil --[[bag filter]], function(bagName, key, value, _unused, replicated)
	Wait(0)
	if not value then return end
	local net = tonumber(bagName:gsub('entity:', ''), 10)
	local vehicle = NetworkGetEntityFromNetworkId(net)
	if DoesEntityExist(vehicle) then
		local plate = string.gsub(GetVehicleNumberPlateText(vehicle), '^%s*(.-)%s*$', '%1'):upper()
		if string.find(plate,config.plateprefix) ~= 1 or config.debug then
			defaulthandling[plate] = value
		end
	end
end)

AddStateBagChangeHandler('tires' --[[key filter]], nil --[[bag filter]], function(bagName, key, value, _unused, replicated)
	Wait(0)
	if not value then return end
	local net = tonumber(bagName:gsub('entity:', ''), 10)
	local vehicle = NetworkGetEntityFromNetworkId(net)
	local plate = string.gsub(GetVehicleNumberPlateText(vehicle), '^%s*(.-)%s*$', '%1'):upper()
	if DoesEntityExist(vehicle) and string.find(plate,config.plateprefix) ~= 1 or config.debug then
		vehicletires[plate] = value
		db.save('vehicletires','plate',plate,json.encode(vehicletires[plate]))
	end
end)

lib.callback.register('renzu_tuners:Tune', function(src,data)
	local entity = NetworkGetEntityFromNetworkId(data.vehicle)
	local plate = string.gsub(GetVehicleNumberPlateText(entity), '^%s*(.-)%s*$', '%1'):upper()
	local state = Entity(entity).state
	data.tune.profile = data.profile
	state:set('ecu', data.tune)
	local tune = GlobalState.ecu
	if not tune[plate] then tune[plate] = {} end
	tune[plate][data.profile] = data.tune
	tune[plate]['active'] = data.tune
	db.save('ecu','plate',plate,json.encode(tune[plate]))
	GlobalState.ecu = tune
	ecu = tune
end)

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

GetItemCosts = function(item)
	local cost = 25000 -- default if item not found
	for k,v in pairs(itemsData) do
		if v.item == item then
			cost = v.cost
			break
		end
	end
	return cost
end

lib.callback.register('renzu_tuners:checkitem', function(src,item,isShop,required)
	local hasitems = false
	local amount = 1
	if not config.purchasableUpgrade then
		local metadata = config.metadata
		local itemstate = GetItemState(item)
		local isItemMetadata = itemstate ~= item
		local name = metadata and isItemMetadata and itemstate or item
		local items = GetInventoryItems(src, 'slots', name)
		if items then
			for k,v in pairs(items) do
				if metadata and isItemMetadata and v.metadata?.upgrade == item or not isItemMetadata and not v.metadata?.upgrade or not metadata then
					RemoveInventoryItem(src, v.name, amount,v.metadata,v.slot)
					hasitems = true
				end
			end
		end
	else
		local cost = GetItemCosts(item)
		local money = GetMoney(src)
		if money >= cost then
			RemoveMoney(src, cost)
			hasitems = true
		end
	end
	return hasitems
end)

lib.callback.register('renzu_tuners:OldEngine', function(src,name,engine,plate,net)
	local metadata = {}
	local vehicle = NetworkGetEntityFromNetworkId(net)
	local ent = Entity(vehicle).state
	local data = {}
	if vehicleupgrades[plate] then
		for k,v in pairs(vehicleupgrades[plate]) do
			for k2,v2 in pairs(config.engineupgrades) do
				if v2.item == k then
					table.insert(metadata,{part = k, durability = ent[v2.state]})
				end
			end
			table.insert(data,k:gsub('_',' '):upper())
		end
	end
	metadata.description = table.concat(data,', ')
	metadata.label = name
	metadata.image = 'engine'
	metadata.engine = engine
	AddInventoryItem(src, 'enginegago', 1, metadata)
	if vehicleupgrades[plate] then
		for k,v in pairs(vehicleupgrades[plate]) do
			ent:set(k,false,true)
		end
	end
end)

lib.callback.register('renzu_tuners:GetEngineStorage', function(src,stash)
	return GetInventoryItems(stash, 'slots', 'enginegago')
end)

lib.callback.register('renzu_tuners:RemoveEngineStorage', function(src,data)
	RemoveInventoryItem(data.stash, data.name, 1, data.metadata, data.slot)
end)

lib.callback.register('renzu_tuners:Craft', function(src,slots,requiredata,item,engine)
	local success = false
	local reward = item.name
	local hasitems = false
	for slot,data in pairs(slots) do
		hasitems = RemoveInventoryItem(src, data.name, requiredata[data.name],data.metadata)
		if not hasitems then break end
	end
	if hasitems then
		if chance and math.random(1,100) <= chance or not chance then
			success = true
			local metadata = nil
			if engine then
				metadata = {label = engine.label, description = engine.label..' Engine Swap', engine = engine.name, image = 'engine'}
				reward = 'enginegago'
			end
			if config.metadata then
				if item.type == 'upgrade' then
					reward = item.state
					metadata = {upgrade = item.name, label = item.label, description = item.label..' Engine Parts', image = item.name}
				end
			end
			AddInventoryItem(src, reward, 1, metadata)
		end
	end
	return success
end)

AddEventHandler('onResourceStop', function(res)
	if res == GetCurrentResourceName() then
		for k,v in pairs(ramp) do
			if DoesEntityExist(v) then
				DeleteEntity(v)
			end
		end
	end
end)

AddEventHandler('entityCreated', function(entity)
	local entity = entity
	Wait(3000)
	if DoesEntityExist(entity) and GetEntityType(entity) == 2 and GetEntityPopulationType(entity) >= 6 then
    	local plate = string.gsub(GetVehicleNumberPlateText(entity), '^%s*(.-)%s*$', '%1'):upper()
		local ent = Entity(entity).state
		if vehiclestats[plate] then
			for k,v in pairs(vehiclestats[plate]) do
				ent:set(k,tonumber(v),true)
			end
			vehiclestats[plate].active = true
			vehiclestats[plate].plate = plate
		end
		if vehicleupgrades[plate] then
			for k,v in pairs(vehicleupgrades[plate]) do
				ent:set(k,v,true)
			end
		end
		if vehicletires[plate] then
			ent:set('tires',vehicletires[plate],true)
		end
		if defaulthandling[plate] then
			ent:set('defaulthandling',defaulthandling[plate],true)
		end
		if drivetrain[plate] then
			ent:set('drivetrain',drivetrain[plate],true)
		end
		if advancedflags[plate] then
			ent:set('advancedflags',advancedflags[plate],true)
		end
	end
end)

AddEventHandler('entityRemoved', function(entity)
	local entity = entity
	if DoesEntityExist(entity) and GetEntityType(entity) == 2 and GetEntityPopulationType(entity) == 7 then
		local plate = string.gsub(GetVehicleNumberPlateText(entity), '^%s*(.-)%s*$', '%1'):upper()
		if vehiclestats[plate] and vehiclestats[plate].active then
			vehiclestats[plate].active = nil
			vehiclestats[plate].plate = nil
		end
	end
end)

Citizen.CreateThreadNow(function()
	if GetResourceState('ox_inventory') == 'started' then
		for k,v in pairs(config.engineswapper.coords) do
			RegisterStash('engine_storage:'..k, 'Engine Storage', 70, 1000000, false,{[config.job] = 0})
		end
	end
end)