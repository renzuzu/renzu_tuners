-- here you can port other inventory functions
QbCore, ESX = nil, nil
if GetResourceState('qb-core') == 'started' then
	QbCore = exports['qb-core']:GetCoreObject()
elseif GetResourceState('es_extended') == 'started' then
	ESX = exports['es_extended']:getSharedObject()
end

GetInventoryItems = function(src, method, items, metadata)
	if GetResourceState('ox_inventory') == 'started' then
		return exports.ox_inventory:Search(src, method, items, metadata)
	elseif QbCore then
		local Player = QbCore.Functions.GetPlayer(src)
		local data = {}
        for _, item in pairs(Player?.PlayerData?.items or {}) do
			if items == item.name then
				table.insert(data,item)
			end
        end
        return data
	elseif ESX then
		local Player = ESX.GetPlayerFromId(src)
		local data = {}
        for _, item in pairs(Player?.inventory or {}) do
			if items == item.name then
				table.insert(data,item)
			end
        end
        return data
	end
end

GetMoney = function(src)
	if GetResourceState('ox_inventory') == 'started' then
		return exports.ox_inventory:Search(src, 'count', 'money')
	elseif QbCore then
		local Player = QbCore.Functions.GetPlayer(src)
        return Player.PlayerData.money['cash']
	elseif ESX then
		local Player = ESX.GetPlayerFromId(src)
		return Player.getMoney()
	end
end

RemoveMoney = function(src,amount)
	if GetResourceState('ox_inventory') == 'started' then
		RemoveInventoryItem(src,'money',amount)
	elseif QbCore then
		local Player = QbCore.Functions.GetPlayer(src)
		Player.Functions.RemoveMoney('cash',tonumber(amount))
	elseif ESX then
		local Player = ESX.GetPlayerFromId(src)
		return Player.removeMoney(amount)
	end
end

RemoveInventoryItem = function(src, item, count, metadata, slot)
	if GetResourceState('ox_inventory') == 'started' then
		return exports.ox_inventory:RemoveItem(src, item, count, metadata, slot)
	elseif QbCore then
		return exports['qb-inventory']:RemoveItem(src, item, count, slot, metadata)
	elseif ESX then
		local Player = ESX.GetPlayerFromId(src)
		return Player.removeInventoryItem(item, count, metadata, slot)
	end
end

AddInventoryItem = function(src, item, count, metadata, slot)
	if GetResourceState('ox_inventory') == 'started' then
		return exports.ox_inventory:AddItem(src, item, count, metadata, slot)
	elseif QbCore then
		return exports['qb-inventory']:AddItem(src, item, count, slot, metadata)
	elseif ESX then
		local Player = ESX.GetPlayerFromId(src)
		return Player.addInventoryItem(item, count, metadata, slot)
	end
end

RegisterStash = function(id,label,slots,size,perms,groups)
	if GetResourceState('ox_inventory') ~= 'started' then return end
	return exports.ox_inventory:RegisterStash(id,label,slots,size,perms,groups)
end

-- register QBcore Items
if not ESX then
	local register = function(source, item)
		local src = source
		local Player = QbCore.Functions.GetPlayer(src)
		local iteminfo = Player.Functions.GetItemByName(item.name)
		if iteminfo then
			RemoveInventoryItem(src,item.name,1,item.metadata,item.slot)
			TriggerClientEvent("useItem", src,false,{name = item.name, label = item.label},true)
		end
	end
	for k,v in pairs(config.engineparts) do
		QbCore.Functions.CreateUseableItem(v.item, register)
	end
	for k,v in pairs(config.engineupgrades) do
		QbCore.Functions.CreateUseableItem(v.item, register)
	end
	for k,v in pairs(config.tires) do
		QbCore.Functions.CreateUseableItem(v.item, register)
	end
	for k,v in pairs(config.drivetrain) do
		QbCore.Functions.CreateUseableItem(v.item, register)
	end
	for k,v in pairs(config.extras) do
		QbCore.Functions.CreateUseableItem(v.item, register)
	end
end