-- here you can port other inventory functions
if config.sandboxmode then return end
QbCore, ESX = nil, nil
if GetResourceState('qb-core') == 'started' then
	QbCore = exports['qb-core']:GetCoreObject()
elseif GetResourceState('es_extended') == 'started' then
	ESX = exports['es_extended']:getSharedObject()
end

GetPlayerFromId = function(src)
	if ESX then
		return ESX.GetPlayerFromId(src)
	elseif QbCore then
		local Player = QbCore.Functions.GetPlayer(src)
		if Player.job == nil then
			Player.job = Player.PlayerData.job
		end
		return Player
	end
end

GetInventoryItems = function(src, method, items, metadata)
	if GetResourceState('ox_inventory') == 'started' then
		return exports.ox_inventory:Search(src, method, items, metadata)
	elseif QbCore then
		local Player = GetPlayerFromId(src)
		local data = {}
        for _, item in pairs(Player?.PlayerData?.items or {}) do
			if items == item.name then
				item.metadata = item.info
				if item?.metadata?.quality then
					item.metadata.durability = item.metadata.quality
				end
				table.insert(data,item)
			end
        end
        return data
	elseif ESX then
		local Player = GetPlayerFromId(src)
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
		local Player = GetPlayerFromId(src)
        return Player.PlayerData.money['cash']
	elseif ESX then
		local Player = GetPlayerFromId(src)
		return Player.getMoney()
	end
end

RemoveMoney = function(src,amount)
	if GetResourceState('ox_inventory') == 'started' then
		RemoveInventoryItem(src,'money',amount)
	elseif QbCore then
		local Player = GetPlayerFromId(src)
		Player.Functions.RemoveMoney('cash',tonumber(amount))
	elseif ESX then
		local Player = GetPlayerFromId(src)
		return Player.removeMoney(amount)
	end
end

RemoveInventoryItem = function(src, item, count, metadata, slot)
	if GetResourceState('ox_inventory') == 'started' then
		return exports.ox_inventory:RemoveItem(src, item, count, metadata, slot)
	elseif QbCore then
		return exports['qb-inventory']:RemoveItem(src, item, count, slot, metadata)
	elseif ESX then
		local Player = GetPlayerFromId(src)
		return Player.removeInventoryItem(item, count, metadata, slot)
	end
end

AddInventoryItem = function(src, item, count, metadata, slot)
	if GetResourceState('ox_inventory') == 'started' then
		return exports.ox_inventory:AddItem(src, item, count, metadata, slot)
	elseif QbCore then
		metadata.quality = metadata.durability
		return exports['qb-inventory']:AddItem(src, item, count, slot, metadata)
	elseif ESX then
		local Player = GetPlayerFromId(src)
		return Player.addInventoryItem(item, count, metadata, slot)
	end
end

SetDurability = function(src,percent,slot,metadata,item)
	if GetResourceState('ox_inventory') == 'started' then
		return exports.ox_inventory:SetDurability(src, slot, percent)
	elseif QbCore then
		local Player = GetPlayerFromId(src)
		Player.PlayerData.items[slot].info.quality = percent
		Player.Functions.SetPlayerData("items", Player.PlayerData.items)
	end
end

RegisterStash = function(id,label,slots,size,perms,groups)
	if GetResourceState('ox_inventory') ~= 'started' then return end
	return exports.ox_inventory:RegisterStash(id,label,slots,size,perms,groups)
end

-- register ESX & QBcore Items if ox_inventory is missing

RegisterUsableItem = {}
if ESX then
	RegisterUsableItem = ESX.RegisterUsableItem
elseif QbCore then
	RegisterUsableItem = QbCore.Functions.CreateUseableItem
end

if GetResourceState('ox_inventory') ~= 'started' then
	local register = function(source, item)
		local src = source
		local Player = GetPlayerFromId(src)
		local itemdata = type(item) == 'table' and item or {name = item, label = item} -- support ancient framework
		RemoveInventoryItem(src,itemdata.name,1,itemdata.metadata,itemdata.slot)
		TriggerClientEvent("useItem", src,false,{name = itemdata.name, label = itemdata.label},true)
	end
	for k,v in pairs(config.engineparts) do
		RegisterUsableItem(v.item, register)
	end
	for k,v in pairs(config.engineupgrades) do
		RegisterUsableItem(v.item, register)
	end
	for k,v in pairs(config.tires) do
		RegisterUsableItem(v.item, register)
	end
	for k,v in pairs(config.drivetrain) do
		RegisterUsableItem(v.item, register)
	end
	for k,v in pairs(config.extras) do
		RegisterUsableItem(v.item, register)
	end
	RegisterUsableItem('repairparts', register)

end