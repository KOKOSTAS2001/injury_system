local hurt = false
local player = PlayerPedId()
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000) -- We can lower this for better experience but it costs performance
		
		-- Dont recharge health for rp, you can comment 9-13 lines if you dont want them

		if GetEntityHealth(GetPlayerPed(-1)) <= 150 then
			SetPlayerHealthRechargeMultiplier(PlayerId(), 0.0)
		else
			SetPlayerHealthRechargeMultiplier(PlayerId(), 1.0)
		end

		-- When player has 35% health he cant take cover and he begins to hurt
		-- If player has more than 35% health and lower 50% he will not recharge health but he can do anything
		-- If player has 0% health which means he is dead, the sound stop 

		if GetEntityHealth(GetPlayerPed(-1)) <= 135 and GetEntityHealth(GetPlayerPed(-1)) > 0 then
			SetPlayerCanUseCover(PlayerId(), false)
			setHurt()
		elseif hurt and GetEntityHealth(GetPlayerPed(-1)) > 135 then
			setNotHurt()
			showNotHurt()
			StopScreenEffect('DrugsDrivingIn')
            StopScreenEffect('Dont_tazeme_bro')
			StopScreenEffect('MP_race_crash')
			SetPlayerCanUseCover(PlayerId(), true)
		elseif GetEntityHealth(GetPlayerPed(-1)) == 0 then
			DisplayNotification("NEKROS")
			TriggerEvent('Sound:One', 'breathing', 0.0)
			
		end
	end
end)

function setHurt()
	hurt = true
	RequestAnimSet("move_m@injured")
	SetPedMovementClipset(GetPlayerPed(-1), "move_m@injured", true)
	StartScreenEffect('DrugsDrivingIn', 0, true)
	StartScreenEffect('Dont_tazeme_bro', 0, true)
	StartScreenEffect('MP_race_crash', 0, true)

	--Here you can also trigger anything else but in this case i trigger one sound
	TriggerEvent('Sound:One', 'breathing', 0.5)
	showHurt()
end
 
function showHurt()
	DisplayNotification("AIMORAGEIS.")
	Citizen.Wait(5000)
end

-- Every 50 seconds player will lose health, trying to simulate roleplay
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(50000)
		if hurt then
			ApplyDamageToPed(GetPlayerPed(-1), 1, false)
		end
	end
end)

function DisplayNotification( text )
    SetNotificationTextEntry( "STRING" )
    AddTextComponentString( text )
    DrawNotification( false, false )
end

function showNotHurt()
	DisplayNotification("IATREUTIKES")
end

function setNotHurt()
	hurt = false
	ResetPedMovementClipset(GetPlayerPed(-1))
	ResetPedWeaponMovementClipset(GetPlayerPed(-1))
	ResetPedStrafeClipset(GetPlayerPed(-1))
end