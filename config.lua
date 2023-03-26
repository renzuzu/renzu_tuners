-- renzu_tuners
config = {}
-- debug mode -- saves all vehicle including non owned vehicles
config.debug = true -- enable commands for dev. /sethandling 100 (0-100), /setfuel 100 (0-100), /setmileage 1000 (0,10000) !! note this does not have permission checks
config.sandboxmode = false -- different tuning and no degrations and other stuff. mostly used only when trying to tweak a vehicle handling meta in dyno.
config.freeupgrade = true -- for upgrades. set to true best for standalone purpose or testing purpose, for roleplay use the crafting/jobmanage money. if false menu will requires you a specific item for each upgrades
config.metadata = false -- use item metadata when crafting items if ox_inventory. if your inventory does not support it, set this to false.

config.job = { -- set to false (config.job = false) if you want all feature are accesible by any player, or true, required job to use repairs and upgrade menu, dyno -- job access for menu upgrade and points. ex. mechanic, tuner?
	['mechanic'] = 1, -- @jobname -- @grade_level
	['tuners'] = 1, -- @jobname -- @grade_level
}

config.usetarget = true -- if false, please configure the points config -- supports ox_target,qtarget,qb-target only
config.enablepackage = true -- easy install all upgrade variants. ex. Full Upgrade all Racing Parts. this will install all in one package for each variants. each upgrades requires item if itemrequired is true
config.upgradepackageAnimation = false -- do animation for each upgrades in package

config.upgradevariation = { -- enable/disable upgrade variation.
	['elite'] = true,
	['pro'] = true,
	['racing'] = true,
	['ultimate'] = true,
}

config.enablecrafting = true -- crafting for items and parts,turbo, engine etc..
config.purchasableUpgrade = false -- dont like crafting / item based? set this to true to use money to all item upgrades
config.jobmanagemoney = false -- use job money if purchasableUpgrade. ex. esx_society, qb-management

config.nosaveplate = { -- dont save this plate pattern unless debuging
	['CFX'] = true,
	['RENT'] = true,
	['ESX'] = true,
}

config.enableDegration = true -- enable / disable degration of engine parts
config.degrade = { -- degrade value when specific mileage value is reach
	[1] = { min = 50000, degrade = 0.9},
	[2] = { min = 20000, degrade = 0.8},
	[3] = { min = 10000, degrade = 0.75},
	[4] = { min = 5000, degrade = 0.65},
	[5] = { min = 3000, degrade = 0.55},
	[6] = { min = 2000, degrade = 0.45},
	[7] = { min = 1500, degrade = 0.35},
	[8] = { min = 1000, degrade = 0.25},
	[9] = { min = 500, degrade = 0.15},
	[10] = { min = 100, degrade = 0.11},
	[11] = { min = 1, degrade = 0.01},
}

-- points
config.engineswapper = {
	coords = {
		[1] = vec4(-325.60,-139.27,39.00,74.43)
	},
	label = 'Engine Swap',
	model = `prop_engine_hoist`,
}

config.enablemarkers = true -- markers points
config.points = { -- marker and drawtext type interactions
	[1] = {label = 'Upgrade Vehicle', coord = vec3(-323.3034362793,-131.25146484375,38.210)},
	-- add new here
}

config.repairpoints = { -- marker and drawtext type interactions
	[1] = {label = 'Repair Vehicle', coord = vec3(-341.18142700195,-129.10722351074,38.53271)},
}

config.useMlo = false -- set to true if your using MLO and there will be no need to spawn Dynamometer prop
config.dynoprop = `mist_dyno` -- replace with your dyno prop or leave default
config.dynopropShow = true -- set to false if your MLO has a DYNO area.. but setting up the coordinates for prop is still require to make the dyno logic work.
config.dynocollision = true -- set to true if your using dynamometer prop
config.routingbucket = 0 -- leave default if your not using custom routing buckets
config.dynopoints = { -- @platform = exact location of prop. @coord marker location of dyno access
    -- east lost santos customs sample placement
	[1] = { 
		label = "Dynojet", 
		platform = vec4(-360.3323, -112.5015, 38.9845, 158.4727+180), -- location of dyno position where vehicle will align 
		offsets = vec3(0.2,0.0,0.0), -- additional (+) offset to vehicle fittings
		coord = vec3(-362.3821, -117.6957, 39.083) -- location of Interaction
	},
	-- benny sample placement
	[2] = {
		label = "Dynojet", 
		platform = vec4(-214.057, -1319.63, 31.15, 1.93), -- location of dyno position where vehicle will align
		offsets = vec3(0.0,0.2,0.0), -- additional (+) offset to vehicle fittings
		coord = vec3(-213.894, -1324.475, 30.909) -- location of Interaction
	}
}

config.enginestat_default = { -- default engine stat. do not edit, this is being used in tuning computation logic
	compression = 100.0,
	airpressure = 100.0,
	fuelpressure = 100.0,
	ignition = 100.0,
}

config.tuningmenu = {
	[1] = { 
		label = 'Engine Tuning',
		icon = 'wrench',
		description = 'Engine Management System',
		type = 'engine',
		attributes = {
			{ name = 'acceleration', type = "slider", label = "Ignition Timing", min = -0.5, max = 1.5 , step = 0.001, default = 1.0},
			{ name = 'engineresponse', type = "slider", label = "Fuel Table", min = -0.5, max = 1.5 , step = 0.001, default = 1.0},
			{ name = 'gear_response', type = "slider", label = "Gear Response", min = -0.5, max = 1.5 , step = 0.01, default = 1.0},
			{ name = 'topspeed', type = "slider", label = "Final Drive Gear", min = -0.5, max = 1.5 , step = 0.01, default = 1.0},
		}
	},
	[2] = { 
		label = 'Gear Ratio',
		icon = 'cogs',
		type = 'gearratio',
		description = 'Change Gear rations (affects /manualgear, /autogear only)',
	},
	[3] = { 
		label = 'Turbo Tuning',
		type = 'turbo',
		icon = 'chart-area',
		description = 'Change Boost Pressure per Gears',
		min = 0.5,
		max = 1.5,
	},
	[4] = { 
		label = 'Suspension Tuning',
		type = 'suspension',
		icon = 'car',
		description = 'Adjust Your vehicle suspension setting',
		handlingname = 'CHandlingData',
		attributes = {
			{ type = "slider", label = "fSuspensionForce", min = 0.5, max = 1.5 , step = 0.001, default = 1.0},
			{ type = "slider", label = "fSuspensionCompDamp", min = 0.5, max = 1.5 , step = 0.001, default = 1.0},
			{ type = "slider", label = "fSuspensionReboundDamp", min = 0.5, max = 1.5 , step = 0.01, default = 1.0},
			{ type = "slider", label = "fSuspensionUpperLimit", min = 0.5, max = 1.5 , step = 0.01, default = 1.0},
			{ type = "slider", label = "fSuspensionLowerLimit", min = 0.5, max = 1.5 , step = 0.01, default = 1.0},
			{ type = "slider", label = "fSuspensionRaise", min = 0.5, max = 1.5 , step = 0.01, default = 1.0},
			{ type = "slider", label = "fSuspensionBiasFront", min = 0.5, max = 1.5 , step = 0.01, default = 1.0},
			{ type = "slider", label = "fAntiRollBarForce", min = 0.5, max = 1.5 , step = 0.01, default = 1.0},
			{ type = "slider", label = "fAntiRollBarBiasFront", min = 0.5, max = 1.5 , step = 0.01, default = 1.0},
			{ type = "slider", label = "fRollCentreHeightFront", min = 0.5, max = 1.5 , step = 0.01, default = 1.0},
			{ type = "slider", label = "fRollCentreHeightRear", min = 0.5, max = 1.5 , step = 0.01, default = 1.0},
		}
	},
}

config.tunableonly = { -- bypasses upgrade add stats. dont disable these if you dont know what it is. this can only be modify via tuning when ex. in suspension if vehicle have upgraded suspension. eg. elite_suspension
	['fSuspensionUpperLimit'] = true,
	['fSuspensionLowerLimit'] = true,
	['fSuspensionRaise'] = true,
	['fSuspensionBiasFront'] = true,
	['fAntiRollBarForce'] = true,
	['fAntiRollBarBiasFront'] = true,
	['fRollCentreHeightFront'] = true,
	['fRollCentreHeightRear'] = true,

}

config.engineparts = { -- @item = item name, @handling = Affected Handling when degraded
	[1] = {item = 'engine_oil', label = 'Engine Oil', handling = {'fInitialDriveMaxFlatVel'}, maxdegrade = 0.1, affects = 'Top Speed', cost = 25000},
	[2] = {item = 'engine_sparkplug', label = 'Engine Spark Plug', handling = {'fDriveInertia'}, maxdegrade = 0.2, affects = 'Torque', cost = 25000},
	[3] = {item = 'engine_gasket', label = 'Engine Head Gasket', handling = {'fDriveInertia'}, maxdegrade = 0.3, affects = 'Torque', cost = 25000},
	[4] = {item = 'engine_airfilter', label = 'Engine Air Filter', handling = {'fInitialDriveForce'}, maxdegrade = 0.15, affects = 'Horsepower', cost = 25000},
	[5] = {item = 'engine_fuelinjector', label = 'Engine Fuel Injectors', handling = {'fInitialDriveForce'}, maxdegrade = 0.15, affects = 'Horsepower', cost = 25000},
	[6] = {item = 'engine_pistons', label = 'Engine Pistons' , handling = {'fInitialDriveMaxFlatVel'}, maxdegrade = 0.2, affects = 'Top Speed', cost = 25000},
	[7] = {item = 'engine_connectingrods', label = 'Engine Connecting Rods' , handling = {'fInitialDriveForce'}, maxdegrade = 0.2, affects = 'Top Speed', cost = 25000},
	[8] = {item = 'engine_valves', label = 'Engine Valves', handling = {'fInitialDriveForce'}, maxdegrade = 0.2, affects = 'Horsepower', cost = 25000},
	[9] = {item = 'engine_block', label = 'Engine Block', handling = {'fInitialDriveMaxFlatVel'}, maxdegrade = 0.2, affects = 'Top Speed', cost = 25000},
	[10] = {item = 'engine_crankshaft', label = 'Engine CranfkShaft', handling = {'fDriveInertia'}, maxdegrade = 0.3, affects = 'Torque', cost = 25000},
	[11] = {item = 'transmition_clutch', label = 'Transmission Clutch', handling = {'fClutchChangeRateScaleUpShift'}, maxdegrade = 0.7, affects = 'Down Shifting', cost = 25000},
	[12] = {item = 'engine_flywheel', label = 'Engine FlyWheel', handling = {'fClutchChangeRateScaleDownShift'}, maxdegrade = 0.8, affects = 'Up Shifting', cost = 25000},
	[13] = {item = 'engine_camshaft', label = 'Engine Camshaft', handling = {'fInitialDriveMaxFlatVel'}, maxdegrade = 0.5, affects = 'Top Speed', cost = 25000},
	[14] = {item = 'oem_brakes', label = 'OEM Brakes', handling = {'fBrakeForce','fHandBrakeForce'}, maxdegrade = 0.8, affects = 'Brake Power', cost = 25000},
	[15] = {item = 'oem_suspension', label = 'OEM Suspension', handling = {'fSuspensionForce','fSuspensionCompDamp','fSuspensionReboundDamp'}, maxdegrade = 0.8, affects = 'Suspension', cost = 25000},
	[16] = {item = 'oem_gearbox', label = 'OEM Gearbox', handling = {'nInitialDriveGears','fDriveInertia','fClutchChangeRateScaleUpShift','fClutchChangeRateScaleDownShift'}, maxdegrade = 0.2, affects = 'Acceleration', cost = 25000},
}

-- @category = category of upgrades, @state = state bag name of degration status. @item = item name, @handling = affected handling when upgraded , @add = percent added when upgraded
config.engineupgrades = {
	-- ULTIMATE
	{category = 'ultimate', state = 'engine_oil', item = 'ultimate_oil', label = 'Ultimate Oil', handling = {'fInitialDriveMaxFlatVel'}, add = 1.07, affects = 'Top Speed', cost = 550001},
	{category = 'ultimate', state = 'engine_sparkplug', item = 'ultimate_sparkplug', label = 'Ultimate Spark Plug', stat = {ignition = 3.2}, handling = {'fDriveInertia'}, add = 1.07, affects = 'Torque', cost = 550001},
	{category = 'ultimate', state = 'engine_gasket', item = 'ultimate_gasket', label = 'Ultimate Head Gasket', handling = {'fDriveInertia'}, add = 1.07, affects = 'Torque', cost = 550001},
	 {category = 'ultimate', state = 'engine_airfilter', item = 'ultimate_airfilter', label = 'Ultimate Air Filter', handling = {'fInitialDriveForce'}, add =1.07, affects = 'Horsepower', cost = 550001},
	{category = 'ultimate', state = 'engine_fuelinjector', item = 'ultimate_fuelinjector', label = 'Ultimate Fuel Injectors', stat = {fuelpressure = 43.2}, handling = {'fInitialDriveForce'}, add = 1.07, affects = 'Horsepower', cost = 550001},
	{category = 'ultimate', state = 'engine_pistons', item = 'ultimate_pistons', label = 'Ultimate Pistons' , stat = {compression = 16.0, fuelpressure = -16.0, ignition = 8.0}, handling = {'fInitialDriveMaxFlatVel'}, add = 1.09, affects = 'Top Speed', mod = {index = 11, add = 1}, cost = 550001},
	{category = 'ultimate', state = 'engine_connectingrods', item = 'ultimate_connectingrods', label = 'Ultimate Connecting Rods' , handling = {'fInitialDriveForce'}, add = 1.07, affects = 'Top Speed', cost = 550001},
	{category = 'ultimate', state = 'engine_valves', item = 'ultimate_valves', label = 'Ultimate Valves', stat = {compression = 1.6, fuelpressure = -1.6}, handling = {'fInitialDriveForce'}, add = 1.07, affects = 'Horsepower', cost = 550001},
	{category = 'ultimate', state = 'engine_block', item = 'ultimate_block', label = 'Ultimate Block', stat = {compression = 16.0, fuelpressure = -8.0, ignition = 8.0}, handling = {'fInitialDriveMaxFlatVel'}, add = 1.08, affects = 'Top Speed', mod = {index = 11, add = 1}, cost = 550001},
	{category = 'ultimate', state = 'engine_crankshaft', item = 'ultimate_crankshaft', label = 'Ultimate CranfkShaft',  stat = {ignition = 8.0}, handling = {'fDriveInertia'}, add = 1.1, affects = 'Torque', mod = {index = 11, add = 1}, cost = 550001},
	{category = 'ultimate', state = 'transmition_clutch', item = 'ultimate_clutch', label = 'Ultimate Transmission Clutch', handling = {'fClutchChangeRateScaleUpShift'}, add = 1.08, affects = 'Down Shifting', mod = {index = 13, add = 1}, cost = 550001},
	{category = 'ultimate', state = 'engine_flywheel', item = 'ultimate_flywheel', label = 'Ultimate FlyWheel', handling = {'fClutchChangeRateScaleDownShift'}, add = 1.08, affects = 'Up Shifting', mod = {index = 13, add = 1}, cost = 25000},
	{category = 'ultimate', state = 'engine_camshaft', item = 'ultimate_camshaft', label = 'Ultimate Camshaft',stat = {duration = 48.0, compression = 16.0, fuelpressure = -16.0, ignition = 16.0}, handling = {'fInitialDriveMaxFlatVel'}, add = 1.1, affects = 'Top Speed', mod = {index = 11, add = 1}, cost = 550001},
	{category = 'ultimate', state = 'oem_brakes', item = 'ultimate_brakes', label = 'Ultimate Brakes', handling = {'fBrakeForce','fHandBrakeForce'}, add = 6.4, affects = 'Brake Power', mod = {index = 12, add = 3}, cost = 550001},
	{category = 'ultimate', state = 'oem_suspension', item = 'ultimate_suspension', label = 'Ultimate Suspension', handling = {'fSuspensionForce','fSuspensionCompDamp','fSuspensionReboundDamp','fSuspensionUpperLimit','fSuspensionLowerLimit','fSuspensionRaise','fSuspensionBiasFront','fAntiRollBarForce','fAntiRollBarBiasFront','fRollCentreHeightFront','fRollCentreHeightRear'}, add = 1.6, affects = 'Suspension', mod = {index = 15, add = 4}, cost = 415000},
	{category = 'ultimate', state = 'oem_gearbox', item = 'ultimate_gearbox', label = 'Ultimate Gearbox', handling = {'nInitialDriveGears','fDriveInertia','fClutchChangeRateScaleUpShift','fClutchChangeRateScaleDownShift'}, add = 1.2, affects = 'Acceleration', mod = {index = 13, add = 1}, cost = 550001},
	-- RACING
	{category = 'racing', state = 'engine_oil', item = 'racing_oil', label = 'Racing Oil', handling = {'fInitialDriveMaxFlatVel'}, add = 1.045, affects = 'Top Speed', cost = 370001},
	{category = 'racing', state = 'engine_sparkplug', item = 'racing_sparkplug', label = 'Racing Spark Plug', stat = {ignition = 1.6}, handling = {'fDriveInertia'}, add = 1.05, affects = 'Torque', cost = 370001},
	{category = 'racing', state = 'engine_gasket', item = 'racing_gasket', label = 'Racing Head Gasket', handling = {'fDriveInertia'}, add = 1.05, affects = 'Torque', cost = 370001},
	 {category = 'racing', state = 'engine_airfilter', item = 'racing_airfilter', label = 'Racing Air Filter', handling = {'fInitialDriveForce'}, add = 1.03, affects = 'Horsepower', cost = 370001},
	{category = 'racing', state = 'engine_fuelinjector', item = 'racing_fuelinjector', label = 'Racing Fuel Injectors', stat = {fuelpressure = 21.6}, handling = {'fInitialDriveForce'}, add = 1.04, affects = 'Horsepower', cost = 370001},
	{category = 'racing', state = 'engine_pistons', item = 'racing_pistons', label = 'Racing Pistons', stat = {compression = 8.0, fuelpressure = -8.0, ignition = 4.0}, handling = {'fInitialDriveMaxFlatVel'}, add = 1.07, affects = 'Top Speed', mod = {index = 11, add = 1}, cost = 370001},
	{category = 'racing', state = 'engine_connectingrods', item = 'racing_connectingrods', label = 'Racing Connecting Rods' , handling = {'fInitialDriveForce'}, add = 1.05, affects = 'Top Speed', cost = 370001},
	{category = 'racing', state = 'engine_valves', item = 'racing_valves', label = 'Racing Valves', stat = {compression = 0.8, fuelpressure = -0.8}, handling = {'fInitialDriveForce'}, add = 1.04, affects = 'Horsepower', cost = 370001},
	{category = 'racing', state = 'engine_block', item = 'racing_block', label = 'Racing Block', stat = {compression = 8.0, fuelpressure = -4.0, ignition = 4.0}, handling = {'fInitialDriveMaxFlatVel'}, add = 1.05, affects = 'Top Speed', mod = {index = 11, add = 1}, cost = 370001},
	{category = 'racing', state = 'engine_crankshaft', item = 'racing_crankshaft', label = 'Racing CranfkShaft', stat = {ignition = 4.0}, handling = {'fDriveInertia'}, add = 1.05, affects = 'Torque', mod = {index = 11, add = 1}, cost = 370001},
	{category = 'racing', state = 'transmition_clutch', item = 'racing_clutch', label = 'Racing Transmission Clutch', handling = {'fClutchChangeRateScaleUpShift'}, add = 1.05, affects = 'Down Shifting', mod = {index = 13, add = 1}, cost = 370001},
	{category = 'racing', state = 'engine_flywheel', item = 'racing_flywheel', label = 'Racing FlyWheel', handling = {'fClutchChangeRateScaleDownShift'}, add = 1.05, affects = 'Up Shifting', mod = {index = 13, add = 1}, cost = 370001},
	{category = 'racing', state = 'engine_camshaft', item = 'racing_camshaft', label = 'Racing Camshaft',stat = {duration = 26.0, compression = 8.0, fuelpressure = -8.0, ignition = 8.0}, handling = {'fInitialDriveMaxFlatVel'}, add = 1.08, affects = 'Top Speed', mod = {index = 11, add = 1}, cost = 370001},
	{category = 'racing', state = 'oem_brakes', item = 'racing_brakes', label = 'Racing Brakes', handling = {'fBrakeForce','fHandBrakeForce'}, add = 2.4, affects = 'Brake Power', mod = {index = 12, add = 3}, cost = 370001},
	{category = 'racing', state = 'oem_suspension', item = 'racing_suspension', label = 'Racing Suspension', handling = {'fSuspensionForce','fSuspensionCompDamp','fSuspensionReboundDamp','fSuspensionUpperLimit','fSuspensionLowerLimit','fSuspensionRaise','fSuspensionBiasFront','fAntiRollBarForce','fAntiRollBarBiasFront','fRollCentreHeightFront','fRollCentreHeightRear'}, add = 1.4, affects = 'Suspension', mod = {index = 15, add = 4}, cost = 370001},
	{category = 'racing', state = 'oem_gearbox', item = 'racing_gearbox', label = 'Racing Gearbox', handling = {'nInitialDriveGears','fDriveInertia','fClutchChangeRateScaleUpShift','fClutchChangeRateScaleDownShift'}, add = 1.15, affects = 'Acceleration', mod = {index = 13, add = 1}, cost = 370001},
	-- PRO
	{category = 'pro', state = 'engine_oil', item = 'pro_oil', label = 'Pro Oil', handling = {'fInitialDriveMaxFlatVel'}, add = 1.025, affects = 'Top Speed', cost = 320000},
	{category = 'pro', state = 'engine_sparkplug', item = 'pro_sparkplug', label = 'Pro Spark Plug',stat = {ignition = 0.8}, handling = {'fDriveInertia'}, add = 1.035, affects = 'Torque', cost = 320000},
	{category = 'pro', state = 'engine_gasket', item = 'pro_gasket', label = 'Pro Head Gasket', handling = {'fDriveInertia'}, add = 1.04, affects = 'Torque', cost = 320000},
	 {category = 'pro', state = 'engine_airfilter', item = 'pro_airfilter', label = 'Pro Air Filter', handling = {'fInitialDriveForce'}, add =1.02, affects = 'Horsepower', cost = 320000},
	{category = 'pro', state = 'engine_fuelinjector', item = 'pro_fuelinjector', label = 'Pro Fuel Injectors',stat = {fuelpressure = 12.0},  handling = {'fInitialDriveForce'}, add = 1.025, affects = 'Horsepower', cost = 320000},
	{category = 'pro', state = 'engine_pistons', item = 'pro_pistons', label = 'Pro Pistons' , stat = {compression = 4.0, fuelpressure = -4.0, ignition = 2.0}, handling = {'fInitialDriveMaxFlatVel'}, add = 1.04, affects = 'Top Speed', mod = {index = 11, add = 1}, cost = 320000},
	{category = 'pro', state = 'engine_connectingrods', item = 'pro_connectingrods', label = 'Pro Connecting Rods' , handling = {'fInitialDriveForce'}, add = 1.03, affects = 'Top Speed', cost = 320000},
	{category = 'pro', state = 'engine_valves', item = 'pro_valves', label = 'Pro Valves', stat = {compression = 0.4, fuelpressure = -0.4}, handling = {'fInitialDriveForce'}, add = 1.025, affects = 'Horsepower', cost = 320000},
	{category = 'pro', state = 'engine_block', item = 'pro_block', label = 'Pro Block', stat = {compression = 4.0, fuelpressure = -2.0, ignition = 2.0}, handling = {'fInitialDriveMaxFlatVel'}, add = 1.035, affects = 'Top Speed', mod = {index = 11, add = 1}, cost = 320000},
	{category = 'pro', state = 'engine_crankshaft', item = 'pro_crankshaft', label = 'Pro CranfkShaft', stat = {ignition = 2.0}, handling = {'fDriveInertia'}, add = 1.03, affects = 'Torque', mod = {index = 11, add = 1}, cost = 320000},
	{category = 'pro', state = 'transmition_clutch', item = 'pro_clutch', label = 'Pro Transmission Clutch', handling = {'fClutchChangeRateScaleUpShift'}, add = 1.03, affects = 'Down Shifting', mod = {index = 13, add = 1}, cost = 320000},
	{category = 'pro', state = 'engine_flywheel', item = 'pro_flywheel', label = 'Pro FlyWheel', handling = {'fClutchChangeRateScaleDownShift'}, add = 1.03, affects = 'Up Shifting', mod = {index = 13, add = 1}, cost = 320000},
	{category = 'pro', state = 'engine_camshaft', item = 'pro_camshaft', label = 'Pro Camshaft',stat = {duration = 12.6,compression = 4.0, fuelpressure = -4.0, ignition = 4.0}, handling = {'fInitialDriveMaxFlatVel'}, add = 1.045, affects = 'Top Speed', mod = {index = 11, add = 1}, cost = 320000},
	{category = 'pro', state = 'oem_brakes', item = 'pro_brakes', label = 'Pro Brakes', handling = {'fBrakeForce','fHandBrakeForce'}, add = 1.7, affects = 'Brake Power', mod = {index = 12, add = 3}, cost = 320000},
	{category = 'pro', state = 'oem_suspension', item = 'pro_suspension', label = 'Pro Suspension', handling = {'fSuspensionForce','fSuspensionCompDamp','fSuspensionReboundDamp','fSuspensionUpperLimit','fSuspensionLowerLimit','fSuspensionRaise','fSuspensionBiasFront','fAntiRollBarForce','fAntiRollBarBiasFront','fRollCentreHeightFront','fRollCentreHeightRear'}, add = 1.25, affects = 'Suspension', mod = {index = 15, add = 4}, cost = 320000},
	{category = 'pro', state = 'oem_gearbox', item = 'pro_gearbox', label = 'Pro Gearbox', handling = {'nInitialDriveGears','fDriveInertia','fClutchChangeRateScaleUpShift','fClutchChangeRateScaleDownShift'}, add = 1.1, affects = 'Acceleration', mod = {index = 13, add = 1}, cost = 320000},
	-- ELITE
	{category = 'elite', state = 'engine_oil', item = 'elite_oil', label = 'Elite Oil', handling = {'fInitialDriveMaxFlatVel'}, add = 1.015, affects = 'Top Speed', cost = 125000},
	{category = 'elite', state = 'engine_sparkplug', item = 'elite_sparkplug', label = 'Elite Spark Plug',stat = {ignition = 0.4}, handling = {'fDriveInertia'}, add = 1.02, affects = 'Torque', cost = 125000},
	{category = 'elite', state = 'engine_gasket', item = 'elite_gasket', label = 'Elite Head Gasket', handling = {'fDriveInertia'}, add = 1.03, affects = 'Torque', cost = 125000},
	 {category = 'elite', state = 'engine_airfilter', item = 'elite_airfilter', label = 'Elite Air Filter', handling = {'fInitialDriveForce'}, add = 1.01, affects = 'Horsepower', cost = 125000},
	{category = 'elite', state = 'engine_fuelinjector', item = 'elite_fuelinjector', label = 'Elite Fuel Injectors', stat = {fuelpressure = 5.2}, handling = {'fInitialDriveForce'}, add = 1.015, affects = 'Horsepower', cost = 125000},
	{category = 'elite', state = 'engine_pistons', item = 'elite_pistons', label = 'Elite Pistons' ,stat = {compression = 2.0, fuelpressure = -2.0, ignition = 1.0}, handling = {'fInitialDriveMaxFlatVel'}, add = 1.03, affects = 'Top Speed', mod = {index = 11, add = 1}, cost = 125000},
	{category = 'elite', state = 'engine_connectingrods', item = 'elite_connectingrods', label = 'Elite Connecting Rods' , handling = {'fInitialDriveForce'}, add = 1.015, affects = 'Top Speed', cost = 125000},
	{category = 'elite', state = 'engine_valves', item = 'elite_valves', label = 'Elite Valves',stat = {compression = 0.2, fuelpressure = -0.2}, handling = {'fInitialDriveForce'}, add = 1.015, affects = 'Horsepower', cost = 125000},
	{category = 'elite', state = 'engine_block', item = 'elite_block', label = 'Elite Block',stat = {compression = 2.0, fuelpressure = -1.0, ignition = 1.0}, handling = {'fInitialDriveMaxFlatVel'}, add = 1.02, affects = 'Top Speed', mod = {index = 11, add = 1}, cost = 125000},
	{category = 'elite', state = 'engine_crankshaft', item = 'elite_crankshaft', label = 'Elite CranfkShaft',stat = {ignition = 1.0}, handling = {'fDriveInertia'}, add = 1.02, affects = 'Torque', mod = {index = 11, add = 1}, cost = 125000},
	{category = 'elite', state = 'transmition_clutch', item = 'elite_clutch', label = 'Elite Transmission Clutch', handling = {'fClutchChangeRateScaleUpShift'}, add = 1.02, affects = 'Down Shifting', mod = {index = 13, add = 1}, cost = 125000},
	{category = 'elite', state = 'engine_flywheel', item = 'elite_flywheel', label = 'Elite FlyWheel', handling = {'fClutchChangeRateScaleDownShift'}, add = 1.02, affects = 'Up Shifting', mod = {index = 13, add = 1}, cost = 125000},
	{category = 'elite', state = 'engine_camshaft', item = 'elite_camshaft', label = 'Elite Camshaft',stat = {duration = 6.3, compression = 2.0, fuelpressure = -2.0, ignition = 2.0}, handling = {'fInitialDriveMaxFlatVel'}, add = 1.02, affects = 'Top Speed', mod = {index = 11, add = 1}, cost = 125000},
	{category = 'elite', state = 'oem_brakes', item = 'elite_brakes', label = 'Elite Brakes', handling = {'fBrakeForce','fHandBrakeForce'}, add = 1.2, affects = 'Brake Power', mod = {index = 12, add = 3}, cost = 125000},
	{category = 'elite', state = 'oem_suspension', item = 'elite_suspension', label = 'Elite Suspension', handling = {'fSuspensionForce','fSuspensionCompDamp','fSuspensionReboundDamp','fSuspensionUpperLimit','fSuspensionLowerLimit','fSuspensionRaise','fSuspensionBiasFront','fAntiRollBarForce','fAntiRollBarBiasFront','fRollCentreHeightFront','fRollCentreHeightRear'}, add = 1.1, affects = 'Suspension', mod = {index = 15, add = 4}, cost = 125000},
	{category = 'elite', state = 'oem_gearbox', item = 'elite_gearbox', label = 'Elite Gearbox', handling = {'nInitialDriveGears','fDriveInertia','fClutchChangeRateScaleUpShift','fClutchChangeRateScaleDownShift'}, add = 1.05, affects = 'Acceleration', mod = {index = 13, add = 1}, cost = 125000},
}

config.upgraderequire = { -- crafting required category for each parts variants --- @category = required category of parts to craft the current parts, @chance = chances of success
	['elite'] = {category = 'oem', chance = 90}, -- ex. elite parts need x5 OEM
	['pro'] =  {category = 'elite', chance = 70},
	['racing'] =  {category = 'pro', chance = 50},
	['ultimate'] =  {category = 'racing', chance = 20},
}

-- Hardcoded Function for materials required for each variants
-- turbo, engineswap, nitro requires Latest renzu_turbo, renzu_engine, renzu_nitro
GetEngineLocals = function()
	local engines = {}
	if GetResourceState('renzu_engine') == 'started' then
		local local_engines = exports.renzu_engine:Engines().Locals
		for k,v in pairs(local_engines) do
			if v.model then
				table.insert(engines,{label = v.name, name = v.model, requires = {steel = 5,aluminum = 5,iron = 5, copper = 5}}) -- requirements for Local Engines Crafting
			end
		end
	end
	return engines
end

GetEngineCustoms = function()
	local engines = {}
	if GetResourceState('renzu_engine') == 'started' then
		local custom_engines = exports.renzu_engine:Engines().Custom
		for k,v in pairs(custom_engines) do
			table.insert(engines,{label = v.label, name = v.soundname, requires = {steel = 25,aluminum = 25,iron = 25, copper = 25}}) -- requirements for Custom Engines Crafting
		end
	end
	return engines
end

GetRecentOptions = function(type,state)
	for k,v in pairs(config.engineupgrades) do
		if v.category == config.upgraderequire[type].category and v.state == state then
			return v.item, config.upgraderequire[type].chance
		end
	end
end

GetCraftableParts = function()
	local parts = {}
	for k,v in pairs(config.engineparts) do
		table.insert(parts,{label = v.label, name = v.item, requires = {steel = 5,aluminum = 5,iron = 5, copper = 5}}) -- requirements for OEM Parts Crafting
	end
	return parts
end

GetCraftableUpgradeParts = function(type)
	local parts = {}
	for k,v in pairs(config.engineupgrades) do
		if type == v.category then
			local item, chance = GetRecentOptions(v.category,v.state)
			local require = {steel = 10,aluminum = 10,iron = 10, copper = 10}
			if item then
				require = {[item] = 5, steel = 10,aluminum = 10,} -- requirements for Upgrade Parts Crafting .. the [item] variable is the recent category ex. racing_pistons requires 5x of pro_pistons
			end
			table.insert(parts,{label = v.label, name = v.item, state = v.state, requires = require, chance = chance, type = 'upgrade'})
		end
	end
	return parts
end

config.crafting = { -- crafting config and requires item
	['engine'] = {
		label = 'Craft Engines',
		coord = vec3(-341.58551025391,-141.34959411621,39.115104675293),
		categories = {
			[1] = {
				items = GetEngineLocals(),
				label = 'Local Engines',
			},
			[2] = {
				items = GetEngineCustoms(),
				label = 'Custom Engines',
			},
		}
	},
	['parts'] = {
		label = 'Craft Engines Parts',
		coord = vec3(-343.77084350586,-140.74291992188,39.026248931885),
		categories = {
			[1] = {items = GetCraftableParts(), label = 'Oem Parts'},
			[2] = {items = GetCraftableUpgradeParts('elite'), label = 'Elite Parts'},
			[3] = {items = GetCraftableUpgradeParts('pro'), label = 'Pro Parts'},
			[4] = {items = GetCraftableUpgradeParts('racing'), label = 'Racing Parts'},
			[5] = {items = GetCraftableUpgradeParts('ultimate'), label = 'Ultimate Parts'},
		}
	},
	['etc'] = {
		label = 'Craft Turbo ,Tires & Advanced parts',
		coord = vec3(-339.31976318359,-142.31146240234,39.177829742432),
		categories = {
			[1] = {
				items = {
					[1] = {name = 'turbostreet', label = 'Street Turbo', requires = {steel = 10,aluminum = 10,iron = 10, copper = 10}},
					[2] = {name = 'turbosports', label = 'Sports Turbo', requires = {steel = 20,aluminum = 20,iron = 20, copper = 20}},
					[3] = {name = 'turboracing', label = 'Racing Turbo', requires = {steel = 40,aluminum = 40,iron = 40, copper = 40}},
					[4] = {name = 'turboultimate', label = 'Ultimate Turbo', requires = {steel = 40,aluminum = 40,iron = 40, copper = 40}},
				},
				label = 'Custom Turbos',
			},
			[2] = {
				items = {
					[1] = {name = 'street_tires', label = 'Street Tires', requires = {rubber = 10, sulfur = 10,steel = 10, polyester = 10}},
					[2] = {name = 'sports_tires', label = 'Sports Tires', requires = {rubber = 20, sulfur = 20,steel = 20, polyester = 20}},
					[3] = {name = 'racing_tires', label = 'Racing Tires', requires = {rubber = 40, sulfur = 40,steel = 40, polyester = 40}},
				},
				label = 'Custom Tires',
			},
			[3] = {
				items = {
					[1] = { label = 'Limited Slip Differential (Front)', name = 'lsdf' ,requires = {steel = 10,aluminum = 10,iron = 10, copper = 10}},
					[2] = { label = 'Limited Slip Differential (Rear)', name = 'lsdr', requires = {steel = 10,aluminum = 10,iron = 10, copper = 10}},
					[3] = { label = 'Traction Control System', name = 'tcs', requires = {steel = 10,aluminum = 10,iron = 10, copper = 10}},
					[4] = { label = 'Stability Control System', name = 'esc', requires = {steel = 10,aluminum = 10,iron = 10, copper = 10}},
					[5] = { label = 'Close Ratio Gears', name = 'closerationgears', requires = {steel = 10,aluminum = 10,iron = 10, copper = 10}},
					[6] = { label = 'CVT Transmission', name = 'cvttranny', requires = {steel = 10,aluminum = 10,iron = 10, copper = 10}},
					[7] = { label = 'Anti-lock braking', name = 'abs', requires = {steel = 10,aluminum = 10,iron = 10, copper = 10}},
					[8] = { label = 'Axle Torsion (Front)', name = 'axletorsionfront', requires = {steel = 10,aluminum = 10,iron = 10, copper = 10}},
					[9] = { label = 'Axle Torsion (Rear)', name = 'axletorsionrear', requires = {steel = 10,aluminum = 10,iron = 10, copper = 10}},
					[10] = { label = 'Axle Solid (Front)', name = 'axlesolidfront', requires = {steel = 10,aluminum = 10,iron = 10, copper = 10}},
					[11] = { label = 'Axle Solid (Rear)', name = 'axlesolidrear', requires = {steel = 10,aluminum = 10,iron = 10, copper = 10}},
					[12] = { label = 'Kinetic Energy Recovery System (KERS)', name = 'kers', requires = {steel = 10,aluminum = 10,iron = 10, copper = 10}},
					[13] = { label = 'Offroad Tune 1', name = 'offroadtune1', requires = {steel = 10,aluminum = 10,iron = 10, copper = 10}},
					[14] = { label = 'Offroad Tune 2', name = 'offroadtune2', requires = {steel = 10,aluminum = 10,iron = 10, copper = 10}},
					[15] = { label = 'Stanced', name = 'stanced', requires = {steel = 10,aluminum = 10,iron = 10, copper = 10}},
					[16] = { label = 'Front Wheel Drive', name = 'frontwheeldrive', requires = {steel = 10,aluminum = 10,iron = 10, copper = 10}},
					[17] = { label = 'Rear Wheel Drive', name = 'rearwheeldrive', requires = {steel = 10,aluminum = 10,iron = 10, copper = 10}},
					[18] = { label = 'All Wheel Drive', name = 'allwheeldrive', requires = {steel = 10,aluminum = 10,iron = 10, copper = 10}},
					[19] = { label = 'Programable ECU', name = 'ecu', requires = {chip = 1,board = 1,copper = 10, steel = 10}},

				},
				label = 'Advanced Parts'
			},
			[4] = {
				items = {
					[1] = {name = 'nitro50shot', label = '50 Shot Nitros', requires = {bottle = 1, methane = 10,steel = 10, water = 1}},
					[2] = {name = 'nitro100shot', label = '100 Shot Nitros', requires = {bottle = 2, methane = 20,steel = 20, water = 20}},
					[3] = {name = 'nitro200shot', label = '200 Shot Nitros', requires = {bottle = 3, methane = 40,steel = 40, water = 40}},
				},
				label = 'NOS',
			},
			[5] = {
				items = {
					[1] = {name = 'repairparts', label = 'Repair Engine Kit', durability = 100, requires = {steel = 10,aluminum = 10,iron = 10, copper = 10}},
				},
				label = 'Repair Engine Parts Kit',
			},
		}
	},
}

config.tires = { -- tires handling @item = item name, @degrade = degrade percent for each MS tick. 
	[1] = {label = 'Street Tires', item = 'street_tires', degrade = 0.01, handling = {fLowSpeedTractionLossMult = 1.1,fTractionLossMult = 1.1,fTractionCurveMin = 1.2, fTractionCurveMax = 1.0, fTractionCurveLateral = 1.25}, cost = 10000},
	[2] = {label = 'Sports Tires', item = 'sports_tires', degrade = 0.02, handling = {fLowSpeedTractionLossMult = 0.9,fTractionLossMult = 0.9,fTractionCurveMin = 1.1, fTractionCurveMax = 1.1, fTractionCurveLateral = 1.0}, cost = 211000},
	[3] = {label = 'Racing Tires', item = 'racing_tires', degrade = 0.03, handling = {fLowSpeedTractionLossMult = 0.65,fTractionLossMult = 0.7,fTractionCurveMin = 1.25, fTractionCurveMax = 1.35, fTractionCurveLateral = 0.7}, cost = 215000},
	[4] = {label = 'Drag Tires', item = 'drag_tires', degrade = 0.1, handling = {fLowSpeedTractionLossMult = 0.7,fTractionLossMult = 2.1,fTractionCurveMin = 1.91, fTractionCurveMax = 0.4, fTractionCurveLateral = 1.4}, cost = 55000},
	[5] = {label = 'Drift Tires', item = 'drift_tires', degrade = 0.2, handling = {fLowSpeedTractionLossMult = 1.0,fTractionLossMult = 1.0,fTractionCurveMin = 1.0, fTractionCurveMax = 1.0, fTractionCurveLateral = 1.0}, cost = 45000},

}

config.drivetrain = {
	[1] = { label = 'FWD', item = 'frontwheeldrive', value = 1.0, cost = 255000 },
	[2] = { label = 'AWD', item = 'allwheeldrive', value = 0.5, cost = 525000 },
	[3] = { label = 'RWD', item = 'rearwheeldrive', value = 0.0, cost = 255000 }
}

 -- @cost amount of parts when purchase
config.extras = { -- do not change unless you know how vehicle flags works for this resource
	[1] = { label = 'Limited Slip Differential (Front)', item = 'lsdf' ,handling = {type = 'CCarHandlingData', name = 'strAdvancedFlags', value = {0,3}}, cost = 25000},
	[2] = { label = 'Limited Slip Differential (Rear)', item = 'lsdr', handling = {type = 'CCarHandlingData', name = 'strAdvancedFlags', value = {1,4}}, cost = 25000},
	[3] = { label = 'Traction Control System', item = 'tcs', handling = {type = 'CCarHandlingData', name = 'strAdvancedFlags', value = {13}}, cost = 25000},
	[4] = { label = 'Stability Control System', item = 'esc', handling = {type = 'CCarHandlingData', name = 'strAdvancedFlags', value = {14}}, cost = 25000},
	[5] = { label = 'Close Ratio Gears', item = 'closerationgears', handling = {type = 'CCarHandlingData', name = 'strAdvancedFlags', value = {21}}, cost = 25000},
	[6] = { label = 'CVT Transmission', item = 'cvttranny', handling = {type = 'CHandlingData', name = 'strHandlingFlags', value = {12}}, cost = 25000},
	[7] = { label = 'Anti-lock braking', item = 'abs', handling = {type = 'CHandlingData', name = 'strModelFlags', value = {4}}, cost = 25000},
	[8] = { label = 'Axle Torsion (Front)', item = 'axletorsionfront', handling = {type = 'CHandlingData', name = 'strModelFlags', value = {16}}, cost = 25000},
	[9] = { label = 'Axle Torsion (Rear)', item = 'axletorsionrear', handling = {type = 'CHandlingData', name = 'strModelFlags', value = {20}}, cost = 25000},
	[10] = { label = 'Axle Solid (Front)', item = 'axlesolidfront', handling = {type = 'CHandlingData', name = 'strModelFlags', value = {17}}, cost = 25000},
	[11] = { label = 'Axle Solid (Rear)', item = 'axlesolidrear', handling = {type = 'CHandlingData', name = 'strModelFlags', value = {21}}, cost = 25000},
	[12] = { label = 'Kinetic Energy Recovery System (KERS)', item = 'kers', handling = {type = 'CHandlingData', name = 'strHandlingFlags', value = {2}}, cost = 25000},
	[13] = { label = 'Offroad Tune 1', item = 'offroadtune1', handling = {type = 'CHandlingData', name = 'strHandlingFlags', value = {20}}, cost = 25000},
	[14] = { label = 'Offroad Tune 2', item = 'offroadtune2', handling = {type = 'CHandlingData', name = 'strHandlingFlags', value = {21}}, cost = 25000},
	[15] = { label = 'Stanced', item = 'stanced', handling = {type = 'CCarHandlingData', name = 'strAdvancedFlags', value = {15,26}}, cost = 25000},

}

config.gears = { -- hugo simones config data. gear 8 are corrected due to probably changes from newer builds ( 2699 tested ), gear 9 untested
	[1] = {0.90},--1
	[2] = {3.33, 0.90},--2
	[3] = {3.33, 1.57, 0.90},--3
	[4] = {3.33, 1.83, 1.22, 0.90},--4
	[5] = {3.33, 1.92, 1.36, 1.05, 0.90},--5
	[6] = {3.33, 1.95, 1.39, 1.09, 0.95, 0.90},--6
	[7] = {4.00, 2.34, 1.67, 1.31, 1.14, 1.08, 0.90},--7
	[8] = {4.025, 2.025, 1.523, 1.314, 1.154, 1.073, 1.0, 0.90},--8
	[9] = {7.70, 4.51, 3.22, 2.52, 2.20, 2.08, 1.73, 1.31, 0.90}--9
}

config.radialoptions = {
	{
	  id = 'Upgrades',
	  label = 'Upgrades',
	  icon = 'wrench',
	  onSelect = function()
		return UpgradePackage()
	  end
	},
	{
	  id = 'Repair',
	  label = 'Repair',
	  icon = 'hammer',
	  onSelect = function()
		return Repair()
	  end
	},
	{
	  id = 'tuning',
	  label = 'Tuning',
	  icon = 'chart-bar',
	  onSelect = function()
		return TuningMenu()
	  end
	},
	{
	  id = 'parts',
	  label = 'Engine Parts',
	  icon = 'cog',
	  onSelect = function()
		return CheckVehicle(true)
	  end
	},
	{
		id = 'performance',
		label = 'Performance',
		icon = 'chart-line',
		onSelect = function()
		  return CheckPerformance(true)
		end
	},
	{
		id = 'seetires',
		label = 'See Tires',
		icon = 'car',
		onSelect = function()
		  return CheckWheels(true)
		end
	},
}

config.drift_handlings = {
	{'fInitialDriveMaxFlatVel',380.000000},
	-- {'fDriveInertia', 3.000000},
	-- {'fInitialDriveForce', 2.200000},
	{'fMass', 700.000000},
	{'fInitialDragCoeff',0.500000},
	{'fPercentSubmerged',85.000000},
	{'vecCentreOfMassOffset', vector3(0.000000,-0.100000,-0.100000)},
	{'vecInertiaMultiplier', vector3(1.200000,1.400000,2.000000)},
	{'fDriveBiasFront',0.000000},
	{'fClutchChangeRateScaleUpShift',51.300000},
	{'fClutchChangeRateScaleDownShift',51.300000},
	--{'fInitialDriveMaxFlatVel',380.000000},
	{'fSteeringLock',55.000000},
	{'fTractionCurveMax',1.040000,0.840000},
	{'fTractionCurveMin',1.200000,1.400000},
	{'fTractionCurveLateral',45.500000},
	{'fTractionSpringDeltaMax',0.110000},
	{'fLowSpeedTractionLossMult',0.200000},
	{'fCamberStiffnesss',0.000000},
	{'fTractionBiasFront',0.420000},
	{'fTractionLossMult',0.950000},
	{'fSuspensionForce',2.200000},
	{'fSuspensionCompDamp',2.200000},
	{'fSuspensionReboundDamp',2.100000},
	{'fSuspensionUpperLimit',0.030000},
	{'fSuspensionLowerLimit',-0.030000},
	{'fSuspensionRaise',-0.000000},
	{'fSuspensionBiasFront',0.550000},
	{'fAntiRollBarForce',0.800000},
	{'fAntiRollBarBiasFront',0.430000},
	{'fRollCentreHeightFront',0.150000},
	{'fRollCentreHeightRear',0.150000},
}

function import(file)
	local name = ('%s.lua'):format(file)
	local content = LoadResourceFile(GetCurrentResourceName(),name)
	local f, err = load(content)
	return f()
end

-- customs items from other resource
config.customItems = {
	[1] = {item = 'turbostreet', cost = 25000},
	[2] = {item = 'turbosports', cost = 25000},
	[3] = {item = 'turboracing', cost = 25000},
	[4] = {item = 'nitro50shot', cost = 25000},
	[5] = {item = 'nitro100shot', cost = 25000},
	[6] = {item = 'nitro200shot', cost = 25000},
}

itemsData = {}
for k,v in pairs(config.engineparts) do
	table.insert(itemsData,v)
end
for k,v in pairs(config.engineupgrades) do
	table.insert(itemsData,v)
end
for k,v in pairs(config.tires) do
	table.insert(itemsData,v)
end
for k,v in pairs(config.drivetrain) do
	table.insert(itemsData,v)
end
for k,v in pairs(config.extras) do
	table.insert(itemsData,v)
end
for k,v in pairs(config.customItems) do
	table.insert(itemsData,v)
end
table.insert(itemsData,{item = 'ecu', cost = 25000})
config.developertune = {
	[1] = { 
		label = 'Physical Attributes',
		icon = 'wrench',
		description = 'These seven values represent the vehicle physical proportions within the game:',
		type = 'PhysicalAttributes',
		handlingname = 'CHandlingData',
		attributes = {
			{ type = "input", label = "fMass",  default = 1.0, description = 'This is the weight of the vehicle in kilograms'},
			{ type = "input", label = "fInitialDragCoeff", default = 1.0, description = ' Increase to simulate aerodynamic drag.'},
			{ type = "input", label = "fDownForceModifier", default = 1.0, description = ' Increase this value to increase the grip at high speed.'},
			{ type = "input", label = "fPopUpLightRotation", default = 1.0, description = 'Overrides the behavior of light_cover bone to allow it to rotate up to the specified angle.'},
			{ type = "input", label = "fPercentSubmerged", default = 1.0, description = 'A percentage of vehicle height in the water before vehicle "floats". '},
			{ type = "textarea", label = "vecCentreOfMassOffset", default = 1.0, description = 'This value shifts the center of gravity in meters from side to side '},
			{ type = "textarea", label = "vecInertiaMultiplier", default = 1.0, description = ''},

		}
	},
	[2] = { 
		label = 'Transmission Attributes',
		icon = 'wrench',
		description = 'These values describe the vehicle straight line performance.',
		type = 'Transmission',
		handlingname = 'CHandlingData',
		attributes = {
			{ type = "input", label = "fDriveBiasFront",  default = 1.0, description = 'This value is used to determine whether a vehicle is front, rear, or four wheel drive.'},
			{ type = "number", label = "nInitialDriveGears", default = 1.0, description = 'How many forward speeds a transmission contains.'},
			{ type = "input", label = "fInitialDriveForce", default = 1.0, description = 'This value specifies the drive force of the car, at the wheels.'},
			{ type = "input", label = "fDriveInertia", default = 1.0, description = 'Describes how fast an engine will rev.'},
			{ type = "input", label = "fClutchChangeRateScaleUpShift", default = 1.0, description = 'Clutch speed multiplier on up shifts, bigger number = faster shifts.'},
			{ type = "input", label = "fClutchChangeRateScaleDownShift", default = 1.0, description = 'Clutch speed multiplier on down shifts, bigger number = faster shifts.'},
			{ type = "input", label = "fInitialDriveMaxFlatVel", default = 1.0, description = 'Determines the speed at redline in top gear; Controls the final drive of the vehicles gearbox.'},
			{ type = "input", label = "fBrakeForce", default = 1.0, description = 'Multiplies the games calculation of deceleration. Bigger number = harder braking'},
			{ type = "input", label = "fBrakeBiasFront", default = 1.0, description = 'This controls the distribution of braking force between the front and rear axles.'},
			{ type = "input", label = "fHandBrakeForce", default = 1.0, description = 'Braking power for handbrake. Bigger number = harder braking'},
			{ type = "input", label = "fSteeringLock", default = 1.0, description = 'This value is a multiplier of the games calculation of the angle a steer wheel will turn while at full turn.'},
		}
	},
	[3] = { 
		label = 'Wheel Traction Attributes',
		icon = 'wrench',
		description = 'The following attributes describe how the vehicle will behave dynamically, from negotiating corners to acceleration and deceleration',
		type = 'Transmission',
		handlingname = 'CHandlingData',
		attributes = {
			{ type = "input", label = "fTractionCurveMax",  default = 1.0, description = 'Cornering grip of the vehicle as a multiplier of the tire surface friction.'},
			{ type = "input", label = "fTractionCurveMin", default = 1.0, description = 'Accelerating/braking grip of the vehicle as a multiplier of the tire surface friction. '},
			{ type = "input", label = "fTractionCurveLateral", default = 1.0, description = 'Shape of lateral traction curve (peak traction position in degrees). Lower values make the vehicles grip more responsive but less forgiving to loss of traction.'},
			{ type = "input", label = "fTractionSpringDeltaMax", default = 1.0, description = 'Max distance of the lateral sidewall travel. Unit: meter. A force will pull the vehicle in the opposite direction of the lateral travel'},
			{ type = "input", label = "fLowSpeedTractionLossMult", default = 1.0, description = 'How much traction is reduced at low speed, 0.0 means normal traction. It affects mainly car burnout '},
			{ type = "input", label = "fCamberStiffnesss", default = 1.0, description = 'How much the vehicle is pushed towards its roll direction. Road camber also affects roll and applied forces.'},
			{ type = "input", label = "fTractionBiasFront", default = 1.0, description = 'Determines the distribution of traction from front to rear.'},
			{ type = "input", label = "fTractionLossMult", default = 1.0, description = 'How much is traction affected by material grip differences from 1.0. Basically it affects how much grip is changed when driving on asphalt and mud'},
		}
	},
	[4] = { 
		label = 'Suspension Attributes',
		type = 'suspension',
		icon = 'car',
		description = 'Adjust Your vehicle suspension setting',
		handlingname = 'CHandlingData',
		attributes = {
			{ type = "input", label = "fSuspensionForce",  default = 1.0, description = ' Affects how strong suspension is. Can help if car is easily flipped over when turning.'},
			{ type = "input", label = "fSuspensionCompDamp", default = 1.0, description = 'Damping during strut compression. Bigger = stiffer.'},
			{ type = "input", label = "fSuspensionReboundDamp", default = 1.0, description = 'Damping during strut rebound. Bigger = stiffer'},
			{ type = "input", label = "fSuspensionUpperLimit", default = 1.0, description = 'Visual limit... how far can wheels move up / down from original position'},
			{ type = "input", label = "fSuspensionLowerLimit", default = 1.0, description = 'Visual limit... how far can wheels move up / down from original position'},
			{ type = "input", label = "fSuspensionRaise", default = 1.0, description = 'The amount that the suspension raises the body off the wheels.'},
			{ type = "input", label = "fSuspensionBiasFront", default = 1.0, description = 'Force damping scale front/back.'},
			{ type = "input", label = "fAntiRollBarForce", default = 1.0, description = 'The spring constant that is transmitted to the opposite wheel when under compression larger numbers are a larger force. Larger Numbers = less body roll'},
			{ type = "input", label = "fAntiRollBarBiasFront", default = 1.0, description = 'The bias between front and rear for the antiroll bar(0 front, 1 rear)'},
			{ type = "input", label = "fRollCentreHeightFront", default = 1.0, description = 'The roll center height for the front axle, from the bottom of the model (road), in meters.'},
			{ type = "input", label = "fRollCentreHeightRear", default = 1.0, description = 'The roll center height for the rear axle, from the bottom of the model (road), in meters.'},
		}
	},
	[5] = { 
		label = 'Damage Attributes',
		type = 'Damage',
		icon = 'car',
		description = 'The following attributes dictate how the vehicle will react to damaging effects.',
		handlingname = 'CHandlingData',
		attributes = {
			{ type = "input", label = "fCollisionDamageMult",  default = 1.0, description = 'Multiplies the games calculation of damage to the vehicle through collision, causing gas tank and wheels to catch fire.'},
			{ type = "input", label = "fWeaponDamageMult", default = 1.0, description = 'Multiplies the games calculation of damage to the vehicle through weapon damage.'},
			{ type = "input", label = "fDeformationDamageMult", default = 1.0, description = 'Multiplies the games calculation of deformation-causing damage.'},
			{ type = "input", label = "fEngineDamageMult", default = 1.0, description = 'Multiplies the games calculation of damage to the engine, causing explosion or engine failure.'},
			{ type = "input", label = "fPetrolTankVolume", default = 1.0, description = 'Amount of petrol that will leak after shooting the vehicles petrol tank. Also used by some fuel-usage scripts.'},
			{ type = "input", label = "fOilVolume", default = 1.0, description = 'Black smoke time before engine dies?'},
			{ type = "input", label = "fPetrolConsumptionRate", default = 1.0, description = ''},
		}
	},
	[6] = { 
		label = 'Vehicle Flags',
		type = 'Flags',
		icon = 'car',
		description = 'CHandlingData Flags',
		handlingname = 'CHandlingData',
		attributes = {
			{ type = "number", label = "strModelFlags",  default = 1.0, description = 'Affects model-related functions.'},
			{ type = "number", label = "strHandlingFlags", default = 1.0, description = 'Affects handling-related functions.'},
			{ type = "number", label = "strDamageFlags", default = 1.0, description = 'Indicates the doors that are nonbreakable.'},
		}
	},
	[7] = { 
		label = 'SubHandlingData',
		type = 'SubHandlingData',
		icon = 'car',
		description = 'CCarHandlingData Attributes',
		handlingname = 'CCarHandlingData',
		attributes = {
			{ type = "input", label = "fBackEndPopUpCarImpulseMult",  default = 1.0, description = '.'},
			{ type = "input", label = "fBackEndPopUpBuildingImpulseMult", default = 1.0, description = ''},
			{ type = "input", label = "fBackEndPopUpMaxDeltaSpeed", default = 1.0, description = ''},
			{ type = "input", label = "fToeFront", default = 1.0, description = 'Adjusts the toe of the vehicles front wheels. '},
			{ type = "input", label = "fToeRear", default = 1.0, description = 'Adjusts the toe of the vehicles rear wheels.'},
			{ type = "input", label = "fCamberFront", default = 1.0, description = 'Adjusts the camber of the vehicles front wheels. '},
			{ type = "input", label = "fCamberRear", default = 1.0, description = 'Adjusts the camber of the vehicles rear wheels.'},
			{ type = "input", label = "fCastor", default = 1.0, description = 'Adjusts the caster angle of the vehicle.'},
			{ type = "input", label = "fEngineResistance", default = 1.0, description = 'Adjusted by several vehicles since the addition of this parameter, however there are no known or observed effects.'},
			{ type = "input", label = "fMaxDriveBiasTransfer", default = 1.0, description = 'Transfers the drive force from the slipping wheels to the less-driven wheels. Affects differentials'},
			{ type = "input", label = "fJumpForceScale", default = 1.0, description = 'Adjusts the force with which vehicles with a jump boost are boosted. The higher the value, the higher the jump.'},
			{ type = "input", label = "fIncreasedRammingForceScale", default = 1.0, description = 'Increase Ramming Force.'},
			{ type = "number", label = "strAdvancedFlags", default = 1.0, description = 'Car advanced flags. Infamous for their original application having negative effects on certain vehicles.'},
		}
	},
}
if config.sandboxmode then
	config.tuningorig = config.tuningmenu
	config.tuningmenu = config.developertune
end
