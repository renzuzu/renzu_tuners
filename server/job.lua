-- this functions for Job Society/Management

GetJobMoney = function(job)
    local value = 0
    if GetResourceState('renzu_jobs') == 'started' then
		return exports.renzu_jobs:JobMoney(job).money
	elseif GetResourceState('qb-management') == 'started' then
		return exports['qb-management']:GetAccount(job)
	elseif GetResourceState('es_extended') == 'started' then
		local wait = promise:new()
		TriggerEvent('esx_addonaccount:getSharedAccount', 'society_'..job, function(account)
			wait:resolve(account.money)
		end)
		return Citizen.Await(wait)
    end
end

format_int = function(n)
	return tostring(math.floor(n)):reverse():gsub("(%d%d%d)","%1,"):gsub(",(%-?)$","%1"):reverse()
end

lib.callback.register('renzu_tuners:getJobMoney', function(src,job)
	if not job then return 0 end
	return format_int(GetJobMoney(job) or 0)
end)

RemoveJobMoney = function(job,amount)
	if GetResourceState('renzu_jobs') == 'started' then
		return exports.renzu_jobs:removeMoney(amount,job,nil,'money',true)
    elseif GetResourceState('es_extended') == 'started' then
        TriggerEvent('esx_addonaccount:getSharedAccount', 'society_'..job, function(account)
			account.removeMoney(amount)
        end)
    else
		return exports['qb-management']:RemoveMoney(job,amount)
    end
end