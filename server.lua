RegisterServerEvent('daj')
AddEventHandler('daj', function()
    local igrac = ESX.GetPlayerFromId(source) 

    if igrac.canCarryItem('vino') then
        igrac.addInventoryItem('vino', nasumicno())
		ESX.ShowNotification("", "Dobili ste jedno" .. nasumicno .. " vina za skupljenih 30 polja!", 3000, "info")
    end
end)

RegisterServerEvent("prodaj")
AddEventHandler("prodaj", function()
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)

    if xPlayer.getInventoryItem('vino').count >= 1 then
    	cena = Config.CenaVina
    	pare = cena * xPlayer.getInventoryItem('vino').count
    	local ukupno = pare
		local distance = #(GetEntityCoords(GetPlayerPed(src)) - vec3(2905.72, 4406.88, 49.28))
		if distance < 10.0 then
        TriggerClientEvent('esx:showNotification', xPlayer.source, 'Prodali ste ' ..xPlayer.getInventoryItem('vino').count .. ' vina za ' ..ukupno .. '$')
		xPlayer.removeInventoryItem('vino', xPlayer.getInventoryItem('vino').count)
		xPlayer.addMoney(ukupno)
	else
		TriggerClientEvent('esx:showNotification', src, 'Nemate dovoljno vina kod sebe!')
		DropPlayer("Prodaja vina preko netacne lokacije | Brutalci Roleplay |", src)
	    end
    end
end)
  
function nasumicno()
	return math.random(1,3)
end