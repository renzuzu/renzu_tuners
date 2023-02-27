
AddStateBagChangeHandler('advancedflags' --[[key filter]], nil --[[bag filter]], function(bagName, key, value, _unused, replicated)
	Wait(0)
	if not value then return end
	local net = tonumber(bagName:gsub('entity:', ''), 10)
	local vehicle = net and NetworkGetEntityFromNetworkId(net)
	if DoesEntityExist(vehicle) then
		SetVehicleFlags(vehicle,value)
	end
end)

AddStateBagChangeHandler('height' --[[key filter]], nil --[[bag filter]], function(bagName, key, value, _unused, replicated)
	Wait(0)
	if not value then return end
	local net = tonumber(bagName:gsub('entity:', ''), 10)
	local vehicle = net and NetworkGetEntityFromNetworkId(net)
	if DoesEntityExist(vehicle) then
		SetVehicleSuspensionHeight(NetworkGetEntityFromNetworkId(net),tonumber(value))
	end
end)

AddStateBagChangeHandler('drivetrain' --[[key filter]], nil --[[bag filter]], function(bagName, key, value, _unused, replicated)
	Wait(111)
	local net = tonumber(bagName:gsub('entity:', ''), 10)
	local value = value
	if not value then return end
	local vehicle = net and NetworkGetEntityFromNetworkId(net)
	if DoesEntityExist(vehicle) then
		SetVehicleDriveTrain(vehicle,tonumber(value))
	end
end)

AddStateBagChangeHandler('ramp' --[[key filter]], nil --[[bag filter]], function(bagName, key, value, _unused, replicated)
    Wait(0)
    if not value then return end
    local net = tonumber(bagName:gsub('entity:', ''), 10)
    local entity = net and NetworkGetEntityFromNetworkId(net)
	if DoesEntityExist(entity) then
		ramp = entity
		SetEntityHeading(entity,value.heading)
		FreezeEntityPosition(entity,true)
		DisableVehicleWorldCollision(entity)
		SetEntityCollision(entity,false,true)
		SetEntityVisible(entity,config.dynopropShow)
	end
end)

local dynoentity = nil
AddStateBagChangeHandler('dynodata' --[[key filter]], nil --[[bag filter]], function(bagName, key, value, _unused, replicated)
    Wait(0)
    if not value then return end
    local net = tonumber(bagName:gsub('entity:', ''), 10)
    local entity = net and NetworkGetEntityFromNetworkId(net)
	if DoesEntityExist(entity) then
		dynoentity = entity
		SetVehicleCurrentRpm(entity,value.rpm)
		SetVehicleHandlingFloat(entity , "CHandlingData", "fDriveInertia", value.inertia)
		local inertia = GetVehicleHandlingFloat(entity, 'CHandlingData', 'fDriveInertia')
		SetVehicleCheatPowerIncrease(entity,1.0)
		ModifyVehicleTopSpeed(entity,1.0)
		SetVehicleHandbrake(entity,true)
	end
end)

local dynovehicle = {}
AddStateBagChangeHandler('startdyno' --[[key filter]], nil --[[bag filter]], function(bagName, key, value, _unused, replicated)
    Wait(0)
	if replicated then return end
    if not value then return end
    local net = tonumber(bagName:gsub('entity:', ''), 10)
    local entity = net and NetworkGetEntityFromNetworkId(net)
	if dynovehicle[net] == false and value.dyno then return end -- anti replication of statebag, seems first data is being replicated again after i change the data
	if dynovehicle[net] then dynovehicle[net] = false end
	if DoesEntityExist(entity) and value.dyno and not dynovehicle[net] then
		dynovehicle[net] = value.dyno
		SetVehicleOnGroundProperly(dynoentity)
		FreezeEntityPosition(veh,false)
		Wait(50)
		SetVehicleGravity(entity,false)
		SetEntityCoordsNoOffset(dynoentity,vec3(value.platform.coord.x,value.platform.coord.y,value.platform.coord.z)-vec3(0.0,0.0,0.9))
		SetEntityHeading(dynoentity,value.platform.coord.w)
		SetVehicleOnGroundProperly(dynoentity)
		SetEntityCoordsNoOffset(dynoentity,GetEntityCoords(entity)-vec3(0.0,0.0,0.1))
		Citizen.CreateThreadNow(function()
			local coord = GetEntityCoords(dynoentity)
			local rot = GetEntityRotation(dynoentity)
			local drivetrain = GetVehicleHandlingFloat(dynoentity,'CHandlingData', 'fDriveBiasFront')
			while dynovehicle[net] and value.dyno and DoesEntityExist(dynoentity) do
				Wait(0)
				SetEntityRotation(dynoentity, rot)
				local rpm = GetVehicleCurrentRpm(dynoentity)
				if rpm > 0.25 then
					for i = 0 , 7 do
						if drivetrain == 0.0 and i >= 2 then
							SetVehicleWheelRotationSpeed(dynoentity,i,-44.1 * rpm)
						elseif drivetrain == 1.0 and i <= 1 then
							SetVehicleWheelRotationSpeed(dynoentity,i,-44.1 * rpm)
						elseif drivetrain < 1.0 and drivetrain > 0.0 then
							SetVehicleWheelRotationSpeed(dynoentity,i,-44.1 * rpm)
						end
					end
				end
				Wait(0)
			end
			Wait(1500)
			SetVehicleHandlingFloat(dynoentity , "CHandlingData", "fDriveInertia", value.inertia+0.0)
			SetVehicleHandbrake(dynoentity,false)
			FreezeEntityPosition(dynoentity,false)
			SetEntityHasGravity(dynoentity,true)
			SetVehicleGravity(dynoentity,true)
			dynovehicle[net] = nil
		end)
	end
end)

AddStateBagChangeHandler('gearshift' --[[key filter]], nil --[[bag filter]], function(bagName, key, value, _unused, replicated) -- sync gear shifting and other vehicle stats
    Wait(0)
    if not value then return end
    local net = tonumber(bagName:gsub('entity:', ''), 10)
    local vehicle = net and NetworkGetEntityFromNetworkId(net)
	if DoesEntityExist(vehicle) and GetPedInVehicleSeat(vehicle,-1) ~= cache.ped then
		SetVehicleHandlingFloat(vehicle , "CHandlingData", "fInitialDriveMaxFlatVel", value.flatspeed+0.0)
		SetVehicleHandlingFloat(vehicle , "CHandlingData", "fInitialDriveForce", value.driveforce+0.0)
		SetVehicleHandlingInt(vehicle , "CHandlingData", "nInitialDriveGears", 1)
		ForceVehicleSingleGear(vehicle,value.gearmaxspeed,false)
	end
end)

AddStateBagChangeHandler('vehiclestatreset' --[[key filter]], nil --[[bag filter]], function(bagName, key, value, _unused, replicated) -- reset vehicle stats to original
    Wait(0)
    if not value then return end
    local net = tonumber(bagName:gsub('entity:', ''), 10)
    local vehicle = net and NetworkGetEntityFromNetworkId(net)
	if DoesEntityExist(vehicle) then
		SetVehicleHandlingInt(vehicle , "CCarHandlingData", "strAdvancedFlags", value.strAdvancedFlags)
		SetVehicleHandlingFloat(vehicle , "CHandlingData", "fInitialDriveMaxFlatVel", value.fInitialDriveMaxFlatVel+0.0)
		SetVehicleHandlingFloat(vehicle , "CHandlingData", "fInitialDriveForce", value.fInitialDriveForce+0.0)
		SetVehicleHandlingFloat(vehicle , "CHandlingData", "fDriveInertia", value.fDriveInertia+0.0)
		SetVehicleHandlingInt(vehicle , "CHandlingData", "nInitialDriveGears", value.nInitialDriveGears)
		ModifyVehicleTopSpeed(vehicle,1.0)
		SetVehicleCheatPowerIncrease(vehicle,1.0)
		SetVehicleHighGear(vehicle,value.nInitialDriveGears)
	end
end)

AddEventHandler('onResourceStop', function(res)
	if res == GetCurrentResourceName() then
		if DoesEntityExist(engineswapper) then
			DeleteEntity(engineswapper)
		end
		for k,v in pairs(winches) do
			DeleteEntity(v)
		end
	end
end)