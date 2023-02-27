PlayerData, localhandling, invehicle, gtirehealth, turboconfig, ecu, indyno, efficiency, upgrade, stats, tune, ramp, engineswapper, winches, manual, zoffset, mode, lastdis, boostpergear, handlingcache, fInitialDriveMaxFlatVel, fDriveInertia, fInitialDriveForce, nInitialDriveGears, tiresave, vehiclestats, vehicletires, mileages, imagepath = {}, {}, false, nil, nil, nil, false, 1.0, {}, {}, {}, 0, nil, {}, false, 1, 'NORMAL', 0, {}, {}, nil, nil, nil, nil, 0, {}, {}, {}, 'nui://ox_inventory/web/images/'

if GetResourceState('es_extended') == 'started' then
	ESX = exports['es_extended']:getSharedObject()
	PlayerData = ESX.GetPlayerData()

	RegisterNetEvent('esx:playerLoaded', function(xPlayer)
		PlayerData = xPlayer
	end)

	RegisterNetEvent('esx:setJob', function(job)
		PlayerData.job = job
	end)

elseif GetResourceState('qb-core') == 'started' then
	QBCore = exports['qb-core']:GetCoreObject()
	PlayerData = QBCore.Functions.GetPlayerData()
	
	RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
		PlayerData = QBCore.Functions.GetPlayerData()
	end)

	RegisterNetEvent('QBCore:Client:OnJobUpdate', function(job)
		PlayerData.job = job
	end)
	imagepath = 'nui://qb-inventory/html/images/'
else -- standalone ?
	PlayerData = {job = 'mechanic'}
end