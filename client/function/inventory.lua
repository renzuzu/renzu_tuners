-- ox item export
exports('useItem', function(data, slot)
    local closestvehicle = GetClosestVehicle(GetEntityCoords(cache.ped), 10.0)
    if DoesEntityExist(closestvehicle) then
        exports.ox_inventory:useItem(data, function(data)
            if data then
				ItemFunction(closestvehicle,data)
            end
        end)
    else
        lib.notify({type = 'error', description = 'There is no vehicle nearby'})
    end
end)

-- this export is made for ox_inventory
-- but you can adapt any inventory by triggering this client event from server ex. when item is used
AddEventHandler('useItem', ItemFunction)
-- TriggerClientEvent('useItem', source, NetworkGetNetworkIdFromEntity(vehicle),{name = 'oem_suspension', label = 'OEM Suspension'})