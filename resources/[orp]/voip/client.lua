local voice = {default = 5.0, shout = 12.0, whisper = 1.0, current = 1, level = "Activated"}

function drawLevel(r, g, b, a)
  SetTextFont(4)
  SetTextProportional(1)
  SetTextScale(0.5, 0.5)
  SetTextColour(r, g, b, a)
  SetTextDropShadow(0, 0, 0, 0, 255)
  SetTextEdge(1, 0, 0, 0, 255)
  SetTextDropShadow()
  SetTextOutline()
  SetTextEntry("STRING")
  AddTextComponentString("~b~Range:~s~ " .. voice.level)
  local playerPed = GetPlayerPed(-1)
  local playerVeh = GetVehiclePedIsIn(playerPed, false)
	if IsPedInAnyVehicle(playerPed,true) then
		DrawText(0.1616, 0.95)
	else 
		DrawText(0.1616, 0.95)
	end
  
end



Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    if IsControlJustPressed(1, 246) then
      voice.current = (voice.current + 1) % 3
      if voice.current == 1 then
        NetworkSetTalkerProximity(voice.default)
        voice.level = "Normal"
        --print(voice.current)
      elseif voice.current == 2 then
        NetworkSetTalkerProximity(voice.shout)
        voice.level = "Shout"
        --print(voice.current)
      elseif voice.current == 0 then
        NetworkSetTalkerProximity(voice.whisper)
        voice.level = "Whisper"
        --print(voice.current)
      end
    end
    if voice.current == 1 then
      voice.level = "Normal"
    elseif voice.current == 2 then
      voice.level = "Shout"
    elseif voice.current == 0 then
      voice.level = "Whisper"
    end
    if NetworkIsPlayerTalking(PlayerId()) then
      drawLevel(255, 0, 188, 255)
    elseif not NetworkIsPlayerTalking(PlayerId()) then
      drawLevel(185, 185, 185, 255)
    end
  end
end)

