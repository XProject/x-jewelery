local ElectricalBoxEntity
local ElectricalBusy
local StartedElectrical = {}
local StartedCabinet = {}
local AlarmFired = false

lib.callback.register("qbx-jewelleryrobbery:callback:electricalBox", function(source)
    local player = Framework.GetPlayerFromSource(source)
    if not player then return false end

    local playerCoords = GetEntityCoords(GetPlayerPed(source))
    if #(playerCoords - vector3(Config.Electrical.x, Config.Electrical.y, Config.Electrical.z)) > 2 then return false end

    local playerHasRequiredItem = Framework.DoesPlayerHaveItem(player, Config.Doorlock.RequiredItem, 1)
    if not playerHasRequiredItem then ShowNotification(locale("notify.noitem", Framework.GetItemLabel(Config.Doorlock.RequiredItem)), "error", source) return false end

    local copsAmount = Framework.GetOnlineCopsAmount()
    if copsAmount < Config.MinimumCops then
        if Config.NotEnoughCopsNotify then ShowNotification(locale("notify.nopolice", Config.MinimumCops), "error", source) end
        return false
    end

    if ElectricalBusy then ShowNotification(locale("notify.busy"), "inform", source) return false end

    ElectricalBusy = true
    StartedElectrical[source] = true

    return Config.Doorlock.LoseItemOnUse and Framework.RemoveItemFromPlayer(player, Config.Doorlock.RequiredItem, 1) or true
end)

lib.callback.register("qb-jewelery:callback:cabinet", function(source, closestCabinet)
    local playerPed = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(playerPed)

    if #(playerCoords - Config.Cabinets[closestCabinet].coords) > 1.8 then return false end

    if not Config.AllowedWeapons[GetSelectedPedWeapon(playerPed)] then ShowNotification(locale("notify.noweapon"), "inform", source) return false end

    if Config.Cabinets[closestCabinet].isBusy then ShowNotification(locale("notify.busy"), "inform", source) return false end

    if Config.Cabinets[closestCabinet].isOpened then ShowNotification(locale("notify.cabinetdone"), "inform", source) return false end

    StartedCabinet[source] = closestCabinet
    Config.Cabinets[closestCabinet].isBusy = true

    local allPlayers = Framework.GetAllPlayers()
    for k in pairs(allPlayers) do
        if k ~= source then
            if #(GetEntityCoords(GetPlayerPed(k)) - Config.Cabinets[closestCabinet].coords) < 20 then
                TriggerClientEvent("qb-jewelery:client:synceffects", k, closestCabinet, source)
            end
        end
    end

    return true
end)

local function fireAlarm()
    if AlarmFired then return end
    AlarmFired = true

    TriggerEvent("police:server:policeAlert", locale("notify.police"))
    TriggerEvent("qb-scoreboard:server:SetActivityBusy", "jewellery", true)
    TriggerClientEvent("qb-jewelery:client:alarm", -1)

    SetTimeout(Config.Timeout, function()
        local entranceDoor = exports.ox_doorlock:getDoorFromName(Config.Doorlock.Name)
        TriggerEvent("ox_doorlock:setState", entranceDoor?.id, 1)

        TriggerEvent("qb-scoreboard:server:SetActivityBusy", "jewellery", false)

        for i = 1, #Config.Cabinets do
            Config.Cabinets[i].isOpened = false
        end
        TriggerClientEvent("qb-jewelery:client:syncconfig", -1, Config.Cabinets)

        AlarmFired = false
    end)
end

RegisterNetEvent("qb-jewelery:server:endcabinet", function()
    local player = Framework.GetPlayerFromSource(source)
    local playerCoords = GetEntityCoords(GetPlayerPed(source))
    local closestCabinet = StartedCabinet[source]
    local cabinet = Config.Cabinets[closestCabinet]

    if not closestCabinet or cabinet.isOpened or not cabinet.isBusy then return --[[player is sus]] end

    if #(playerCoords - Config.Cabinets[closestCabinet].coords) > 1.8 then return end

    cabinet.isOpened = true --[[thanks to lua's pass by reference]]
    cabinet.isBusy = false --[[thanks to lua's pass by reference]]
    StartedCabinet[source] = nil

    TriggerClientEvent("qb-jewelery:client:syncconfig", -1, Config.Cabinets)

    for _ = 1, math.random(Config.Reward.MinAmount, Config.Reward.MaxAmount) do
        local randomItem = Config.Reward.Items[math.random(1, #Config.Reward.Items)]
        Framework.AddItemToPlayer(player, randomItem.Name, math.random(randomItem.Min, randomItem.Max))
    end

    fireAlarm()
end)

RegisterNetEvent("qb-jewellery:server:failedhackdoor", function()
    ElectricalBusy = false
    StartedElectrical[source] = false

    ShowNotification("Hack failed", "error", source)
end)

RegisterNetEvent("qb-jewellery:server:succeshackdoor", function()
    local playerCoords = GetEntityCoords(GetPlayerPed(source))

    if not ElectricalBusy or not StartedElectrical[source] then return --[[player is sus]] end

    if #(playerCoords - vector3(Config.Electrical.x, Config.Electrical.y, Config.Electrical.z)) > 2 then return end

    ElectricalBusy = false
    StartedElectrical[source] = false

    ShowNotification("Hack successful", "success", source)

    local entranceDoor = exports.ox_doorlock:getDoorFromName(Config.Doorlock.Name)
    TriggerEvent("ox_doorlock:setState", entranceDoor?.id, 0)
end)

AddEventHandler("onResourceStop", function(resource)
    if resource ~= GetCurrentResourceName() then return end
    if not DoesEntityExist(ElectricalBoxEntity) then return end
    DeleteEntity(ElectricalBoxEntity)
end)

CreateThread(function()
    Wait(250)
    ElectricalBoxEntity = CreateObject(`tr_prop_tr_elecbox_01a`, Config.Electrical.x, Config.Electrical.y, Config.Electrical.z, true, false, false)
    while ElectricalBoxEntity == 0 do ElectricalBoxEntity = CreateObject(`tr_prop_tr_elecbox_01a`, Config.Electrical.x, Config.Electrical.y, Config.Electrical.z, true, false, false) Wait(3000) end -- WTH ?!
    while not DoesEntityExist(ElectricalBoxEntity) do Wait(0) end
    Wait(100)
    SetEntityHeading(ElectricalBoxEntity, Config.Electrical.w)
end)

AddEventHandler("playerJoining", function(source)
    TriggerClientEvent("qb-jewelery:client:syncconfig", source, Config.Cabinets)
end)

-- lib.versionCheck("Qbox-project/qb-jewelery")