
Targets = function()
	local target = GetResourceState('ox_target') == 'started' and "ox_target" or GetResourceState('qb-target') == 'started' and "qb-target" or GetResourceState('qtarget') == 'started' and 'qtarget'
	if not target then return end
	local options = {
		{
			name = 'renzu_tuners:checkengine',
			icon = 'fa-solid fa-oil-can',
			label = 'Check Engine Status',
			canInteract = function(entity, distance, coords, name, boneId)
				if GetVehicleDoorLockStatus(entity) > 1 then return end
				return type(coords) ~= 'table' and #(coords - GetEntityCoords(entity)) < 1.9 or true
			end,
			onSelect = function(data)
				Citizen.CreateThreadNow(function()
					lib.progressCircle({
						duration = 2000,
						position = 'bottom',
						useWhileDead = false,
						canCancel = true,
						disable = {
							car = true,
						},
					}) 
					CheckVehicle()
				end)
			end
		},
		{
			name = 'renzu_tuners:checkperf',
			icon = 'fa-solid fa-car',
			label = 'Check Engine Performance',
			canInteract = function(entity, distance, coords, name, boneId)
				if GetVehicleDoorLockStatus(entity) > 1 then return end
				return type(coords) ~= 'table' and #(coords - GetEntityCoords(entity)) < 1.9 or true
			end,
			onSelect = function(data)
				Citizen.CreateThreadNow(function()
					lib.progressCircle({
						duration = 2000,
						position = 'bottom',
						useWhileDead = false,
						canCancel = true,
						disable = {
							car = true,
						},
					}) 
					CheckPerformance()
				end)
			end
		},
		{
			name = 'renzu_tuners:checkwheels',
			icon = 'fa-solid fa-car',
			label = 'Check Tires Status',
			canInteract = function(entity, distance, coords, name, boneId)
				if GetVehicleDoorLockStatus(entity) > 1 then return end
				return type(coords) ~= 'table' and #(coords - GetEntityCoords(entity)) < 1.9 or true
			end,
			onSelect = function(data)
				Citizen.CreateThreadNow(function()
					lib.progressCircle({
						duration = 2000,
						position = 'bottom',
						useWhileDead = false,
						canCancel = true,
						disable = {
							car = true,
						},
					}) 
					CheckWheels()
				end)
			end
		},
		{
			name = 'renzu_tuners:upgrade',
			icon = 'fa-solid fa-car',
			label = 'Upgrade Vehicle',
			canInteract = function(entity, distance, coords, name, boneId)
				if GetVehicleDoorLockStatus(entity) > 1 then return end
				return type(coords) ~= 'table' and #(coords - GetEntityCoords(entity)) < 1.9 and HasAccess() or HasAccess()
			end,
			onSelect = function(data)
				Citizen.CreateThreadNow(function()
					lib.progressCircle({
						duration = 2000,
						position = 'bottom',
						useWhileDead = false,
						canCancel = true,
						disable = {
							car = true,
						},
					}) 
					CheckVehicle(HasAccess())
				end)
			end
		}
	}
	if target ~= 'ox_target' then
		for k,v in pairs(options) do
			if v.onSelect then
				v.action = v.onSelect
				v.onSelect = nil
			end
		end
		exports[target]:AddGlobalVehicle({options = options, distance = 4})
	else
		exports[target]:addGlobalVehicle(options)
	end

	-- CRAFTING

	Crafting = function()
		for k,v in pairs(config.crafting) do
			local targetoptions = {
				{
					name = k..'_boxzone',
					onSelect = function()
						local options = {}
						for k2,v in pairs(v.categories) do
							table.insert(options,{
								title = v.label,
								--icon = k == 'engine' and 'nui://ox_inventory/web/images/engine.png' or 'nui://ox_inventory/web/images/'..v.name..'.png',
								description = 'Craft '..v.label,
								arrow = true,
								onSelect = function()
									CraftOption(v.items,k,v.label)
								end,
							})
						end
						lib.registerContext({
							id = k..'_menu',
							title = v.label,
							options = options
						})
						lib.showContext(k..'_menu')
					end,
					icon = 'fa-solid fa-cube',
					label = v.label,
					canInteract = function(entity, distance, coords, name)
						return HasAccess()
					end
				}
			}
			for k,v in pairs(targetoptions) do
				if v.onSelect then
					v.action = v.onSelect
				end
			end
			local options = {
				coords = v.coord,
				size = vec3(2, 2, 2),
				rotation = 45,
				debug = drawZones,
				options = targetoptions
			}
			if target == 'ox_target' then
				exports[target]:addBoxZone(options)
			else
				local coord = GetEntityCoords(cache.ped)
				exports[target]:AddBoxZone(k..'_boxzone',options.coords,0.40,0.40,{name = k..'_boxzone',
				debugPoly = true,
				minZ = options.coords.z-0.2,
				maxZ = options.coords.z+0.2,},options)
			end
		end
	end

	EngineSwaps = function()
		lib.requestModel(config.engineswapper.model)
		for k,v in pairs(config.engineswapper.coords) do
			for k,v2 in pairs(GetGamePool('CPed')) do
				if #(GetEntityCoords(v2) - vec3(v.x,v.y,v.z)) < 3 then
					DeleteEntity(v2)
				end
			end
			engineswapper = CreateObjectNoOffset(config.engineswapper.model,v.x,v.y,v.z-0.98,false,true)
			while not DoesEntityExist(engineswapper) do Wait(1) end
			SetEntityHeading(engineswapper,v.w-180)
			FreezeEntityPosition(engineswapper)

			local options = {
				{
					name = 'engineswap:',
					onSelect = function()
						lib.registerContext({
							id = 'engine_swapper',
							title = 'Engine Swap',
							options = {
								{
									title = 'Select and Install Engine',
									description = 'Choose a engine from storage',
									arrow = true,
									onSelect = function(data)
										local vehicle = GetClosestVehicle(GetEntityCoords(engineswapper), 4.0)
										ContextMenuOptions('engine_storage:'..k,engineswapper,vehicle)
									end
								},
								{
									title = 'Engine Storage',
									description = 'Store a engine',
									arrow = true,
									onSelect = function()
										TriggerEvent('ox_inventory:openInventory', 'stash', {id = 'engine_storage:'..k, name = 'Engine Storage', slots = 70, weight = 1000000, coords = GetEntityCoords(cache.ped)})
									end
								},
							}
						})
						lib.showContext('engine_swapper')
					end,
					icon = 'fa-solid fa-car',
					label = 'Engine Stand',
					canInteract = function(entity, distance, coords, name)
						return distance < 2 and HasAccess() or HasAccess()
					end
				}
			}
			if target == 'ox_target' then
				exports[target]:addLocalEntity({engineswapper}, options)
			else
				for k,v in pairs(options) do
					if v.onSelect then
						v.action = v.onSelect
						v.onSelect = nil
					end
				end
				exports[target]:AddTargetEntity(engineswapper, {options = options, distance = 4})
			end
			
		end
	end
	Citizen.CreateThread(EngineSwaps)
	if config.enablecrafting then
		Citizen.CreateThread(Crafting)
	end
end

CreateThread(function()
	Wait(1100)
	Targets()
end)