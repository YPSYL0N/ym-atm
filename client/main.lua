ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		
		local coords, letSleep = GetEntityCoords(PlayerPedId()), true

		for k,v in pairs(Config.Zones) do
			local Pos = vector3(v.x, v.y, v.z)
			if #(coords - Pos) < 2.0 then
				DrawText3Ds(v.x, v.y, v.z, Config.Text)
				if IsControlJustPressed(0, 46) then
					OpenCraftMenu()
				end
			end
		end
	end
end)



function OpenCraftMenu()
		local elements = {
			{label = "Rob the ATM",  value = 'atmrob'}
		}

		ESX.UI.Menu.CloseAll()

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'atmmenu', {
			title    = "YM-ATM",
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			menu.close()

			if data.current.value == 'atmrob' then
				local playerPed = PlayerPedId()
				TaskStartScenarioInPlace(playerPed, 'WORLD_HUMAN_TOURIST_MOBILE', 0, true)
				exports['pogressBar']:drawBar(3000, 'You are hacking into the ATM!')
				Citizen.Wait(3000)
				TriggerEvent("utk_fingerprint:Start", Config.Levels, Config.Attempts, Config.Time, function(outcome, reason)
					if outcome == true then -- reason will be nil if outcome is true
						exports['mythic_notify']:DoHudText('success', 'You hacked the ATM!')
						Citizen.Wait(5000)
						exports['mythic_notify']:DoHudText('error', 'Someone saw you! Police were alerted!')
						ClearPedTasksImmediately(playerPed)
						TaskStartScenarioInPlace(playerPed, 'PROP_HUMAN_BUM_BIN', 0, true)
						exports['pogressBar']:drawBar(10000, 'You are taking money from the ATM!')
						Citizen.Wait(10000)
						ClearPedTasksImmediately(playerPed)
						TriggerServerEvent('ym-atm:penize')
					elseif outcome == false then
						exports['mythic_notify']:DoHudText('error', 'You failed! Police were alerted!')
						ClearPedTasksImmediately(playerPed)
					end
				end)
			end
		end, function(data, menu)
			menu.close()

			CurrentAction     = 'atmmenu'
			CurrentActionMsg  = "YM-ATM"
			CurrentActionData = {}
		end)
end

------------------------------------------
-- 3DTEXT --
------------------------------------------
function DrawText3Ds(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.35, 0.50)
	SetTextOutline()
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
end



print('Simple and reliable ATM ROBBING system made by ManTy#0001 & ypsylon.#0069')