-- C O N F I G --
local companyName = "Tacoma Towing"
local deleteLastTruck = true --Deletes the last spawned truck.
local spawnDistance = 300, 600 	--	Default 200
							---								---
local drivingStyle = 786603  	--	**786603  - "Normal" - Default**
								--	**1074528293 - "Rushed"**
								--	**2883621 - "Ignore Lights"**
								--	**5 - "Sometimes Overtake Traffic"**
								--	**Customize Driving Style: https://vespura.com/drivingstyle/

local towDriverQuoteOfTheDay = {"Howdy partner! I'll get it towed.","Do you even lift bro? Because i do.","You called the right guy, because i got puns from head to tow.","Tow'nt worry about it, i'll get it towed!","I wont charge you a arm and a leg! I only want your tows.","You want too hook up some time?","I hate my job.","Sorry i took so long!","We have some of the best hookers in town!","Sorry i took so long.","There ya go!","Take care.","That will look good in the impound!","Fuck you.", "I got it!", ("Thanks for using " .. companyName .. "!"), "It will be at the compound."}
								
-- Register a network event 
RegisterNetEvent('wk:spawnTow')
RegisterNetEvent('wk:cancelTow')



-- The distance to check in front of the player for a vehicle
-- Distance is in GTA units, which are quite big  
local distanceToCheck = 5.0

enroute = false
onscene = false
cleartask = false
AddEventHandler( 'wk:spawnTow', function()
	local spawnDistance = math.random(spawnDistance * -1, spawnDistance)
	local player = GetPlayerPed(-1)
	local playerPos = GetEntityCoords(player)
	local pmodels = {"mp_m_waremech_01"}
	local vehicles = {"towtruck2"}
	local driver = GetHashKey(pmodels[math.random(#pmodels)])
	local vehiclehash = GetHashKey(vehicles[math.random(#vehicles)])
    local inFrontOfPlayer = GetOffsetFromEntityInWorldCoords(player, 0.0, distanceToCheck, 0.0)
	RequestModel(vehiclehash)
	RequestModel(driver)
	
	while not HasModelLoaded(vehiclehash) and RequestModel(driver) do
		RequestModel(vehiclehash)
		RequestModel(driver)
		Citizen.Wait(0)
	end
	
	if IsPedSittingInAnyVehicle(player) then 
        targetVeh = GetVehiclePedIsIn(player, false)
	else
		targetVeh = GetVehicleInDirection(playerPos, inFrontOfPlayer)
	end
	
	if DoesEntityExist(vehicle) and deleteLastTruck == true then
		SetEntityAsMissionEntity(vehicle)
		SetEntityAsMissionEntity(driver)
		SetEntityAsMissionEntity(towedVeh)
		
		DeleteEntity(vehicle)
		DeleteEntity(driver)
		DeleteEntity(towedVeh)
	end
	
	if DoesEntityExist(targetVeh) then
	TriggerEvent('radio')
		local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), false))
		vehicle = CreateVehicle(vehiclehash, playerPos.x + spawnDistance, playerPos.y + spawnDistance, playerPos.z - 190, 180.0, true, true)
		local vehiclehash = GetHashKey(vehicle)
		
			Wait(5000)
		
		driver = CreatePed(26, driver , GetEntityCoords(vehicle) + 2, 0.0, true, true)
		local vehpos = GetEntityCoords(targetVeh)
		SetPedIntoVehicle(driver, vehicle, -1)
		TaskVehicleDriveToCoord(driver, vehicle, vehpos.x, vehpos.y, vehpos.z, 17.0, 0, vehiclehash, drivingStyle, 1.0, true)
		SetVehicleFixed(vehicle)
		SetVehicleOnGroundProperly(vehicle)
		if DoesEntityExist(driver) and DoesEntityExist(vehicle) then
		SetEntityAsMissionEntity(driver, true, true)
		towblip = AddBlipForEntity(vehicle)
		SetBlipColour(towblip, 1)
		SetBlipFlashes(towblip, true)
		
		local distanceToTow = GetDistanceBetweenCoords(GetEntityCoords(vehicle), GetEntityCoords(targetVeh))
		
		if distanceToTow < 100 then
			eta = '~g~1 Mike'
		elseif distanceToTow < 300 then
			eta = '~g~2 Mikes'
		elseif distanceToTow < 500 then
			eta = '~o~3 Mikes'
		elseif distanceToTow > 500 then
			eta = '~r~5 Mikes'
		end
		
		ShowNotification("A tow truck has been dispatched to your location. Thanks for using ~y~" .. companyName .. "~w~\nETA: " .. eta)
		enroute = true
		while (enroute) do
			Citizen.Wait(300)
			local distanceToVeh = GetDistanceBetweenCoords(GetEntityCoords(vehicle), GetEntityCoords(targetVeh), 1)
			SetEntityInvincible(vehicle, true)
			SetEntityInvincible(driver, true)
				if distanceToVeh <= 15 then
					SetVehicleIndicatorLights(vehicle, 1, true)
					SetVehicleIndicatorLights(vehicle, 2, true)
					TaskVehicleTempAction(driver, vehicle, 27, 5000)
					Wait(5000)
					AttachEntityToEntity(targetVeh, vehicle, 20, -0.5, -5.0, 1.0, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
					targetVeh = towedVeh
					SetDriveTaskDrivingStyle(vehicle, 786603)
					TaskVehicleDriveWander(driver, vehicle, 17.0, drivingStyle)
					SetVehicleSiren(vehicle, true)
					ShowNotification("~o~Tow Driver:~w~ " .. towDriverQuoteOfTheDay[math.random(#towDriverQuoteOfTheDay)])
					SetEntityAsNoLongerNeeded(vehicle)
					enroute = false
					towblip = RemoveBlip(towblip)
					SetVehicleIndicatorLights(vehicle, 1, true)
					SetVehicleIndicatorLights(vehicle, 2, true)
					SetEntityInvincible(vehicle, true)
					SetEntityInvincible(driver, true)
					SetEntityAsNoLongerNeeded(vehicle)
					SetEntityAsNoLongerNeeded(driver)
					SetEntityAsNoLongerNeeded(targetVeh)
				end
			end
		end
	else
	ShowNotification("No vehicle found!")
	end
end)

AddEventHandler( 'wk:cancelTow', function()
	if enroute == true then
		ShowNotification("Tow Truck request has been canceled. Thank you for using ~y~" .. companyName)
		
		SetEntityAsMissionEntity(vehicle)
		SetEntityAsMissionEntity(driver)
		
		DeleteEntity(vehicle)
		DeleteEntity(driver)
		enroute = false
	end
end)


RegisterNetEvent('radio')
AddEventHandler('radio', function()
    Citizen.CreateThread(function()
        TaskPlayAnim(player, "random@arrests", "generic_radio_enter", 1.5, 2.0, -1, 50, 2.0, 0, 0, 0 )
		Citizen.Wait(6000)
		ClearPedTasks(player)
    end)
end)

function GetVehicleInDirection( coordFrom, coordTo )
    local rayHandle = CastRayPointToPoint( coordFrom.x, coordFrom.y, coordFrom.z, 400.98910522461, -1633.5595703125, 29.291940689087, 10, GetPlayerPed( -1 ), 0 )
    local _, _, _, _, vehicle = GetRaycastResult( rayHandle )
    return vehicle
end

function loadAnimDict( dict )
	while ( not HasAnimDictLoaded( dict ) ) do
		RequestAnimDict( dict )
		Citizen.Wait( 0 )
	end
end

-- Shows a notification on the player's screen 
function ShowNotification( text )
    SetNotificationTextEntry( "STRING" )
    AddTextComponentString( text )
    DrawNotification( false, false )
end