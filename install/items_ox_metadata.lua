-- ox_inventory
-- this does not include other variant upgrades. default item will be used for metadata. eg. engine_camshaft -> racing_camshaft

['repairparts'] = {
	label = 'Repair Engine Parts',
	weight = 250,
	stack = false,
	close = true,
},

['street_tires'] = {
	label = 'Street Tires',
	weight = 250,
	stack = true,
	close = true,
	client = {
		anim = { dict = 'mini@repair', clip = 'fixing_a_player' },
		usetime = 5500,
		export = 'renzu_tuners.useItem'
	}
},
['sports_tires'] = {
	label = 'Sports Tires',
	weight = 250,
	stack = true,
	close = true,
	client = {
		anim = { dict = 'mini@repair', clip = 'fixing_a_player' },
		usetime = 5500,
		export = 'renzu_tuners.useItem'
	}
},
['racing_tires'] = {
	label = 'Racing Tires',
	weight = 250,
	stack = true,
	close = true,
	client = {
		anim = { dict = 'mini@repair', clip = 'fixing_a_player' },
		usetime = 5500,
		export = 'renzu_tuners.useItem'
	}
},
['drag_tires'] = {
	label = 'Drag Tires',
	weight = 250,
	stack = true,
	close = true,
	client = {
		anim = { dict = 'mini@repair', clip = 'fixing_a_player' },
		usetime = 5500,
		export = 'renzu_tuners.useItem'
	}
},

['transmition_clutch'] = {
	label = 'OEM Transmission Clutch',
	weight = 100,
	stack = true,
	client = {
		
		anim = { dict = 'mini@repair', clip = 'fixing_a_ped' },
		usetime = 5500,
		export = 'renzu_tuners.useItem'

	}
},

['engine_flywheel'] = {
	label = 'OEM Flywheel',
	weight = 100,
	stack = true,
	client = {
		
		anim = { dict = 'mini@repair', clip = 'fixing_a_ped' },
		usetime = 5500,
		export = 'renzu_tuners.useItem'

	}
},

['engine_oil'] = {
	label = 'OEM Engine Oil',
	weight = 100,
	stack = true,
	client = {
		
		anim = { dict = 'mini@repair', clip = 'fixing_a_ped' },
		usetime = 5500,
		export = 'renzu_tuners.useItem'

	}
},

['engine_sparkplug'] = {
	label = 'Sparkplugs Kit',
	weight = 50,
	stack = true,
	client = {
		--status = { hunger = -10000, thirst = -10000, stress = -100000 },
		anim = { dict = 'mini@repair', clip = 'fixing_a_ped' },
		usetime = 5500,
		export = 'renzu_tuners.useItem'

	}
},

['engine_gasket'] = {
	label = 'OEM Head Gasket Kit',
	weight = 50,
	stack = true,
	client = {
		--status = { hunger = -10000, thirst = -10000, stress = -100000 },
		anim = { dict = 'mini@repair', clip = 'fixing_a_ped' },
		usetime = 5500,
		export = 'renzu_tuners.useItem'

	}
},

['engine_airfilter'] = {
	label = 'OEM Intake Air Filter',
	weight = 50,
	stack = true,
	client = {
		--status = { hunger = -20000, thirst = -30000, stress = -100000 },
		anim = { dict = 'mini@repair', clip = 'fixing_a_ped' },
		usetime = 5500,
		export = 'renzu_tuners.useItem'

	}
},

['engine_fuelinjector'] = {
	label = 'OEM Fuel Injectors',
	weight = 150,
	stack = true,
	client = {
		--status = { hunger = -20000, thirst = -30000, stress = -100000 },
		anim = { dict = 'mini@repair', clip = 'fixing_a_ped' },
		usetime = 5500,
		export = 'renzu_tuners.useItem'

	}
},
['engine_pistons'] = {
	label = 'OEM Pistons Kit',
	weight = 350,
	stack = true,
	client = {
		
		anim = { dict = 'mini@repair', clip = 'fixing_a_ped' },
		usetime = 5500,
		export = 'renzu_tuners.useItem'

	}
},

['engine_connectingrods'] = {
	label = 'OEM Connecting Rods Kit',
	weight = 350,
	stack = true,
	client = {
		
		anim = { dict = 'mini@repair', clip = 'fixing_a_ped' },
		usetime = 5500,
		export = 'renzu_tuners.useItem'

	}
},

['engine_valves'] = {
	label = 'OEM Head Valves Kit',
	weight = 350,
	stack = true,
	client = {
		
		anim = { dict = 'mini@repair', clip = 'fixing_a_ped' },
		usetime = 5500,
		export = 'renzu_tuners.useItem'

	}
},

['engine_block'] = {
	label = 'OEM Block',
	weight = 350,
	stack = true,
	client = {
		
		anim = { dict = 'mini@repair', clip = 'fixing_a_ped' },
		usetime = 5500,
		export = 'renzu_tuners.useItem'

	}
},

['engine_crankshaft'] = {
	label = 'OEM CrankShaft',
	weight = 350,
	stack = true,
	client = {
		
		anim = { dict = 'mini@repair', clip = 'fixing_a_ped' },
		usetime = 5500,
		export = 'renzu_tuners.useItem'
	}
},

['engine_camshaft'] = {
	label = 'OEM Camshaft',
	weight = 350,
	stack = true,
	client = {
		
		anim = { dict = 'mini@repair', clip = 'fixing_a_ped' },
		usetime = 5500,
		export = 'renzu_tuners.useItem'
	}
},



 

['ecu'] = {
	label = 'ecu',
	weight = 20,
	stack = true,
	close = true,
	description = nil,
},

['drift_tires'] = {
	label = 'Drift Tires',
	weight = 250,
	stack = true,
	close = true,
	client = {
		anim = { dict = 'mini@repair', clip = 'fixing_a_player' },
		usetime = 5500,
		export = 'renzu_tuners.useItem'
	}
},


['lsdf'] = {
	label = 'Limited Slip Differential (Front)',
	weight = 250,
	stack = true,
	close = true,
	client = {
		anim = { dict = 'mini@repair', clip = 'fixing_a_player' },
		usetime = 5500,
		export = 'renzu_tuners.useItem'
	}
},

['lsdr'] = {
	label = 'Limited Slip Differential (Rear)',
	weight = 250,
	stack = true,
	close = true,
	client = {
		anim = { dict = 'mini@repair', clip = 'fixing_a_player' },
		usetime = 5500,
		export = 'renzu_tuners.useItem'
	}
},

['tcs'] = {
	label = 'Traction Control System (TCS)',
	weight = 250,
	stack = true,
	close = true,
	client = {
		anim = { dict = 'mini@repair', clip = 'fixing_a_player' },
		usetime = 5500,
		export = 'renzu_tuners.useItem'
	}
},

['esc'] = {
	label = 'Stability Control System (ESC)',
	weight = 250,
	stack = true,
	close = true,
	client = {
		anim = { dict = 'mini@repair', clip = 'fixing_a_player' },
		usetime = 5500,
		export = 'renzu_tuners.useItem'
	}
},

['closerationgears'] = {
	label = 'Close Ratio Gears',
	weight = 250,
	stack = true,
	close = true,
	client = {
		anim = { dict = 'mini@repair', clip = 'fixing_a_player' },
		usetime = 5500,
		export = 'renzu_tuners.useItem'
	}
},

['cvttranny'] = {
	label = 'CVT Transmission',
	weight = 250,
	stack = true,
	close = true,
	client = {
		anim = { dict = 'mini@repair', clip = 'fixing_a_player' },
		usetime = 5500,
		export = 'renzu_tuners.useItem'
	}
},

['abs'] = {
	label = 'Anti-lock braking System',
	weight = 250,
	stack = true,
	close = true,
	client = {
		anim = { dict = 'mini@repair', clip = 'fixing_a_player' },
		usetime = 5500,
		export = 'renzu_tuners.useItem'
	}
},

['axletorsionfront'] = {
	label = 'Axle Torsion (Front)',
	weight = 250,
	stack = true,
	close = true,
	client = {
		anim = { dict = 'mini@repair', clip = 'fixing_a_player' },
		usetime = 5500,
		export = 'renzu_tuners.useItem'
	}
},

['axletorsionrear'] = {
	label = 'Axle Torsion (Rear)',
	weight = 250,
	stack = true,
	close = true,
	client = {
		anim = { dict = 'mini@repair', clip = 'fixing_a_player' },
		usetime = 5500,
		export = 'renzu_tuners.useItem'
	}
},

['axlesolidfront'] = {
	label = 'Axle Solid (Front)',
	weight = 250,
	stack = true,
	close = true,
	client = {
		anim = { dict = 'mini@repair', clip = 'fixing_a_player' },
		usetime = 5500,
		export = 'renzu_tuners.useItem'
	}
},

['axlesolidrear'] = {
	label = 'Axle Solid (Rear)',
	weight = 250,
	stack = true,
	close = true,
	client = {
		anim = { dict = 'mini@repair', clip = 'fixing_a_player' },
		usetime = 5500,
		export = 'renzu_tuners.useItem'
	}
},

['kers'] = {
	label = 'Kinetic Energy Recovery System (KERS)',
	weight = 250,
	stack = true,
	close = true,
	client = {
		anim = { dict = 'mini@repair', clip = 'fixing_a_player' },
		usetime = 5500,
		export = 'renzu_tuners.useItem'
	}
},

['offroadtune1'] = {
	label = 'Offroad Tune 1',
	weight = 250,
	stack = true,
	close = true,
	client = {
		anim = { dict = 'mini@repair', clip = 'fixing_a_player' },
		usetime = 5500,
		export = 'renzu_tuners.useItem'
	}
},

['offroadtune2'] = {
	label = 'Offroad Tune 2',
	weight = 250,
	stack = true,
	close = true,
	client = {
		anim = { dict = 'mini@repair', clip = 'fixing_a_player' },
		usetime = 5500,
		export = 'renzu_tuners.useItem'
	}
},

['stanced'] = {
	label = 'Stanced Tune',
	weight = 250,
	stack = true,
	close = true,
	client = {
		anim = { dict = 'mini@repair', clip = 'fixing_a_player' },
		usetime = 5500,
		export = 'renzu_tuners.useItem'
	}
},

['frontwheeldrive'] = {
	label = 'Front Wheel Drivetrain',
	weight = 250,
	stack = true,
	close = true,
	client = {
		anim = { dict = 'mini@repair', clip = 'fixing_a_player' },
		usetime = 5500,
		export = 'renzu_tuners.useItem'
	}
},

['allwheeldrive'] = {
	label = 'All Wheel Drivetrain',
	weight = 250,
	stack = true,
	close = true,
	client = {
		anim = { dict = 'mini@repair', clip = 'fixing_a_player' },
		usetime = 5500,
		export = 'renzu_tuners.useItem'
	}
},

['rearwheeldrive'] = {
	label = 'Rear Wheel Drivetrain',
	weight = 250,
	stack = true,
	close = true,
	client = {
		anim = { dict = 'mini@repair', clip = 'fixing_a_player' },
		usetime = 5500,
		export = 'renzu_tuners.useItem'
	}
},

['oem_brakes'] = {
	label = 'OEM Brakes',
	weight = 250,
	stack = true,
	close = true,
	client = {
		anim = { dict = 'mini@repair', clip = 'fixing_a_player' },
		usetime = 5500,
		export = 'renzu_tuners.useItem'
	}
},

['oem_suspension'] = {
	label = 'OEM Suspension',
	weight = 250,
	stack = true,
	close = true,
	client = {
		anim = { dict = 'mini@repair', clip = 'fixing_a_player' },
		usetime = 5500,
		export = 'renzu_tuners.useItem'
	}
},

['oem_gearbox'] = {
	label = 'OEM Gear Box',
	weight = 250,
	stack = true,
	close = true,
	client = {
		anim = { dict = 'mini@repair', clip = 'fixing_a_player' },
		usetime = 5500,
		export = 'renzu_tuners.useItem'
	}
},

['rubber'] = {
	label = 'Rubber',
	weight = 20,
	stack = true,
	close = true,
	description = nil,
},
['sulfur'] = {
	label = 'Sulfur',
	weight = 20,
	stack = true,
	close = true,
	description = nil,
},
['steel'] = {
	label = 'Steel',
	weight = 20,
	stack = true,
	close = true,
	description = nil,
},
['polyester'] = {
	label = 'Polyester',
	weight = 20,
	stack = true,
	close = true,
	description = nil,
},
['bottle'] = {
	label = 'Bottle',
	weight = 20,
	stack = true,
	close = true,
	description = nil,
},
['methane'] = {
	label = 'Methane',
	weight = 20,
	stack = true,
	close = true,
	description = nil,
},
['chip'] = {
	label = 'Chip',
	weight = 20,
	stack = true,
	close = true,
	description = nil,
},
['board'] = {
	label = 'Board',
	weight = 20,
	stack = true,
	close = true,
	description = nil,
},

['copper'] = {
	label = 'copper',
	weight = 20,
	stack = true,
},

['iron'] = {
	label = 'iron',
	weight = 20,
	stack = true,
},

['aluminum'] = {
	label = 'aluminum',
	weight = 20,
	stack = true,
},