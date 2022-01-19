poceo = false
uzeto = 0

-- Npcevi
local NPC = {
    {model = "a_m_m_farmer_01", x = -1896.64, y = 2082.48, z = 140.0, h = 322.6}, -- Zapocni/zavrsi posao npc
    {model = "a_m_m_eastsa_01", x = 1211.4, y = 1857.44, z = 77.96, h = 39.44}, -- Prerada npc
    {model = "a_m_m_hillbilly_01", x = 2905.72, y = 4406.88, z = 49.28, h = 294.32}, -- Prodaja npc
}

Citizen.CreateThread(function()
    for _, v in pairs(NPC) do
        RequestModel(GetHashKey(v.model))
        while not HasModelLoaded(GetHashKey(v.model)) do 
            Wait(1)
        end
        local npc = CreatePed(4, v.model, v.x, v.y, v.z, v.h,  false, true)
        SetPedFleeAttributes(npc, 0, 0)
        SetPedDropsWeaponsWhenDead(npc, false)
        SetPedDiesWhenInjured(npc, false)
        SetEntityInvincible(npc , true)
        FreezeEntityPosition(npc, true)
        SetBlockingOfNonTemporaryEvents(npc, true)
        if v.seller then 
            RequestAnimDict("missfbi_s4mop")
            while not HasAnimDictLoaded("missfbi_s4mop") do
                Wait(1)
            end
            TaskPlayAnim(npc, "missfbi_s4mop" ,"guard_idle_a" ,8.0, 1, -1, 49, 0, false, false, false)
        end
    end
end)

----------------------------------
-- PRODAJ FLASE VINA / SELL BOTTLE OF WINE

local peds = {
    `a_m_m_hillbilly_01`,
}
exports["qtarget"]:AddTargetModel(peds, {
	options = {
		{
			event = "pozovi:nh3",
			icon = "fas fa-wine-glass-alt",
			label = "Prodaj flase vina",
            job = 'skylofy'
		},
		},
	distance = 2.5
})

AddEventHandler('pozovi:nh3', function(source)
    TriggerEvent('nh-context:sendMenu', {
		{
			id = 1,
			header = "Radnik koji otkupljuje boce sa vinom",
			txt = "Ovo vino je kvalitetno, jesi li siguran da zelis da ga prodas?",
			params = {
				event = "pocniProdajicu",
				args = {}
			}
		},
	})	
end)

RegisterNetEvent("pocniProdajicu")
AddEventHandler("pocniProdajicu", function()
    Wait(200)
    if poceo == true then
        exports.rprogress:Custom({
            Duration = 2500,
            Label = "Prodajes flase vina...",
            Animation = {
                scenario = "WORLD_HUMAN_COP_IDLES",
                animationDictionary = "idle_a",
            },
            DisableControls = {
                Mouse = false,
                Player = true,
                Vehicle = true
            }
        })
        Citizen.Wait(2500)
        TriggerServerEvent("prodaj")
        TriggerEvent("zavrsiPoslic")
        ESX.ShowNotification("", "Prodao si svo vino koje si imao kod sebe i zavrsio posao, ako zelis da opet skupljas grozdje idi do vinarije", 10000, "success")
    end
end)

----------------------------------
-- PRERADI GROZDJE / PROCESS GRAPES

local peds = {
    `a_m_m_eastsa_01`,
}
exports["qtarget"]:AddTargetModel(peds, {
	options = {
		{
			event = "pozovi:nh2",
			icon = "fas fa-wine-glass-alt",
			label = "Preradi grozdje",
            job = 'skylofy'
		},
		},
	distance = 2.5
})

AddEventHandler('pozovi:nh2', function(source)
    TriggerEvent('nh-context:sendMenu', {
		{
			id = 1,
			header = "Radnik koji uzima grozdje",
			txt = "Nadam se da ti nije bilo naporno da skupis svih 30 polja.",
			params = {
				event = "pocniPreradicu",
				args = {}
			}
		},
	})	
end)

RegisterNetEvent("pocniPreradicu")
AddEventHandler("pocniPreradicu", function()
    Wait(200)
    if poceo == true and uzeto == 30 then
        exports.rprogress:Custom({
            Duration = 2500,
            Label = "Dajes grozdje radniku...",
            Animation = {
                scenario = "WORLD_HUMAN_COP_IDLES",
                animationDictionary = "idle_a",
            },
            DisableControls = {
                Mouse = false,
                Player = true,
                Vehicle = true
            }
        })
        Citizen.Wait(2500)
        uzeto = 0
        TriggerServerEvent("daj")
    end
end)

----------------------------------
-- ZAPOCNI POSAO / START JOB

local peds = {
    `a_m_m_farmer_01`,
}
exports["qtarget"]:AddTargetModel(peds, {
	options = {
		{
			event = "pozovi:nh1",
			icon = "fas fa-wine-glass-alt",
			label = "Zapocni posao",
            job = 'skylofy'
		},
        {
			event = "zavrsiPoslic",
			icon = "fas fa-wine-glass-alt",
			label = "Zavrsi posao",
            job = 'skylofy'
		},
		},
	distance = 2.5
})

AddEventHandler('pozovi:nh1', function(source)
    TriggerEvent('nh-context:sendMenu', {
		{
			id = 1,
			header = "Radnik na polju",
			txt = "Tvoj posao je da se spustis dole i odes na  lokacije i beres grozdje.",
			params = {
				event = "pocniPoslic",
				args = {}
			}
		},
	})	
end)

RegisterNetEvent("pocniPoslic")
AddEventHandler("pocniPoslic", function()
    Wait(200)
    poceo = true
    if poceo == true then
        exports.rprogress:Custom({
            Duration = 2500,
            Label = "Presvlacis se...",
            Animation = {
                scenario = "WORLD_HUMAN_COP_IDLES",
                animationDictionary = "idle_a",
            },
            DisableControls = {
                Mouse = false,
                Player = true,
                Vehicle = true
            }
        })
        Citizen.Wait(2500)
        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
        if skin.sex == 0 then
            TriggerEvent('skinchanger:loadClothes', skin, Config.Odeca.musko)
        elseif skin.sex == 1 then
            TriggerEvent('skinchanger:loadClothes', skin, Config.Odeca.zensko)
        end
        ESX.ShowNotification("", "Pokrenuo si posao", 3000, "info")
        poceo = true
        getajBlipove()
        dajBlipoveNpc()
        end)
    end
end)

----------------------------------
-- ZAVRSI POSAO / FINISH JOB

RegisterNetEvent("zavrsiPoslic")
AddEventHandler("zavrsiPoslic", function()
    if poceo == true then
    exports.rprogress:Custom({
        Duration = 2500,
        Label = "Presvlacis se...",
        Animation = {
            scenario = "WORLD_HUMAN_COP_IDLES", -- https://pastebin.com/6mrYTdQv
            animationDictionary = "idle_a", -- https://alexguirre.github.io/animations-list/
        },
        DisableControls = {
            Mouse = false,
            Player = true,
            Vehicle = true
        }
    })
    Citizen.Wait(2500)
    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
        TriggerEvent('skinchanger:loadSkin', skin)
    ESX.ShowNotification("", "Završio si posao", 3000, "success")
        poceo = false
        uzeto = 0
            for i, v in ipairs(Config.Lokacije) do
                RemoveBlip(v.blip)
                v.Ubrano = true
            end
        end)
    end
end)

----------------------------------
-- BLIPOVI / BLIPS

function getajBlipove()
    for l, v in ipairs(Config.Lokacije) do
        v.blip = AddBlipForCoord(v.x, v.y, v.z)
        SetBlipSprite(v.blip, 285)
        SetBlipDisplay(v.blip, 4)
        SetBlipScale(v.blip, 0.4)
        SetBlipAsShortRange(v.blip, true)
        SetBlipColour(v.blip, 47)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName('Grozdje')
        EndTextCommandSetBlipName(v.blip)
    end
end

function dajBlipoveNpc()
    for l, v in ipairs(NPC) do
        v.blip = AddBlipForCoord(v.x, v.y, v.z)
        SetBlipSprite(v.blip, 280)
        SetBlipDisplay(v.blip, 4)
        SetBlipScale(v.blip, 0.6)
        SetBlipAsShortRange(v.blip, true)
        SetBlipColour(v.blip, 2)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName('Posao | Vinarije')
        EndTextCommandSetBlipName(v.blip)
    end
end

----------------------------------
-- Key Controls

Citizen.CreateThread(function()
    while true do
        local spavaj = 500
        local ped = PlayerPedId()
        local pozicija = GetEntityCoords(ped)

        if poceo == true then
            for k,v in ipairs(Config.Lokacije) do
                    if (GetDistanceBetweenCoords(pozicija, v.x, v.y, v.z, true) < 2) and not v.Ubrano then
                        spavaj = 6
                        DrawText3D(v.x, v.y, v.z, '~w~[~r~ E ~w~] ~w~da uberes grozdje', 0.6)
                        if IsControlJustPressed(0, Dugmici["E"]) then
                            ESX.Streaming.RequestAnimDict('amb@prop_human_movie_bulb@idle_a', function()
                                TaskPlayAnim(PlayerPedId(), 'amb@prop_human_movie_bulb@idle_a', 'idle_a', 8.0, -8.0, -1, 2, 0, false, false, false)
                            end)
                            exports.rprogress:Custom({
                                Duration = 5500,
                                Label = "Beres grozdje...",
                                DisableControls = {
                                    Mouse = false,
                                    Player = true,
                                    Vehicle = true
                                }
                            })
                            Citizen.Wait(5500)
                            v.Ubrano = true
                            uzeto = uzeto + 1
                            RemoveBlip(v.blip)
                            ClearPedTasks(ped)
                            print(uzeto)
                            if uzeto == 30 then
                                ESX.ShowNotification("", "Pokupili ste svo grozdje sa vinarije, idite preradite ga", 5000, "info")
                            v.Ubrano = false
                        end
                    end
                end
            end
        end
        Citizen.Wait(spavaj)
    end
end)

----------------------------------

function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    local factor = (string.len(text)) / 370

    SetTextScale(0.30, 0.30)
    SetTextFont(6)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x, _y)
end
