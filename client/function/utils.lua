-- bunch of functions, will re organize them to proper lua file later..

SaveStateFlags = function(vehicle,state,data) -- handle Advanced Flags Handling
	local export = exports.renzu_tuners
	local name = data.handling.name
	local value = data.handling.value
	local vehicleflags = GetVehicleHandlingInt(vehicle, data.handling.type, name)
	local flags = GetInstalledFlags(to16Bit(vehicleflags))
	if not state.advancedflags then
		state:set('advancedflags',{
			[name] = {installed = flags, flags = vehicleflags}
		},true)
	elseif not state.advancedflags[name] then
		local stateflags = state.advancedflags
		stateflags[name] = {installed = flags, flags = vehicleflags}
		state:set('advancedflags', stateflags, true)
	end
	for k,v in pairs(value) do
		if not DoesVehicleFlagsExist(v,flags) then
			vehicleflags += (1 << v)
			local add = state.advancedflags
			add[name] = {installed = GetInstalledFlags(to16Bit(vehicleflags)), flags = vehicleflags}
			state:set('advancedflags',add,true)
		end
	end
end

SetVehicleFlags = function(vehicle,data) -- set strHandlingFlags custom function eg. kers and stanced
	local drivetrain = GetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fDriveBiasFront')
	for name,v in pairs(data) do
		if name == 'strAdvancedFlags' then
			if isStanced(v.installed) then
				SetReduceDriftVehicleSuspension(vehicle,true)
			end
			SetVehicleHandlingField(vehicle, 'CCarHandlingData', name, v.flags)
			applyVehicleMods(vehicle,drivetrain)
		else
			if name == 'strHandlingFlags' and DoesKersExist(v.installed) then
				SetVehicleKersAllowed(vehicle,true)
			end
			SetVehicleHandlingField(vehicle, 'CHandlingData', name, v.flags)
		end
	end
end

SetVehicleDriveTrain = function(vehicle,value)
	local weight = GetVehicleHandlingInt(vehicle,'CHandlingData', 'fMass')
	local drivetrain = GetVehicleHandlingInt(vehicle,'CHandlingData', 'fDriveBiasFront')
	local val = 1.0
	if tonumber(value) == 0.5 and drivetrain >= 0.5 and drivetrain < 1.0 then
		val = 0.65
	elseif tonumber(value) == 0.5 and drivetrain >= 0.0 and drivetrain <= 0.5 then
		val = 0.4
	else
		val = value
	end
	SetVehicleHandlingField(vehicle , "CHandlingData", "fDriveBiasFront", tonumber(val)+0.0)
	if tonumber(value) > 0.0 and tonumber(value) < 1.0 then
		SetVehicleHandlingInt(vehicle , "CHandlingData", "fMass", tonumber(weight)*1.20)
	end
	applyVehicleMods(vehicle,value)
end

LoadVehicleSetup = function(value,ent,stats)
	plate = string.gsub(GetVehicleNumberPlateText(value), '^%s*(.-)%s*$', '%1'):upper()
	Citizen.CreateThreadNow(function()
		GetDefaultHandling(value,plate)
		Wait(100)
		HandleEngineDegration(value,ent,plate)
		for k,v in ipairs(config.engineparts) do
			if not ent[v.item] and stats then
				Wait(100)
				ent:set(v.item, tonumber(stats[v.item]) or 100, false)
			end
		end
	end)
end

function round(x)
	local val = x>=0 and math.floor(x+0.5) or math.ceil(x-0.5)
	return val
end

function to16Bit(num) -- convert decimal to hex ( since getter of vehicle flags return int while the setter needs to be a hex)
    local charset = {"0","1","2","3","4","5","6","7","8","9","a","b","c","d","e","f"}
    local tmp = {}
    repeat
        table.insert(tmp,1,charset[num%16+1])
        num = math.floor(num/16)
    until num==0
    return table.concat(tmp)
end

function GetInstalledFlags(val) -- organize vehicle flags, so it will be easy to set/remove them later.
    local flagsValueNum = tonumber(val, 16)
    local flags = {}
	for i = 0, 31 do
		local flagBit = ((0x1 << tonumber(i)));
        if ((tonumber(flagBit) & tonumber(flagsValueNum)) > 0) then
            flags[i] = to16Bit(flagBit)
		end
	end
    return flags
end

function GetClosestVehicle(c,dist)
	local closest = 0
	for k,v in pairs(GetGamePool('CVehicle')) do
		local dis = #(GetEntityCoords(v) - c)
		if dis < dist 
		    or dist == -1 then
			closest = v
			dist = dis
		end
	end
	return closest, dist
end

function toggleDoor(vehicle, door)
    if GetVehicleDoorLockStatus(vehicle) ~= 2 then
		SetVehicleDoorOpen(vehicle, door, false, false)
    end
end

function ForceVehicleGear (vehicle, gear)
    SetVehicleCurrentGear(vehicle, gear)
    SetVehicleNextGear(vehicle, gear)
    return gear
end

function angle(veh)
	if not veh then return false end
	local vx,vy,vz = table.unpack(GetEntityVelocity(veh))
	local modV = math.sqrt(vx*vx + vy*vy)


	local rx,ry,rz = table.unpack(GetEntityRotation(veh,0))
	local sn,cs = -math.sin(math.rad(rz)), math.cos(math.rad(rz))

	if GetEntitySpeed(veh)* 3.6 < 20 or GetVehicleCurrentGear(veh) == 0 then return 0,modV end --speed over 25 km/h

	local cosX = (sn*vx + cs*vy)/modV
	return math.deg(math.acos(cosX))*0.5, modV
end

nextgearhash = `SET_VEHICLE_NEXT_GEAR`
setcurrentgearhash = `SET_VEHICLE_CURRENT_GEAR`
function SetVehicleNextGear(veh, gear)
    Citizen.InvokeNative(nextgearhash & 0xFFFFFFFF, veh, gear)
end

function SetVehicleCurrentGear(veh, gear)
    Citizen.InvokeNative(setcurrentgearhash & 0xFFFFFFFF, veh, gear)
end

function applyVehicleMods(veh,wheel) -- https://forum.cfx.re/t/cant-change-setvehiclehandlingfloat-transforming-vehicle-to-awd-fivem-bug/3393188
    SetVehicleModKit(veh,0)
	for i = 0 , 35 do
		SetVehicleMod(veh,i,GetVehicleMod(veh,i),false)
	end
	for i = 0 , 3 do
		SetVehicleWheelIsPowered(veh,i,false)
	end
	if wheel == 0.0 then
		for i = 0 , 3 do
			SetVehicleWheelIsPowered(veh,i,i >= 2)
		end
	elseif wheel == 1.0 then
		for i = 0 , 3 do
			SetVehicleWheelIsPowered(veh,i,i <= 1)
		end
	elseif wheel ~= nil then
		for i = 0 , 3 do
			SetVehicleWheelIsPowered(veh,i,true)
		end
	end
end

GetVehicleServerStates = function(plate) -- fetch only the current vehicle data
	Wait(5000) -- allowed other state bag to applied before saving a default handling.
	local vehicle = GetVehiclePedIsIn(cache.ped)
	if not DoesEntityExist(vehicle) then return end
	local plate = string.gsub(GetVehicleNumberPlateText(GetVehiclePedIsIn(cache.ped)), '^%s*(.-)%s*$', '%1'):upper()
	vehiclestats, vehicletires, mileages, ecu = lib.callback.await('renzu_tuners:vehiclestats', 0, plate) -- temporary work around to bypass statebag size limits.
	return true
end

SetEntityControlable = function(entity) -- server based entities. incase you are not the owner. server entities are a little complicated
    local netid = NetworkGetNetworkIdFromEntity(entity)
    SetNetworkIdExistsOnAllMachines(netid,true)
    SetEntityAsMissionEntity(entity,true,true)
    NetworkRequestControlOfEntity(entity)
    local attempt = 0
    while not NetworkHasControlOfEntity(entity) and attempt < 2000 and DoesEntityExist(entity) do
        NetworkRequestControlOfEntity(entity)
        Citizen.Wait(0)
        attempt = attempt + 1
    end
end

GetAvailableHandlings = function()
	local handling = {}
	for k,v in pairs(config.engineparts) do
		for k,name in pairs(v.handling) do
			if not handling[name] then handling[name] = {handling = name, affects = v.affects} end
		end
	end
	return handling
end

GetAfr = function(afr,turbopower,rpm)
	return (afr / maxafr)
end

RemoveDuplicatePart = function(vehicle,state)
	local ent = Entity(vehicle).state
	for k,v in pairs(config.engineupgrades) do
		if ent[v.item] and v.state == state then
			ent:set(v.item,false,true)
		end
	end
end

local hashandling = false

Sandbox = function(vehicle)
	invehicle = vehicle
	if vehicle then GetDefaultHandling(vehicle) end
	while invehicle do
		fInitialDriveForce = GetVehicleHandlingFloat(vehicle,'CHandlingData', 'fInitialDriveForce')
		fDriveInertia = GetVehicleHandlingFloat(vehicle,'CHandlingData', 'fDriveInertia')
		fInitialDriveMaxFlatVel = GetVehicleHandlingFloat(vehicle,'CHandlingData', 'fInitialDriveMaxFlatVel')
		fClutchChangeRateScaleUpShift = GetVehicleHandlingFloat(vehicle,'CHandlingData', 'fClutchChangeRateScaleUpShift')
		fClutchChangeRateScaleDownShift = GetVehicleHandlingFloat(vehicle,'CHandlingData', 'fClutchChangeRateScaleDownShift')
		fLowSpeedTractionLossMult = GetVehicleHandlingFloat(vehicle,'CHandlingData', 'fLowSpeedTractionLossMult')
		fTractionLossMult = GetVehicleHandlingFloat(vehicle,'CHandlingData', 'fTractionLossMult')
		fTractionCurveMin = GetVehicleHandlingFloat(vehicle,'CHandlingData', 'fTractionCurveMin')
		fTractionCurveMax = GetVehicleHandlingFloat(vehicle,'CHandlingData', 'fTractionCurveMax')
		fTractionCurveLateral = GetVehicleHandlingFloat(vehicle,'CHandlingData', 'fTractionCurveLateral')
		fBrakeForce = GetVehicleHandlingFloat(vehicle,'CHandlingData', 'fBrakeForce')
		fHandBrakeForce = GetVehicleHandlingFloat(vehicle,'CHandlingData', 'fHandBrakeForce')
		fSuspensionForce = GetVehicleHandlingFloat(vehicle,'CHandlingData', 'fSuspensionForce')
		fSuspensionCompDamp = GetVehicleHandlingFloat(vehicle,'CHandlingData', 'fSuspensionCompDamp')
		fSuspensionReboundDamp = GetVehicleHandlingFloat(vehicle,'CHandlingData', 'fSuspensionReboundDamp')
		fSuspensionUpperLimit = GetVehicleHandlingFloat(vehicle,'CHandlingData', 'fSuspensionUpperLimit')
		fSuspensionLowerLimit = GetVehicleHandlingFloat(vehicle,'CHandlingData', 'fSuspensionLowerLimit')
		fSuspensionRaise = GetVehicleHandlingFloat(vehicle,'CHandlingData', 'fSuspensionRaise')
		fSuspensionBiasFront = GetVehicleHandlingFloat(vehicle,'CHandlingData', 'fSuspensionBiasFront')
		fAntiRollBarForce = GetVehicleHandlingFloat(vehicle,'CHandlingData', 'fAntiRollBarForce')
		fAntiRollBarBiasFront = GetVehicleHandlingFloat(vehicle,'CHandlingData', 'fAntiRollBarBiasFront')
		fRollCentreHeightFront = GetVehicleHandlingFloat(vehicle,'CHandlingData', 'fRollCentreHeightFront')
		fRollCentreHeightRear = GetVehicleHandlingFloat(vehicle,'CHandlingData', 'fRollCentreHeightRear')
		nInitialDriveGears = GetVehicleHandlingInt(vehicle,'CHandlingData', 'nInitialDriveGears')
		Wait(1000)
	end
end

GetDefaultHandling = function(vehicle, plate) -- saves default handling of new vehicles
	local ent = Entity(vehicle).state
	local handlings = ent.defaulthandling
	if not ent.engine then
		ent:set('currentengine','default',false)
	end
	if not handlings and not ent.engine or not hashandling and not ent.defaulthandling then
		hashandling = true
		handlings = {
			fInitialDriveForce = GetVehicleHandlingFloat(vehicle,'CHandlingData', 'fInitialDriveForce'),
			fDriveInertia = GetVehicleHandlingFloat(vehicle,'CHandlingData', 'fDriveInertia'),
			fInitialDriveMaxFlatVel = GetVehicleHandlingFloat(vehicle,'CHandlingData', 'fInitialDriveMaxFlatVel'),
			fClutchChangeRateScaleUpShift = GetVehicleHandlingFloat(vehicle,'CHandlingData', 'fClutchChangeRateScaleUpShift'),
			fClutchChangeRateScaleDownShift = GetVehicleHandlingFloat(vehicle,'CHandlingData', 'fClutchChangeRateScaleDownShift'),
			fLowSpeedTractionLossMult = GetVehicleHandlingFloat(vehicle,'CHandlingData', 'fLowSpeedTractionLossMult'),
			fTractionLossMult = GetVehicleHandlingFloat(vehicle,'CHandlingData', 'fTractionLossMult'),
			fTractionCurveMin = GetVehicleHandlingFloat(vehicle,'CHandlingData', 'fTractionCurveMin'),
			fTractionCurveMax = GetVehicleHandlingFloat(vehicle,'CHandlingData', 'fTractionCurveMax'),
			fTractionCurveLateral = GetVehicleHandlingFloat(vehicle,'CHandlingData', 'fTractionCurveLateral'),
			fBrakeForce = GetVehicleHandlingFloat(vehicle,'CHandlingData', 'fBrakeForce'),
			fHandBrakeForce = GetVehicleHandlingFloat(vehicle,'CHandlingData', 'fHandBrakeForce'),
			fSuspensionForce = GetVehicleHandlingFloat(vehicle,'CHandlingData', 'fSuspensionForce'),
			fSuspensionCompDamp = GetVehicleHandlingFloat(vehicle,'CHandlingData', 'fSuspensionCompDamp'),
			fSuspensionReboundDamp = GetVehicleHandlingFloat(vehicle,'CHandlingData', 'fSuspensionReboundDamp'),
			fSuspensionUpperLimit = GetVehicleHandlingFloat(vehicle,'CHandlingData', 'fSuspensionUpperLimit'),
			fSuspensionLowerLimit = GetVehicleHandlingFloat(vehicle,'CHandlingData', 'fSuspensionLowerLimit'),
			fSuspensionRaise = GetVehicleHandlingFloat(vehicle,'CHandlingData', 'fSuspensionRaise'),
			fSuspensionBiasFront = GetVehicleHandlingFloat(vehicle,'CHandlingData', 'fSuspensionBiasFront'),
			fAntiRollBarForce = GetVehicleHandlingFloat(vehicle,'CHandlingData', 'fAntiRollBarForce'),
			fAntiRollBarBiasFront = GetVehicleHandlingFloat(vehicle,'CHandlingData', 'fAntiRollBarBiasFront'),
			fRollCentreHeightFront = GetVehicleHandlingFloat(vehicle,'CHandlingData', 'fRollCentreHeightFront'),
			fRollCentreHeightRear = GetVehicleHandlingFloat(vehicle,'CHandlingData', 'fRollCentreHeightRear'),
			nInitialDriveGears = GetVehicleHandlingInt(vehicle,'CHandlingData', 'nInitialDriveGears'),

		}
		ent:set('defaulthandling', handlings, true)
		return handlings
	end
	return handlings
end

GetEnginePerformance = function(vehicle,plate)
	return GetDefaultHandling(vehicle,plate)
end

SetDefaultHandling = function(vehicle,handling) -- setter from other resource ex. renzu_engine
	local ent = Entity(vehicle).state
	if ent.engine then
		ent:set('currentengine',ent.engine,true)
	end
	if not handling then hashandling = false return end
	local plate = string.gsub(GetVehicleNumberPlateText(vehicle), '^%s*(.-)%s*$', '%1'):upper()
	local handlings = ent.defaulthandling
	handlings = {
		fInitialDriveForce = handling.fInitialDriveForce or GetVehicleHandlingFloat(vehicle,'CHandlingData', 'fInitialDriveForce'),
		fDriveInertia = handling.fDriveInertia or GetVehicleHandlingFloat(vehicle,'CHandlingData', 'fDriveInertia'),
		fInitialDriveMaxFlatVel = handling.fInitialDriveMaxFlatVel or GetVehicleHandlingFloat(vehicle,'CHandlingData', 'fInitialDriveMaxFlatVel'),
		fClutchChangeRateScaleUpShift = handling.fClutchChangeRateScaleUpShift or GetVehicleHandlingFloat(vehicle,'CHandlingData', 'fClutchChangeRateScaleUpShift'),
		fClutchChangeRateScaleDownShift = handling.fClutchChangeRateScaleDownShift or GetVehicleHandlingFloat(vehicle,'CHandlingData', 'fClutchChangeRateScaleDownShift'),
		fLowSpeedTractionLossMult = GetVehicleHandlingFloat(vehicle,'CHandlingData', 'fLowSpeedTractionLossMult'),
		fTractionLossMult = GetVehicleHandlingFloat(vehicle,'CHandlingData', 'fTractionLossMult'),
		fTractionCurveMin = GetVehicleHandlingFloat(vehicle,'CHandlingData', 'fTractionCurveMin'),
		fTractionCurveMax = GetVehicleHandlingFloat(vehicle,'CHandlingData', 'fTractionCurveMax'),
		fTractionCurveLateral = GetVehicleHandlingFloat(vehicle,'CHandlingData', 'fTractionCurveLateral'),
		fBrakeForce = GetVehicleHandlingFloat(vehicle,'CHandlingData', 'fBrakeForce'),
		fHandBrakeForce = GetVehicleHandlingFloat(vehicle,'CHandlingData', 'fHandBrakeForce'),
		fSuspensionForce = GetVehicleHandlingFloat(vehicle,'CHandlingData', 'fSuspensionForce'),
		fSuspensionCompDamp = GetVehicleHandlingFloat(vehicle,'CHandlingData', 'fSuspensionCompDamp'),
		fSuspensionReboundDamp = GetVehicleHandlingFloat(vehicle,'CHandlingData', 'fSuspensionReboundDamp'),
		fSuspensionUpperLimit = GetVehicleHandlingFloat(vehicle,'CHandlingData', 'fSuspensionUpperLimit'),
		fSuspensionLowerLimit = GetVehicleHandlingFloat(vehicle,'CHandlingData', 'fSuspensionLowerLimit'),
		fSuspensionRaise = GetVehicleHandlingFloat(vehicle,'CHandlingData', 'fSuspensionRaise'),
		fSuspensionBiasFront = GetVehicleHandlingFloat(vehicle,'CHandlingData', 'fSuspensionBiasFront'),
		fAntiRollBarForce = GetVehicleHandlingFloat(vehicle,'CHandlingData', 'fAntiRollBarForce'),
		fAntiRollBarBiasFront = GetVehicleHandlingFloat(vehicle,'CHandlingData', 'fAntiRollBarBiasFront'),
		fRollCentreHeightFront = GetVehicleHandlingFloat(vehicle,'CHandlingData', 'fRollCentreHeightFront'),
		fRollCentreHeightRear = GetVehicleHandlingFloat(vehicle,'CHandlingData', 'fRollCentreHeightRear'),
		nInitialDriveGears = GetVehicleHandlingInt(vehicle,'CHandlingData', 'nInitialDriveGears'),

	}
	local gdefault = ent.defaulthandling
	ent:set('defaulthandling', handlings, true)
	Wait(1001)
	HandleEngineDegration(vehicle,ent,plate)
end

DoesKersExist = function(data) -- check if kinetic is installed in Flags, 3 is the index value of 32 list of gta flags
	for k,v in pairs(data) do
		if tonumber(k) == 3 then
			return true
		end
	end
	return false
end

isStanced = function(data) -- same with kinetics
	for k,v in pairs(data) do
		if tonumber(k) == 15 then
			return true
		end
	end
	return false
end

isTurbo = function(item) -- lazy item checker for turbos
	return string.find(item, 'turbo')
end

isNitro = function(item) -- lazy item checker for nitros
	return string.find(item, 'nitro')
end

GetTires = function(name)
	local val = nil
	for k,v in pairs(config.tires) do
		if name == v.item then
			val = v.item
		end
	end
	return val
end

GetDriveTrain = function(name)
	local val = nil
	for k,v in pairs(config.drivetrain) do
		if name == v.item then
			val = v.value
		end
	end
	return val
end

GetExtras = function(name)
	for k,v in pairs(config.extras) do
		if v.item == name then
			return v
		end
	end
	return false
end

DefaultSetting = function(vehicle)
	--SetReduceDriftVehicleSuspension(vehicle,true)
end

DoesVehicleFlagsExist = function(val,vehicleflag)
	for k,v in pairs(vehicleflag) do
		if tonumber(k) == tonumber(val) then
			return true
		end
	end
	return false
end

HasAccess = function()
	local job = PlayerData?.job?.name
	if not job then return end
	local access = config.job[PlayerData.job.name]
	if not config.job or access and access <= PlayerData.job.grade then
		return true
	end
	return false
end