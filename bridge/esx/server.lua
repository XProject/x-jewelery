if Framework.Initials ~= "esx" then return end

Framework.GetPlayerFromSource = Framework.Object.GetPlayerFromId --[[@as function]]

function Framework.GetOnlineCopsAmount()
    return #Framework.Object.GetExtendedPlayers("job", "police")
end

function Framework.DoesPlayerHaveItem(player, itemName, itemAmount)
    if not player or not itemName then return false end

    itemAmount = itemAmount or 1
    local playerItem = player.getInventoryItem(itemName)

    return playerItem and playerItem?.count >= itemAmount or false
end

function Framework.AddItemToPlayer(player, itemName, itemAmount)
    if not player or not itemName then return false end

    itemAmount = itemAmount or 1

    return player.addInventoryItem(itemName, itemAmount)
end

function Framework.RemoveItemFromPlayer(player, itemName, itemAmount)
    if not player or not itemName then return false end

    itemAmount = itemAmount or 1

    return player.removeInventoryItem(itemName, itemAmount)
end

function Framework.GetItemLabel(itemName)
    return exports["ox_inventory"]:Items(itemName)?.label
end

function Framework.GetAllPlayers()
    return Framework.Object.GetExtendedPlayers()
end