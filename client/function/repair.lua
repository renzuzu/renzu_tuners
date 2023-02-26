local repairing = false
-- simple repair
function Repair()
	if repairing then return end
	local vehicle = GetClosestVehicle(GetEntityCoords(cache.ped), 10.0)
	local d1,d2 = GetModelDimensions(GetEntityModel(vehicle))
	if DoesEntityExist(vehicle) then
		repairing = true
		if GetVehicleClass(vehicle) == 8 then
			TaskTurnPedToFaceEntity(cache.ped, vehicle, 1.0)
			Citizen.Wait(1000)
			TaskStartScenarioInPlace(cache.ped, 'WORLD_HUMAN_WELDING', 0, true)
			lib.progressCircle({
				duration = 5000,
				position = 'bottom',
				useWhileDead = false,
				canCancel = false,
				disable = {
					car = true,
				},
			})
			lib.notify({
				title = 'Vehicle has been Repair',
				type = 'success'
			})
			repairing = false
			ClearPedTasks(cache.ped)
			return
		end
		lib.notify({
			title = 'Fix all the 4 sides of vehicle',
			type = 'success',
			position = 'bottom',
		})
		local data = {
			name = 'fixkit'
		}
		local spots = {
			[1] = {pos = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle,'wheel_lf')), scenario = "WORLD_HUMAN_WELDING", done = GetEntityBoneIndexByName(vehicle,'wheel_lf') == -1},
			[2] = {pos = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle,'wheel_rf')), scenario = "WORLD_HUMAN_WELDING", done = GetEntityBoneIndexByName(vehicle,'wheel_rf') == -1},
			[3] = {pos = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle,'wheel_lr')), scenario = "WORLD_HUMAN_WELDING", done = GetEntityBoneIndexByName(vehicle,'wheel_lr') == -1},
			[4] = {pos = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle,'wheel_rr')), scenario = "WORLD_HUMAN_WELDING", done = GetEntityBoneIndexByName(vehicle,'wheel_rr') == -1},
		}
		local uitext = false
        local canceled = false
		while repairing do
			Citizen.Wait(1)
			for k,v in pairs(spots) do
				local distance = #(GetEntityCoords(cache.ped) - vector3(v.pos.x, v.pos.y, v.pos.z))
				if not v.done then 
				    DrawMarker(0, v.pos.x, v.pos.y, v.pos.z+0.7, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 0.5, 0.5, 0.5, 200, 20, 20, 50, false, true, 2, nil, nil, false)
				end
				if distance < 1.3 then
					if not v.done then 
						lib.showTextUI('[E] - Repair this part')
						uitext = true
						while distance < 1.3 and not v.done do
							distance = #(GetEntityCoords(cache.ped) - vector3(v.pos.x, v.pos.y, v.pos.z))
							Wait(0)
							DrawMarker(0, v.pos.x, v.pos.y, v.pos.z+0.7, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 0.5, 0.5, 0.5, 20, 255, 20, 50, false, true, 2, nil, nil, false)
							if IsControlJustPressed(0, 38) then
								--if k == 2 then 
								--	SetEntityHeading(player, GetEntityHeading(vehicle))
								--	Citizen.Wait(500)
								--else
									TaskTurnPedToFaceEntity(cache.ped, vehicle, 1.0)
									Citizen.Wait(1000)
								--end
								TaskStartScenarioInPlace(cache.ped, v.scenario, 0, true)
								lib.progressCircle({
									duration = 5000,
									position = 'bottom',
									useWhileDead = false,
									canCancel = false,
									disable = {
										car = true,
									},
								})
								ClearPedTasks(cache.ped)
								v.done = true
							end
						end
					end
				elseif distance > 50 then
					lib.notify({
						title = 'Repair has been canceled',
						description = 'you are too far away',   
						type = 'error'
					})
					canceled = true
					repairing = false
					break
				end
				if uitext then
					uitext = false
					lib.hideTextUI()
				end
			end
			if canceled then break end
			if spots[1].done and spots[2].done and spots[3].done and spots[4].done then 
				SetVehicleFixed(vehicle)
				SetVehicleDeformationFixed(vehicle)
				SetVehicleEngineHealth(vehicle, 1000.0)
				SetVehicleBodyHealth(vehicle, 1000.0)
				repairing = false
				break
			end
		end
		if not canceled then
		lib.notify({
			title = 'Vehicle has been Repair',
			type = 'success'
		})
	    end
	else
		lib.notify({
			title = 'no vehicle to repair',
			type = 'error'
		})
	end
end