local isHacking = false
local isSmashing = false
local closestCabinet = 1
local BOX_ANIMATION_DICTIONARY = "anim@scripted@player@mission@tun_control_tower@male@"
local CABINET_ANIMATION_DICTIONARY = "missheist_jewel"
local CABINET_ANIMATION_SMASH_TOP = {
    "smash_case_tray_a",
    "smash_case_d",
    "smash_case_e"
}
local CABINET_ANIMATION_SMASH_FRONT = {
    "smash_case_tray_b",
    "smash_case_necklace_skull"
}

local function DrawText3D(coords, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextColour(255, 255, 255, 215)
    BeginTextCommandDisplayText("STRING")
    SetTextCentre(true)
    AddTextComponentSubstringPlayerName(text)
    SetDrawOrigin(coords.x, coords.y, coords.z, 0)
    EndTextCommandDisplayText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0 + 0.0125, 0.017 + factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

local function hack()
    local p = promise.new()
    local hackTime = math.random(Config.Doorlock.HackTime.Min, Config.Doorlock.HackTime.Max)

    if GetResourceState("ultra-voltlab"):find("start") then
        TriggerEvent("ultra-voltlab", hackTime, function(result, _)
            p:resolve(result == 1 and true or false)
        end)
    elseif GetResourceState("ps-ui"):find("start") then
        -- exports["ps-ui"]:Maze(function(success)
        --     p:resolve(success and true or false)
        -- end, hackTime)

        local types = {"braille", "runes"} -- (alphabet, numeric, alphanumeric, greek, braille, runes)
        exports["ps-ui"]:Scrambler(function(success)
            p:resolve(success and true or false)
        end, types[math.random(#types)], hackTime, 1)
    else
        p:resolve(true)
    end

    return Citizen.Await(p)
end

local function hackElectricalHandler()
    if isHacking then return end
    isHacking = true

    lib.requestAnimDict(BOX_ANIMATION_DICTIONARY)

    local playerCoords = cache.coords
    local boxObject = GetClosestObjectOfType(playerCoords.x, playerCoords.y, playerCoords.z, 1.5, `tr_prop_tr_elecbox_01a`, false, false, false)

    local enteringScene = NetworkCreateSynchronisedScene(Config.Electrical.x, Config.Electrical.y, Config.Electrical.z, 0, 0, Config.Electrical.w, 2, true, false, 1065353216, -1, 1.0)
    NetworkAddPedToSynchronisedScene(cache.ped, enteringScene, BOX_ANIMATION_DICTIONARY, "enter", 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(boxObject, enteringScene, BOX_ANIMATION_DICTIONARY, "enter_electric_box", 4.0, -8.0, 1)

    local loopingScene = NetworkCreateSynchronisedScene(Config.Electrical.x, Config.Electrical.y, Config.Electrical.z, 0, 0, Config.Electrical.w, 2, false, true, 1065353216, -1, 1.0)
    NetworkAddPedToSynchronisedScene(cache.ped, loopingScene, BOX_ANIMATION_DICTIONARY, "loop", 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(boxObject, loopingScene, BOX_ANIMATION_DICTIONARY, "loop_electric_box", 4.0, -8.0, 1)

    local leavingScene = NetworkCreateSynchronisedScene(Config.Electrical.x, Config.Electrical.y, Config.Electrical.z, 0, 0, Config.Electrical.w, 2, true, false, 1065353216, -1, 1.0)
    NetworkAddPedToSynchronisedScene(cache.ped, leavingScene, BOX_ANIMATION_DICTIONARY, "exit", 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(boxObject, leavingScene, BOX_ANIMATION_DICTIONARY, "exit_electric_box", 4.0, -8.0, 1)

    NetworkStartSynchronisedScene(enteringScene)
    Wait(GetAnimDuration(BOX_ANIMATION_DICTIONARY, "enter") * 1000)
    NetworkStartSynchronisedScene(loopingScene)

    local hackSuccess = hack()
    TriggerServerEvent("qbx-jewelleryrobbery:server:electricalHandlerHack", hackSuccess)

    Wait(2500)
    NetworkStartSynchronisedScene(leavingScene)
    Wait(GetAnimDuration(BOX_ANIMATION_DICTIONARY, "exit") * 1000)
    NetworkStopSynchronisedScene(leavingScene)

    isHacking = false
end

local function startHackingElectricalHandler()
    local canHack = lib.callback.await("qbx-jewelleryrobbery:callback:canHackElectricalBox", 1000)

    if canHack then
        hackElectricalHandler()
    end
end

local function startRayFire(coords, rayFire)
    local object = GetRayfireMapObject(coords.x, coords.y, coords.z, 1.4, rayFire)
    SetStateOfRayfireMapObject(object, 4)
    Wait(100)
    SetStateOfRayfireMapObject(object, 6)
end

local function loadParticle()
    if not HasNamedPtfxAssetLoaded("scr_jewelheist") then
        RequestNamedPtfxAsset("scr_jewelheist")
        while not HasNamedPtfxAssetLoaded("scr_jewelheist") do Wait(0) end
    end
    UseParticleFxAsset("scr_jewelheist")
end

local function playSmashingSoundAtCoords(coords)
    local soundId = GetSoundId()
    PlaySoundFromCoord(soundId, "Glass_Smash", coords.x, coords.y, coords.z, "", false, 6.0, false)
    ReleaseSoundId(soundId)
end

local function openCabinetHandler()
    if isSmashing then return end
    isSmashing = true

    local animName
    local playerCoords = GetEntityCoords(cache.ped)

    if not Framework.IsPlayerWeaingGloves() then
        if Config.FingerDropChance > math.random(0, 100) then Framework.CreateFingerPrintEvidence(playerCoords) end
    end

    TaskAchieveHeading(cache.ped, Config.Cabinets[closestCabinet].heading, 1500)
    Wait(1500)

    lib.requestAnimDict(CABINET_ANIMATION_DICTIONARY)

    if Config.Cabinets[closestCabinet].rayFire == "DES_Jewel_Cab4" then
        animName = CABINET_ANIMATION_SMASH_FRONT[math.random(1, #CABINET_ANIMATION_SMASH_FRONT)]
        TaskPlayAnim(cache.ped, CABINET_ANIMATION_DICTIONARY, animName, 3.0, 3.0, -1, 2, 0, false, false, false)
        Wait(150)
        startRayFire(playerCoords, Config.Cabinets[closestCabinet].rayFire)
    else
        animName = CABINET_ANIMATION_SMASH_TOP[math.random(1, #CABINET_ANIMATION_SMASH_TOP)]
        TaskPlayAnim(cache.ped, CABINET_ANIMATION_DICTIONARY, animName, 3.0, 3.0, -1, 2, 0, false, false, false)
        Wait(300)
        if Config.Cabinets[closestCabinet].rayFire then
            startRayFire(playerCoords, Config.Cabinets[closestCabinet].rayFire)
        end
    end

    loadParticle()
    StartNetworkedParticleFxNonLoopedOnEntity("scr_jewel_cab_smash", GetCurrentPedWeaponEntityIndex(cache.ped), 0, 0, 0, 0, 0, 0, 1.6, false, false, false)
    playSmashingSoundAtCoords(playerCoords)
    Wait(GetAnimDuration(CABINET_ANIMATION_DICTIONARY, animName) * 850)
    ClearPedTasks(cache.ped)

    TriggerServerEvent("qbx-jewelleryrobbery:server:endCabinet")
    isSmashing = false
end

local function startSmashingCabinet(cabinetId)
    local canSmash = lib.callback.await("qbx-jewelleryrobbery:callback:canSmashCabinet", 1000, cabinetId)

    if canSmash then
        openCabinetHandler()
    end
end

if Config.UseTarget then
    exports.ox_target:addBoxZone({
        coords = vector3(Config.Electrical.x, Config.Electrical.y, Config.Electrical.z + 1.2),
        size = vector3(1.0, 1.0, 2.4),
        rotation = Config.Electrical.w,
        debug = Config.Debug,
        options = {
            {
                icon = "fab fa-usb",
                label = locale("text.electrical"),
                distance = 1.6,
                -- items = Config.Doorlock.RequiredItem,
                canInteract = function()
                    return not isHacking
                end,
                onSelect = function()
                    startHackingElectricalHandler()
                end
            }
        }
    })
else
    CreateThread(function()
        local isTextShown
        local playerCoords
        local isNearbyElectricalHandler
        local electricalHandlerCoords = vector3(Config.Electrical.x, Config.Electrical.y, Config.Electrical.z + 1.1)

        while true do
            playerCoords = cache.coords
            isNearbyElectricalHandler = false

            if #(playerCoords - electricalHandlerCoords) <= 1.5 and not isHacking then
                isNearbyElectricalHandler = true

                if not Config.UseDrawText and not isTextShown then
                    lib.showTextUI(locale("text.electrical"))
                    isTextShown = true
                else
                    DrawText3D(electricalHandlerCoords, locale("text.electrical"))
                end

                if IsControlJustReleased(0, 38) then
                    if isTextShown then lib.hideTextUI() isTextShown = false end
                    startHackingElectricalHandler()
                end
            else
                if not isNearbyElectricalHandler and isTextShown then lib.hideTextUI() isTextShown = false end
                Wait(1000)
            end

            Wait(0)
        end
    end)
end

if Config.UseTarget then
    for i = 1, #Config.Cabinets do
        exports.ox_target:addBoxZone({
            coords = Config.Cabinets[i].coords,
            size = vec3(1.2, 1.6, 1),
            rotation = Config.Cabinets[i].heading,
            debug = Config.Debug,
            options = {
                {
                    icon = "fas fa-gem",
                    label = locale("text.cabinet"),
                    distance = 0.6,
                    canInteract = function()
                        return not isSmashing
                    end,
                    onSelect = function()
                        closestCabinet = i
                        startSmashingCabinet(closestCabinet)
                    end
                }
            }
        })
    end
else
    CreateThread(function()
        local isTextShown
        local playerCoords
        local isNearbyAnyCabinet

        while true do
            playerCoords = cache.coords
            isNearbyAnyCabinet = false

            for i = 1, #Config.Cabinets do
                local distanceToCabinet = #(playerCoords - Config.Cabinets[i].coords)

                if distanceToCabinet < 0.5 then
                    isNearbyAnyCabinet = true
                    closestCabinet = closestCabinet or i

                    if distanceToCabinet < #(playerCoords - Config.Cabinets[closestCabinet].coords) then
                        closestCabinet = i
                    end
                end
            end

            if isNearbyAnyCabinet and not (isSmashing or Config.Cabinets[closestCabinet].isOpened) then
                if not Config.UseDrawText and not isTextShown then
                    lib.showTextUI(locale("text.cabinet"))
                    isTextShown = true
                else
                    DrawText3D(Config.Cabinets[closestCabinet].coords, locale("text.cabinet"))
                end
                if IsControlJustReleased(0, 38) then
                    if isTextShown then lib.hideTextUI() isTextShown = false end
                    startSmashingCabinet(closestCabinet)
                end
            else
                if not isNearbyAnyCabinet and isTextShown then lib.hideTextUI() isTextShown = false end
                Wait(1000)
            end

            Wait(0)
        end
    end)
end

RegisterNetEvent("qbx-jewelleryrobbery:client:syncEffects", function(cabinetId, OriginalPlayer)
    Wait(1500)
    
    if Config.Cabinets[cabinetId].rayFire == "DES_Jewel_Cab4" then
        Wait(150)
        startRayFire(Config.Cabinets[cabinetId].coords, Config.Cabinets[cabinetId].rayFire)
    elseif Config.Cabinets[cabinetId].rayFire then
        Wait(300)
        startRayFire(Config.Cabinets[cabinetId].coords, Config.Cabinets[cabinetId].rayFire)
    end

    loadParticle()
    StartNetworkedParticleFxNonLoopedOnEntity("scr_jewel_cab_smash", GetCurrentPedWeaponEntityIndex(GetPlayerPed(GetPlayerFromServerId(OriginalPlayer))), 0, 0, 0, 0, 0, 0, 1.6, false, false, false)
    playSmashingSoundAtCoords(Config.Cabinets[cabinetId].coords)
end)

RegisterNetEvent("qbx-jewelleryrobbery:client:syncConfig", function(Cabinets)
    Config.Cabinets = Cabinets
end)

RegisterNetEvent("qbx-jewelleryrobbery:client:alarm", function()
    PrepareAlarm("JEWEL_STORE_HEIST_ALARMS")
    Wait(100)
    StartAlarm("JEWEL_STORE_HEIST_ALARMS", false)
    Wait(Config.AlarmDuration)
    StopAlarm("JEWEL_STORE_HEIST_ALARMS", true)
end)

CreateThread(function()
    while true do
        if #(cache.coords - Config.Location.Coords) <= Config.Location.Range then
            for i = 1, #Config.Cabinets do
                local object = GetRayfireMapObject(Config.Cabinets[i].coords.x, Config.Cabinets[i].coords.y, Config.Cabinets[i].coords.z, 1.4, Config.Cabinets[i].rayFire)
                local objectRayfireState = GetStateOfRayfireMapObject(object) - 1
                if Config.Cabinets[i].isOpened and objectRayfireState == 2 then
                    SetStateOfRayfireMapObject(object, 9)
                elseif not Config.Cabinets[i].isOpened and objectRayfireState == 9 then
                    SetStateOfRayfireMapObject(object, 2)
                end
            end
        end
        Wait(5000)
    end
end)

do
    if Config.Location.Blip.Active then
        local blipCoords = Config.Location.Coords
        local blip = AddBlipForCoord(blipCoords.x, blipCoords.y, blipCoords.z)
        SetBlipSprite(blip, Config.Location.Blip.Type)
        SetBlipScale(blip, Config.Location.Blip.Size)
        SetBlipColour(blip, Config.Location.Blip.Color)
        SetBlipAsShortRange(blip, true)
        AddTextEntry(Config.Location.Blip.Name, Config.Location.Blip.Name)
        BeginTextCommandSetBlipName(Config.Location.Blip.Name)
        EndTextCommandSetBlipName(blip)
    end
end

if GetResourceMetadata(GetCurrentResourceName(), "shared_script", GetNumResourceMetadata(GetCurrentResourceName(), "shared_script") - 1) == "configs/kambi.lua" then
    -- Add more functionality later
end
