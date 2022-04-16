ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('ym-atm:penize')
	AddEventHandler('ym-atm:penize', function()
	local source  = source
	local xPlayer  = ESX.GetPlayerFromId(source)
	xPlayer.addMoney(1000)

end)


