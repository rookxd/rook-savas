local QBCore = exports['qb-core']:GetCoreObject()

local pvpzone = false
local silah = nil


Citizen.CreateThread(function()
    RequestModel(Config.PedModel)
    while not HasModelLoaded(Config.PedModel) do
        Wait(1)
    end
    npc = CreatePed(1, Config.PedModel, Config.arenanpc.x, Config.arenanpc.y, Config.arenanpc.z, Config.arenanpc.h, false, true)
    SetPedCombatAttributes(npc, 46, true)               
    SetPedFleeAttributes(npc, 0, 0)               
    SetBlockingOfNonTemporaryEvents(npc, true)
    SetEntityAsMissionEntity(npc, true, true)
    SetEntityInvincible(npc, true)
    FreezeEntityPosition(npc, true)
    exports['qb-target']:AddTargetEntity(npc, {
        options = {
            {
                label = "Alana gir/çık",
                canInteract = function()
                    if QBCore.Functions.GetPlayerData().metadata.isdead then
                        return false
                    else
                        return true
                    end
                end,
                action = function()
                    if pvpzone == false then
                    TriggerEvent('rook-savas:client:join')
                    else
                       TriggerEvent('rook-savas:client:leave') 
                end
            end
            }
        },
        distance = 2.0
    })
    --------------------------------
    RegisterKeyMapping('+medkit', 'Alan içinde bandaj kullanmanıza yarar', 'keyboard', 'F1')
    RegisterKeyMapping('+armor', 'Alan içinde zırh kullanmanıza yarar', 'keyboard', 'F2')
    RegisterKeyMapping('+araba', 'Alan içinde araba değiştirmenize yarar', 'keyboard', 'H')
    RegisterKeyMapping('+silah', 'Alan içinde silah değiştirmenize yarar', 'keyboard', 'F10')
end)


local npc = nil

Citizen.CreateThread(function()
    while true do
        if pvpzone then
            if not npc then
                RequestModel(Config.PedModel)
                while not HasModelLoaded(Config.PedModel) do
                    Wait(1)
                end
                npc = CreatePed(1, Config.PedModel, Config.helinpc.x, Config.helinpc.y, Config.helinpc.z, Config.helinpc.h, false, true)
                SetPedCombatAttributes(npc, 46, true)
                SetPedFleeAttributes(npc, 0, 0)
                SetBlockingOfNonTemporaryEvents(npc, true)
                SetEntityAsMissionEntity(npc, true, true)
                SetEntityInvincible(npc, true)
                FreezeEntityPosition(npc, true)
                exports['qb-target']:AddTargetEntity(npc, {
                    options = {
                        {
                            label = "Helikopter çıkart",
                            canInteract = function()
                                if QBCore.Functions.GetPlayerData().metadata.isdead then
                                    return false
                                else
                                    return true
                                end
                            end,
                            action = function()
                                TriggerEvent('rook-savas:client:heli')
                            end
                        }
                    },
                    distance = 2.0
                })
            end
        else
            if npc then
                DeleteEntity(npc)
                npc = nil
            end
        end
        Wait(5000)
    end
end)




CreateThread(function()
    local blip = AddBlipForCoord(Config.arenanpc.x, Config.arenanpc.y, Config.arenanpc.z)
    SetBlipSprite(blip, 303) 
    SetBlipDisplay(blip, 3)
    SetBlipScale(blip, 0.9)
    SetBlipColour(blip, 1) 
    SetBlipAsShortRange(blip, true)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("PVPZONE") 
    EndTextCommandSetBlipName(blip)
end)


------------------------ EVENTS ----------------------------------------
RegisterNetEvent('rook-savas:client:join')
AddEventHandler('rook-savas:client:join', function()
    local ped = PlayerPedId()
    if GetSelectedPedWeapon(PlayerPedId()) == GetHashKey("WEAPON_UNARMED") then    
        pvpzone = true
        TriggerServerEvent('rook-savas:server:farklidunya')
        TriggerEvent('rank-ffa:ac')
        TriggerEvent('ffa-ac')
        TriggerEvent('pd-ffa:ac')
        SetEntityCoords(ped, Config.arenakordinat.x, Config.arenakordinat.y, Config.arenakordinat.z)
        if silah == nil then
        GiveWeaponToPed(ped, GetHashKey("WEAPON_MACHINEPISTOL"), 9999, true, false)
        SetCurrentPedWeapon(ped, GetHashKey("WEAPON_MACHINEPISTOL"), true)
        else
            GiveWeaponToPed(ped, GetHashKey(silah), 9999, true, false)
            SetCurrentPedWeapon(ped, GetHashKey(silah), true)
        end
       -- SetPedAmmo(ped, GetHashKey("WEAPON_MACHINEPISTOL"), 9999)
        QBCore.Functions.Notify("PVP alanına giriş yaptınız!", "success")
    else
        QBCore.Functions.Notify("Elinde silah varken giremezsin!", "error")
    end
end)

RegisterNetEvent('rook-savas:client:leave')
AddEventHandler('rook-savas:client:leave', function()
    local ped = PlayerPedId()   
        pvpzone = false
        TriggerServerEvent('rook-savas:server:anadunya')
        TriggerEvent('rank-ffa:kapa')
        TriggerEvent('ffa-kapat')
        TriggerEvent('pd-ffa:kapa')
        SetEntityCoords(ped, Config.arenakordinat.x, Config.arenakordinat.y, Config.arenakordinat.z -1.0)
        --exports.ox_inventory:weaponWheel(false)
        GiveWeaponToPed(ped, GetHashKey("WEAPON_UNARMED"), 9999, true, false)
        SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"), true)
        QBCore.Functions.Notify("PVP alanından çıkış yaptınız!", "error")
end)

RegisterNetEvent("rook-savas:client:araba")
AddEventHandler("rook-savas:client:araba", function(araba)
    local pPed = PlayerPedId()
    local pCoords = GetEntityCoords(pPed)
    if pvpzone then
    if not IsPedInAnyVehicle(pPed, false) then
            QBCore.Functions.SpawnVehicle(araba, function(vehicle)
                SetVehicleMod(vehicle, 11, GetNumVehicleMods(vehicle, 11) - 1, false) 
                SetVehicleMod(vehicle, 12, GetNumVehicleMods(vehicle, 12) - 1, false) 
                SetVehicleMod(vehicle, 15, GetNumVehicleMods(vehicle, 15) - 1, false) 
                ToggleVehicleMod(vehicle, 18, true)
                ToggleVehicleMod(vehicle, 22, true) 
                TaskWarpPedIntoVehicle(pPed, vehicle, -1)
                TriggerEvent("vehiclekeys:client:SetOwner", QBCore.Functions.GetPlate(vehicle))
                SetVehicleEngineOn(vehicle, true, true, false)
            end, pCoords, true)
    else
        TriggerEvent('QBCore:Notify', 'Zaten bir araç içindesiniz.', 'error')
    end
end
end)

RegisterNetEvent("rook-savas:client:heli")
AddEventHandler("rook-savas:client:heli", function()
    local pPed = PlayerPedId()
    local pCoords = vector3(286.9863, -335.024, 44.919)
    if pvpzone then
    if not IsPedInAnyVehicle(pPed, false) then
            QBCore.Functions.SpawnVehicle('frogger2', function(vehicle)
                SetVehicleMod(vehicle, 11, GetNumVehicleMods(vehicle, 11) - 1, false) 
                SetVehicleMod(vehicle, 12, GetNumVehicleMods(vehicle, 12) - 1, false) 
                SetVehicleMod(vehicle, 15, GetNumVehicleMods(vehicle, 15) - 1, false) 
                ToggleVehicleMod(vehicle, 18, true)
                ToggleVehicleMod(vehicle, 22, true) 
                TaskWarpPedIntoVehicle(pPed, vehicle, -1)
                TriggerEvent("vehiclekeys:client:SetOwner", QBCore.Functions.GetPlate(vehicle))
                SetVehicleEngineOn(vehicle, true, true, false)
            end, pCoords, true)
    else
        TriggerEvent('QBCore:Notify', 'Zaten bir araç içindesiniz.', 'error')
    end
end
end)


RegisterNetEvent("rook-savas:client:silahdegis")
AddEventHandler("rook-savas:client:silahdegis", function(silahknk)
    if pvpzone then
   silah = silahknk
    end
end)






------------------------ COMMANDS ----------------------------------------
RegisterCommand('+armor', function()
    if pvpzone then
        QBCore.Functions.Progressbar("use_bandage", "Zırh...", 3000, false, true, {
            disableMovement = false,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = true,
        }, {
            animDict = "clothingshirt",
            anim = "try_shirt_neutral_d",
            flags = 49,
        }, {}, {}, function() -- Done
            IsBusy = false
            ClearPedTasks(PlayerPedId())
            SetPedArmour(PlayerPedId(), 200)
        end, function() -- Cancel
            ClearPedTasks(PlayerPedId())
            IsBusy = false
        end)
    end
end)


RegisterCommand('+araba', function()
    if pvpzone then

        local arabamenu = {
            {
                header = "Araç Çıkar",
                isMenuHeader = true
            }
        }

        for _, araba in pairs(Config.Arabalar) do
            table.insert(arabamenu, {
                header = araba.name,
                params = {
                    event = "rook-savas:client:araba",
                    args = araba.model
                }
            })
        end

        exports['qb-menu']:openMenu(arabamenu)
    end
end)


RegisterCommand('+silah', function()
    if pvpzone then

        local silahmenu = {
            {
                header = "Silah Değiştir",
                isMenuHeader = true
            }
        }

        for _, silahh in pairs(Config.Silahlar) do
            table.insert(silahmenu, {
                header = silahh.name,
                params = {
                    event = "rook-savas:client:silahdegis",
                    args = silahh.model
                }
            })
        end

        exports['qb-menu']:openMenu(silahmenu)
    end
end)

RegisterCommand('kdkontrol', function()
    QBCore.Functions.TriggerCallback("rook-savas:getstats", function(status)
        local kills = status.ffakills or 0
        local deaths = status.ffadeaths or 1
        local kda = kills / deaths

        QBCore.Functions.Notify("Öldürme: " .. kills .. " / Ölme: " .. deaths .. "", "success")
        QBCore.Functions.Notify("KD: " .. string.format("%.2f", kda), "success")
    end)
end)



RegisterCommand('pvpbitir', function()
    if pvpzone then
        if not QBCore.Functions.GetPlayerData().metadata.isdead then
            TriggerEvent('rook-savas:client:leave') 
        end
    end
end)






------------------------ THREADS ----------------------------------------




Citizen.CreateThread(function()
    while true do 
        local wait = 10000
        
        if pvpzone then
            local player = PlayerPedId()
            local Xplayer = QBCore.Functions.GetPlayerData()

            if Xplayer.metadata["inlaststand"] or Xplayer.metadata["isdead"] then
                wait = 7000

                SetEntityCoords(player, Config.arenakordinat.x, Config.arenakordinat.y, Config.arenakordinat.z)
                TriggerEvent('hospital:client:Revive', false)
                
                if silah == nil then
                SetCurrentPedWeapon(player, GetHashKey("WEAPON_MACHINEPISTOL"), true)
                else
                    SetCurrentPedWeapon(player, GetHashKey(silah), true)
                end
            end
        end
        
        Citizen.Wait(wait)
    end
end)





local sonarac = nil 

local function aracsil()
    if sonarac and DoesEntityExist(sonarac) then
        DeleteEntity(sonarac)
        sonarac = nil
    end
end

Citizen.CreateThread(function()
    local aracta = false

    while true do
        local playerPed = PlayerPedId()
        local aractami = IsPedInAnyVehicle(playerPed, false)

        if aractami then
            sonarac = GetVehiclePedIsIn(playerPed, false)
            aracta = true
            Citizen.Wait(500) 
        else
            if aracta and exports["rook-savas"]:InPvP() then
                aracsil()
                aracta = false
            end
            Citizen.Wait(1500)
        end
    end
end)


Citizen.CreateThread(function()
    while true do
        if not exports["rook-savas"]:InPvP() then
            Citizen.Wait(5000)
        else
            local ped = PlayerPedId()
            local aracdisimi = IsPedOnFoot(ped)
            local aractami = IsPedInAnyVehicle(ped, true)

            if aracdisimi and not aractami then
                if silah == nil then
                GiveWeaponToPed(ped, GetHashKey("WEAPON_MACHINEPISTOL"), 9999, true, false)
                SetCurrentPedWeapon(ped, GetHashKey("WEAPON_MACHINEPISTOL"), true)
                else
                    GiveWeaponToPed(ped, GetHashKey(silah), 9999, false, false)
                    SetCurrentPedWeapon(ped, GetHashKey(silah), true) 
                end
            else
                SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"), true)
            end

            Citizen.Wait(0)
        end
    end
end)










------------------------ HANDLERS ----------------------------------------

AddEventHandler('gameEventTriggered', function(name, data)
    if name == "CEventNetworkEntityDamage" then
        if pvpzone then
            victim = tonumber(data[1])
            attacker = tonumber(data[2])
            victimDied = tonumber(data[6]) == 1 and true or false 
            weaponHash = tonumber(data[7])
            isMeleeDamage = tonumber(data[10]) ~= 0 and true or false 
            vehicleDamageTypeFlag = tonumber(data[11]) 
            local FoundLastDamagedBone, LastDamagedBone = GetPedLastDamageBone(victim)
            local bonehash = -1 
            if FoundLastDamagedBone then
                bonehash = tonumber(LastDamagedBone)
            end
            local PPed = PlayerPedId()
            local distance = IsEntityAPed(attacker) and #(GetEntityCoords(attacker) - GetEntityCoords(victim)) or -1
            local isplayer = IsPedAPlayer(attacker)
            local attackerid = isplayer and GetPlayerServerId(NetworkGetPlayerIndexFromPed(attacker)) or tostring(attacker==-1 and " " or attacker)
            local deadid = isplayer and GetPlayerServerId(NetworkGetPlayerIndexFromPed(victim)) or tostring(victim==-1 and " " or victim)
            local victimName = GetPlayerName(PlayerId())
    
            if victim == attacker or victim ~= PPed or not IsPedAPlayer(victim) or not IsPedAPlayer(attacker) then return end
    
            if victim == PPed then 
                if victimDied then
                    if IsEntityAPed(attacker) then
                        TriggerServerEvent('rook-savas:server:stat-ekle', attackerid, deadid)
                    end
                end 
            end
        end
    end
end)



exports('InPvP', function()
    return pvpzone
end)


