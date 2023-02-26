
local db = setmetatable({},{
	__call = function(self)

		self.insert = function(column, data, plate)
			local str = 'INSERT INTO %s (%s, plate) VALUES(%s, %s)'
			return MySQL.insert.await(str:format('renzu_tuner',column,'?','?'),{data,plate})
		end

		self.update = function(column, where, string, data)
			local str = 'UPDATE %s SET %s = ? WHERE %s = ?'
			return MySQL.query(str:format('renzu_tuner',column,where),{data,string})
		end

		self.query = function(column, where, string)
			local str = 'SELECT %s FROM %s WHERE %s = ?'
			return MySQL.query.await(str:format(column,'renzu_tuner',where),{string})
		end

		self.fetchAll = function()
			local str = 'SELECT * FROM renzu_tuner'
			local query = MySQL.query.await(str)
			local data = {}
			for k,v in pairs(query) do
				for column, value in pairs(v) do
					if v.plate then
						if column ~= 'plate' and column ~= 'id' and value then
							if not data[column] then data[column] = {} end
							local success, result = pcall(json.decode, value)
							data[column][v.plate] = result
						end
					end
				end
			end
			return data
		end

		self.save = function(column, where, string, data)
			local str = 'SELECT 1 FROM %s WHERE %s = ?'
			local success, result = pcall(MySQL.scalar.await, str:format('renzu_tuner',where),{string})
			if success and result then
				self.update(column, where, string, data)
			else
				self.insert(column, data, string)
			end
		end

		self.savemulti = function(data,plate)
			local str = 'SELECT 1 FROM %s WHERE %s = ?'
			local success, result = pcall(MySQL.scalar.await, str:format('renzu_tuner','plate'),{plate})
			if success and result then
				local str = 'UPDATE %s SET %s = ?, %s = ?, %s = ?, %s = ? WHERE %s = ?'
				return MySQL.query(str:format('renzu_tuner','vehiclestats','defaulthandling','vehicleupgrades','mileages','plate'),{data.vehiclestats,data.defaulthandling,data.vehicleupgrades,data.mileages,plate})
			else
				local str = 'INSERT INTO %s (%s, %s, %s, %s, %s) VALUES(?, ?, ?, ?, ?)'
				return MySQL.insert.await(str:format('renzu_tuner','vehiclestats','defaulthandling','vehicleupgrades','mileages','plate'),{data.vehiclestats,data.defaulthandling,data.vehicleupgrades,data.mileages,plate})
			end
		end

		self.saveall = function(data)
			local actives = {}
			for k,v in pairs(data.vehiclestats) do
				if v.active then
					self.savemulti({
						vehiclestats = json.encode(data.vehiclestats[v.plate] or {}),
						defaulthandling = json.encode(data.defaulthandling[v.plate] or {}),
						vehicleupgrades = json.encode(data.vehicleupgrades[v.plate] or {}),
						mileages = tonumber(data.mileages[v.plate]) or 0,
					},v.plate)
				end
			end
		end

		return self
	end
})

Citizen.CreateThreadNow(function()
	local success, result = pcall(MySQL.scalar.await, 'SELECT 1 FROM renzu_tuner')
	if not success then
		MySQL.query([[CREATE TABLE `renzu_tuner` (
			`id` int NOT NULL AUTO_INCREMENT KEY,
			`plate` varchar(60) DEFAULT NULL,
			`mileages` int DEFAULT 0,
			`vehiclestats` longtext DEFAULT NULL,
			`defaulthandling` longtext DEFAULT NULL,
			`vehicleupgrades` longtext DEFAULT NULL,
			`vehicletires` longtext DEFAULT NULL,
			`drivetrain` varchar(60) DEFAULT NULL,
			`advancedflags` varchar(60) DEFAULT NULL,
			`ecu` longtext DEFAULT NULL,
			`currentengine` varchar(60) DEFAULT NULL
		)]])
		print("^2SQL INSTALL SUCCESSFULLY, dont forget to install the items. /install/ folder ^0")
	end
end)

return db()