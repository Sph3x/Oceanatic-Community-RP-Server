-- Add an event handler for the 'chatMessage' event
AddEventHandler( 'chatMessage', function( s, n, msg )  
    msg = string.lower(msg)
    if (msg == "/towai") then 
        CancelEvent() 
        TriggerClientEvent('wk:spawnTow', s)
	elseif (msg == "/canceltowaio") then 
        CancelEvent() 
        TriggerClientEvent('wk:cancelTow', s)
    elseif (msg == "/towpopo") then 
        CancelEvent() 
        TriggerClientEvent('wk:spawnTowpopo', s)
	elseif (msg == "/canceltowpopo") then 
        CancelEvent() 
        TriggerClientEvent('wk:cancelTowpopo', s)
	end
end)