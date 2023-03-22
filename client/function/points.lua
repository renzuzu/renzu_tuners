-- Points
local upgrademarkers = {}
SetupUpgradePoints = function(data,index)
	local point = lib.points.new(data.coord, 5)
	
	function point:onEnter()
		upgrademarkers[index] = CreateCheckpoint(5, data.coord.x, data.coord.y, data.coord.z+1.3, 0, 0, 0, 2.0, 25, 200, 21, 244, 0)
		SetCheckpointScale(upgrademarkers[index], 0.4)
		SetCheckpointCylinderHeight(upgrademarkers[index], 0.0, 0.0, 4.0)
		lib.showTextUI('[E] - '..data.label)
	end
	
	function point:onExit()
		lib.hideTextUI()
		DeleteCheckpoint(upgrademarkers[index])
	end
	
	function point:nearby()
		--DrawMarker(2, self.coords.x, self.coords.y, self.coords.z, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 1.0, 1.0, 1.0, 200, 20, 20, 50, false, true, 2, nil, nil, false)
		if self.currentDistance < 1 and IsControlJustReleased(0, 38) and IsPedInAnyVehicle(cache.ped) then
			CheckVehicle(HasAccess())
			FreezeEntityPosition(GetVehiclePedIsIn(cache.ped),true)
		end
	end
end

local repair_markers = {}
SetupRepairPoints = function(data,index)
	local point = lib.points.new(data.coord, 5)
	
	function point:onEnter()
		lib.showTextUI('[E] - '..data.label)
		repair_markers[index] = CreateCheckpoint(5, data.coord.x, data.coord.y, data.coord.z+1.3, 0, 0, 0, 2.0, 255, 2, 21, 244, 0)
		SetCheckpointScale(repair_markers[index], 0.4)
		SetCheckpointCylinderHeight(repair_markers[index], 0.0, 0.0, 4.0)
	end
	
	function point:onExit()
		lib.hideTextUI()
		DeleteCheckpoint(repair_markers[index])
	end
	
	function point:nearby()
		local access = HasAccess()
		if self.currentDistance < 4 and IsControlJustReleased(0, 38) and access then
			Repair()
		end
	end
end

local dyno_markers = {}
SetupDynoPoints = function(data,index)
	local point = lib.points.new(data.coord, 5)
	
	function point:onEnter()
		lib.showTextUI('[E] - '..data.label)
		dyno_markers[index] = CreateCheckpoint(5, data.coord.x, data.coord.y, data.coord.z-1.0, 0, 0, 0, 2.0, 255, 2, 21, 244, 0)
		SetCheckpointScale(dyno_markers[index], 0.4)
		SetCheckpointCylinderHeight(dyno_markers[index], 0.0, 0.0, 4.0)
		local rampmodel = `prop_spray_jackframe`
		lib.requestModel(rampmodel)
	end
	
	function point:onExit()
		lib.hideTextUI()
		DeleteCheckpoint(dyno_markers[index])
	end
	
	function point:nearby()
		local access = HasAccess() or config.sandboxmode
		if self.currentDistance < 4 and IsControlJustReleased(0, 38) and access then
			Dyno(data,index)
		end
	end
end