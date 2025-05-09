QBCore = exports['qb-core']:GetCoreObject()

local inZone = false
local muted = false
local zones = {
    {
        vector2(356.99026489258, -285.91421508789),
        vector2(339.44110107422, -432.73672485352),
        vector2(191.83489990234, -381.36196899414),
        vector2(236.99697875977, -236.76554870605)
    },
}

CreateThread(function()
    for k, v in pairs(zones) do
        local zone = PolyZone:Create(v, {
            name = "zone-" .. k,
            debugPoly = false,
        })

        zone:onPlayerInOut(function(isPointInside)
            if isPointInside then
                inZone = true
            else
                inZone = false
            end
        end)
    end

    while true do
        local sleep = 250
        if inZone and exports["rook-savas"]:InPvP() then
            sleep = 0
            DisableControlAction(0, 106, true) 
            DisableControlAction(1, 140, true) 
            DisableControlAction(1, 141, true)
            DisableControlAction(1, 142, true)
            DisablePlayerFiring(PlayerPedId(), true)
            nocollision()
        end
        Wait(sleep)
    end
end)



function nocollision()
    local playerPed = PlayerPedId()
    local veh = GetVehiclePedIsIn(playerPed, false)
    local carros = GetGamePool("CVehicle")
    if exports["rook-savas"]:InPvP() then

    if veh ~= 0 then
        for i = 1, #carros do
            SetEntityNoCollisionEntity(carros[i], veh, true)
        end
    else
        for i = 1, #carros do
            SetEntityNoCollisionEntity(carros[i], playerPed, true)
        end
    end

    for _, i in ipairs(GetActivePlayers()) do
        if i ~= PlayerId() then
            local closestPlayerPed = GetPlayerPed(i)
            if DoesEntityExist(closestPlayerPed) then
                SetEntityNoCollisionEntity(closestPlayerPed, playerPed, true)
            end
        end
    end
end
end