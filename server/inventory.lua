-- here you can port other inventory functions
GetInventoryItems = function(src, method, item, metadata)
	local counts = exports.ox_inventory:Search(src, method, item, metadata)
	return counts
end

RemoveInventoryItem = function(src, item, count, metadata, slot)
	return exports.ox_inventory:RemoveItem(src, item, count, metadata, slot)
end

AddInventoryItem = function(src, item, count, metadata, slot)
	return exports.ox_inventory:AddItem(src, item, count, metadata, slot)
end

RegisterStash = function(id,label,slots,size,perms,groups)
	return exports.ox_inventory:RegisterStash(id,label,slots,size,perms,groups)
end