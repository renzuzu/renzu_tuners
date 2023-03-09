CreateRadialMenu = function()
	if not lib.addRadialItem then return end
	lib.addRadialItem({
		id = 'tuners_menu',
		icon = 'chart-bar',
		label = 'Tuners',
		menu = 'tuners_menus',
	})
	lib.registerRadial({
		id = 'tuners_menus',
		items = config.radialoptions
	})
end

HasRadialMenu = function()
	if not lib.addRadialItem then return end
	lib.removeRadialItem('tuners_menu')
	if not config.job or PlayerData?.job?.name == config.job then
		return CreateRadialMenu()
	end
end
