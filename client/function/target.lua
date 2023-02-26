exports.ox_target:addGlobalVehicle({
    {
        name = 'renzu_tuners:checkengine',
        icon = 'fa-solid fa-oil-can',
        label = 'Check Engine Status',
        canInteract = function(entity, distance, coords, name, boneId)
            if GetVehicleDoorLockStatus(entity) > 1 then return end
            return #(coords - GetEntityCoords(entity)) < 1.9
        end,
        onSelect = function(data)
            toggleDoor(data.entity, 4)
			exports.ox_target:disableTargeting(true)
			ExecuteCommand('-ox_target') -- this to prevent target focus race condition. probably fixed in latest version.
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
				Wait(1000)
				exports.ox_target:disableTargeting(false)
			end)
        end
    },
	{
        name = 'renzu_tuners:checkperf',
        icon = 'fa-solid fa-car',
        label = 'Check Engine Performance',
        canInteract = function(entity, distance, coords, name, boneId)
            if GetVehicleDoorLockStatus(entity) > 1 then return end
            return #(coords - GetEntityCoords(entity)) < 1.9
        end,
        onSelect = function(data)
            toggleDoor(data.entity, 4)
			exports.ox_target:disableTargeting(true)
			ExecuteCommand('-ox_target')
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
				Wait(1000)
				exports.ox_target:disableTargeting(false)
			end)
        end
    },
	{
        name = 'renzu_tuners:checkwheels',
        icon = 'fa-solid fa-car',
        label = 'Check Tires Status',
        canInteract = function(entity, distance, coords, name, boneId)
            if GetVehicleDoorLockStatus(entity) > 1 then return end
            return #(coords - GetEntityCoords(entity)) < 1.9
        end,
        onSelect = function(data)
			exports.ox_target:disableTargeting(true)
			ExecuteCommand('-ox_target')
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
				Wait(1000)
				exports.ox_target:disableTargeting(false)
			end)
        end
    },
	{
        name = 'renzu_tuners:upgrade',
        icon = 'fa-solid fa-car',
        label = 'Upgrade Vehicle',
        canInteract = function(entity, distance, coords, name, boneId)
            if GetVehicleDoorLockStatus(entity) > 1 then return end
            return #(coords - GetEntityCoords(entity)) < 1.9 and PlayerData?.job?.name == config.job
        end,
        onSelect = function(data)
			exports.ox_target:disableTargeting(true)
			ExecuteCommand('-ox_target')
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
				CheckVehicle(PlayerData?.job?.name == config.job)
				Wait(1000)
				exports.ox_target:disableTargeting(false)
			end)
        end
    }
})