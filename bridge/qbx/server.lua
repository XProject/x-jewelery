if Framework.Initials ~= "qbx" then return end

Framework.GetPlayerFromSource = Framework.Object.Functions.GetPlayer --[[@as function]]

function Framework.GetOnlineCopsAmount()
    return Framework.Object.Functions.GetDutyCountType('leo')
end

function Framework.DoesPlayerHaveItem(player, itemName, itemAmount)
    if not player or not itemName then return false end

    itemAmount = itemAmount or 1
    local playerItem = player.Functions.GetItemByName(itemName)

    return playerItem and playerItem?.count >= itemAmount or false
end

function Framework.AddItemToPlayer(player, itemName, itemAmount)
    if not player or not itemName then return false end

    itemAmount = itemAmount or 1

    return player.Functions.AddItem(itemName, itemAmount)
end

function Framework.RemoveItemFromPlayer(player, itemName, itemAmount)
    if not player or not itemName then return false end

    itemAmount = itemAmount or 1

    return player.Functions.RemoveItem(itemName, itemAmount)
end

function Framework.GetItemLabel(itemName)
    return exports["ox_inventory"]:Items(itemName)?.label
end

function Framework.GetAllPlayers()
    return Framework.Object.Functions.GetQBPlayers()
end