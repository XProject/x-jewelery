local electricalBoxEntity, isElectricalBoxBusy , isAlarmFired, alarmTime = nil, false, false, 0
local StartedElectrical, StartedCabinet = {}, {}

local function syncConfig(source)
    TriggerClientEvent("qbx-jewelleryrobbery:client:syncConfig", source or -1, Config.Cabinets)
end

local function fireAlarm()
    alarmTime = 0 -- reset alarmTime on each cabinet smash (reflects that robbery is still in progress)
    TriggerClientEvent("qbx-jewelleryrobbery:client:alarm", -1)

    if isAlarmFired then return end
    isAlarmFired = true

    Framework.AlertPolice(locale("notify.police"))
    Framework.SetScoreboardActivityBusy(true)

    CreateThread(function()
        while alarmTime < Config.Timeout do
            alarmTime += 1000
            Wait(1000)
        end

        local entranceDoor = exports.ox_doorlock:getDoorFromName(Config.Doorlock.Name)
        TriggerEvent("ox_doorlock:setState", entranceDoor?.id, 1)

        Framework.SetScoreboardActivityBusy(false)

        for i = 1, #Config.Cabinets do
            Config.Cabinets[i].isOpened = false
        end
        syncConfig()

        isAlarmFired = false
    end)
end

lib.callback.register("qbx-jewelleryrobbery:callback:canHackElectricalBox", function(source)
    local player = Framework.GetPlayerFromSource(source)
    if not player then return false end

    local playerCoords = GetEntityCoords(GetPlayerPed(source))
    if #(playerCoords - vector3(Config.Electrical.x, Config.Electrical.y, Config.Electrical.z)) > 2 then return false end

    local playerHasRequiredItem = Framework.DoesPlayerHaveItem(player, Config.Doorlock.RequiredItem, 1)
    if not playerHasRequiredItem then Shared.showNotification(locale("notify.noitem", Framework.GetItemLabel(Config.Doorlock.RequiredItem)), "error", source) return false end

    local copsAmount = Framework.GetOnlineCopsAmount()
    if copsAmount < Config.MinimumCops then
        if Config.NotEnoughCopsNotify then Shared.showNotification(locale("notify.nopolice", Config.MinimumCops), "error", source) end
        return false
    end

    if isElectricalBoxBusy then Shared.showNotification(locale("notify.busy"), "inform", source) return false end

    isElectricalBoxBusy = true
    StartedElectrical[source] = true

    return Config.Doorlock.LoseItemOnUse and Framework.RemoveItemFromPlayer(player, Config.Doorlock.RequiredItem, 1) or true
end)

lib.callback.register("qbx-jewelleryrobbery:callback:canSmashCabinet", function(source, cabinetId)
    local playerPed = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(playerPed)

    if #(playerCoords - Config.Cabinets[cabinetId].coords) > 1.8 then return false end

    if not Config.AllowedWeapons[GetSelectedPedWeapon(playerPed)] then Shared.showNotification(locale("notify.noweapon"), "inform", source) return false end

    if Config.Cabinets[cabinetId].isBusy then Shared.showNotification(locale("notify.busy"), "inform", source) return false end

    if Config.Cabinets[cabinetId].isOpened then Shared.showNotification(locale("notify.cabinetdone"), "inform", source) return false end

    StartedCabinet[source] = cabinetId
    Config.Cabinets[cabinetId].isBusy = true

    local allPlayers = GetPlayers()
    for i = 1, #allPlayers do
        local playerSource = allPlayers[i] --[[@as number]]
        local distanceWithCabinet = #(GetEntityCoords(GetPlayerPed(playerSource)) - Config.Cabinets[cabinetId].coords)

        if distanceWithCabinet < 20 then
            TriggerClientEvent("qbx-jewelleryrobbery:client:syncEffects", playerSource, cabinetId, source)
        end
    end

    fireAlarm()

    return true
end)

RegisterNetEvent("qbx-jewelleryrobbery:server:endCabinet", function()
    local player = Framework.GetPlayerFromSource(source)
    local playerCoords = GetEntityCoords(GetPlayerPed(source))
    local cabinetId = StartedCabinet[source]
    local cabinet = Config.Cabinets[cabinetId]

    if not cabinetId or cabinet.isOpened or not cabinet.isBusy then return --[[player is sus]] end

    if #(playerCoords - Config.Cabinets[cabinetId].coords) > 1.8 then return end

    cabinet.isOpened = true --[[thanks to lua's pass by reference]]
    cabinet.isBusy = false --[[thanks to lua's pass by reference]]
    StartedCabinet[source] = nil

    syncConfig()

    for _ = 1, math.random(Config.Reward.MinAmount, Config.Reward.MaxAmount) do
        local randomItem = Config.Reward.Items[math.random(1, #Config.Reward.Items)]
        Framework.AddItemToPlayer(player, randomItem.Name, math.random(randomItem.Min, randomItem.Max))
    end
end)

RegisterNetEvent("qbx-jewelleryrobbery:server:electricalHandlerHack", function(hackSuccess)
    if hackSuccess == nil then return end

    if hackSuccess then
        local playerCoords = GetEntityCoords(GetPlayerPed(source))

        if not isElectricalBoxBusy or not StartedElectrical[source] then return --[[player is sus]] end

        if #(playerCoords - vector3(Config.Electrical.x, Config.Electrical.y, Config.Electrical.z)) > 2 then return end

        isElectricalBoxBusy = false
        StartedElectrical[source] = false

        Shared.showNotification("Hack successful", "success", source)

        local entranceDoor = exports.ox_doorlock:getDoorFromName(Config.Doorlock.Name)
        TriggerEvent("ox_doorlock:setState", entranceDoor?.id, 0)
    else
        isElectricalBoxBusy = false
        StartedElectrical[source] = false

        Shared.showNotification("Hack failed", "error", source)
    end
end)

local function onResourceStart(resource)
    if resource ~= Shared.currentResourceName then return end

    syncConfig()

    electricalBoxEntity = CreateObject(`tr_prop_tr_elecbox_01a`, Config.Electrical.x, Config.Electrical.y, Config.Electrical.z, true, false, false)

    while not DoesEntityExist(electricalBoxEntity) do Wait(0) end

    SetEntityHeading(electricalBoxEntity, Config.Electrical.w)
end

AddEventHandler("onServerResourceStart", onResourceStart)

local function onResourceStop(resource)
    if resource ~= Shared.currentResourceName then return end

    if DoesEntityExist(electricalBoxEntity) then
        DeleteEntity(electricalBoxEntity)
    end
end

AddEventHandler("onResourceStop", onResourceStop)
AddEventHandler("onServerResourceStop", onResourceStop)

AddEventHandler("playerJoining", function(source)
    syncConfig(source)
end)

-- lib.versionCheck("Qbox-project/qb-jewelery")