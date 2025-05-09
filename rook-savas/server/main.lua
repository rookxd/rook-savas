local QBCore = exports['qb-core']:GetCoreObject()


RegisterServerEvent('rook-savas:server:farklidunya')
AddEventHandler('rook-savas:server:farklidunya', function()
    local src = source
    SetPlayerRoutingBucket(src, 50)
end)

RegisterServerEvent('rook-savas:server:anadunya')
AddEventHandler('rook-savas:server:anadunya', function()
    local src = source
    SetPlayerRoutingBucket(src, 0)
end)

RegisterNetEvent("rook-savas:server:getPlayerBucket")
AddEventHandler("rook-savas:server:getPlayerBucket", function(source)
    local playerBucket = GetPlayerRoutingBucket(source)
    TriggerClientEvent("rook-savas:client:checkBucket", source, playerBucket)
end)


RegisterNetEvent('rook-savas:server:stat-ekle', function(attacker, deader)
    local aPlayer = QBCore.Functions.GetPlayer(attacker)
    local dPlayer = QBCore.Functions.GetPlayer(deader)
    -------------------------------
    MySQL.Async.execute("UPDATE players SET ffakills = ffakills + @ffakills WHERE citizenid = @citizenid", {
        ["@citizenid"] = aPlayer.PlayerData.citizenid,
        ["@ffakills"] = 1
    })
    -------------------------------
    MySQL.Async.execute("UPDATE players SET ffadeaths = ffadeaths + @ffadeaths WHERE citizenid = @citizenid", {
        ["@citizenid"] = dPlayer.PlayerData.citizenid,
        ["@ffadeaths"] = 1
    })
end)

QBCore.Functions.CreateCallback("rook-savas:getstats", function(source, cb)
    Player = QBCore.Functions.GetPlayer(source)
    local result = MySQL.Sync.fetchAll('SELECT * FROM players WHERE citizenid = @citizenid', {
        ['@citizenid'] = Player.PlayerData.citizenid
    })
    cb(result[1])
end)


