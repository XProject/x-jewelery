Framework = {}

if GetResourceState("qbx-core"):find("start") then
    Framework.Initials = "qbx"
    Framework.ResourceName = "qbx-core"
    Framework.Object = exports[Framework.ResourceName]:GetCoreObject()
elseif GetResourceState("es_extended"):find("start") then
    Framework.Initials = "esx"
    Framework.ResourceName = "es_extended"
    Framework.Object = exports[Framework.ResourceName]:getSharedObject()
end