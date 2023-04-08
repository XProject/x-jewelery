if Framework.Initials ~= "qbx" then return end

Framework.IsPlayerWeaingGloves = Framework.Object.Functions.IsWearingGloves --[[@as function]]

function Framework.CreateFingerPrintEvidence(coords)
    coords = coords or GetEntityCoords(cache.ped)
    TriggerServerEvent("evidence:server:CreateFingerDrop", coords)
end