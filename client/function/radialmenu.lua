CreateRadialMenu = function()
	if not lib.addRadialItem then return end
	return lib.addRadialItem(config.radialoptions)
end

HasRadialMenu = function()
	if not lib.addRadialItem then return end
	if PlayerData?.job?.name == config.job then
		return CreateRadialMenu()
	else
		for k,v in pairs(config.radialoptions) do
			lib.removeRadialItem(v.id)
		end
	end
end
