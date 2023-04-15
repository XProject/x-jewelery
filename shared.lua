Shared = {}

Shared.isServer = IsDuplicityVersion()

Shared.currentResourceName = GetCurrentResourceName()

---@param message string
---@param type string
---@param source integer | nil
function Shared.showNotification(message, type, source)
    local notifyObject = {
        title = "Jewellery",
        description = message,
        type = type,
        duration = 5000
    }

    if isServer then
        ---@diagnostic disable-next-line: param-type-mismatch
        return TriggerClientEvent("ox_lib:notify", source, notifyObject)
    end

    return lib.notify(notifyObject)
end

lib.locale() -- initialise the ox_lib's locale module
