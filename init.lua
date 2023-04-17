PlayerData, localhandling, invehicle, gtirehealth, turboconfig, ecu, indyno, efficiency, upgrade, stats, tune, ramp, engineswapper, winches, manual, zoffset, mode, lastdis, boostpergear, handlingcache, fInitialDriveMaxFlatVel, fDriveInertia, fInitialDriveForce, nInitialDriveGears, tiresave, vehiclestats, vehicletires, mileages, imagepath , tuning_inertia, vehicle_table = {}, {}, false, nil, nil, {}, false, 1.0, {}, {}, {}, 0, nil, {}, false, 1, 'NORMAL', 0, {}, {}, nil, nil, nil, nil, 0, {}, {}, {}, 'nui://ox_inventory/web/images/', nil, {}

if GetResourceState('es_extended') == 'started' then
	ESX = exports['es_extended']:getSharedObject()
	PlayerData = ESX.GetPlayerData()
	if lib.addRadialItem then
		SetTimeout(100,function()
			local access = HasAccess()
			return access and HasRadialMenu()
		end)
	end

	RegisterNetEvent('esx:playerLoaded', function(xPlayer)
		PlayerData = xPlayer
		return HasRadialMenu()
	end)

	RegisterNetEvent('esx:setJob', function(job)
		PlayerData.job = job
		HasRadialMenu()
	end)

elseif GetResourceState('qb-core') == 'started' then
	QBCore = exports['qb-core']:GetCoreObject()
	PlayerData = QBCore.Functions.GetPlayerData()
	if PlayerData.job ~= nil then
		PlayerData.job.grade = PlayerData?.job?.grade?.level or 1
	end
	if lib.addRadialItem then
		SetTimeout(100,function()
			local access = HasAccess()
			return access and HasRadialMenu()
		end)
	end
	RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
		PlayerData = QBCore.Functions.GetPlayerData()
		if PlayerData.job ~= nil then
			PlayerData.job.grade = PlayerData?.job?.grade?.level or 1
		end
		return HasRadialMenu()
	end)

	RegisterNetEvent('QBCore:Client:OnJobUpdate', function(job)
		PlayerData.job = job
		if PlayerData.job ~= nil then
			PlayerData.job.grade = PlayerData?.job?.grade?.level or 1
		end
		HasRadialMenu()
	end)
	imagepath = 'nui://qb-inventory/html/images/'
else -- standalone ?
	PlayerData = {job = 'mechanic', grade = 9}
	if lib.addRadialItem then
		SetTimeout(100,function()
			return HasRadialMenu()
		end)
	end
	warn('you are not using any supported framework')
end