Config = {}

Config.Debug = true
Config.Location = {
    Coords = vector3(-622.127, -230.927, 38.1),
    Range = 25.0,
    Blip = {
        Active = true,
        Name = "Vangelico Jewellery",
        Type = 617,
        Color = 5,
        Size = 0.8
    },
}
Config.Timeout = 2700000
Config.MinimumCops = 0
Config.NotEnoughCopsNotify = true
Config.Electrical = vector4(-624.295, -215.22, 52.54, 118.0)
Config.FingerDropChance = 60
Config.UseDrawText = false
Config.UseTarget = true
Config.AlarmDuration = 240000
Config.Doorlock = {
    Name = 'vangelico_jewellery',
    HackTime = {
        Min = 20,
        Max = 60
    },
    RequiredItem =  'electronickit',
    LoseItemOnUse = false,
}

Config.Reward = {
    MinAmount = 1,
    MaxAmount = 2,
    Items = {
        [1] = {
            Name = 'rolex',
            Min = 1,
            Max = 4
        },
        [2] = {
            Name = 'diamond_ring',
            Min = 1,
            Max = 4
        },
        [3] = {
            Name = 'goldchain',
            Min = 1,
            Max = 4
        },
        [4] = {
            Name = '10kgoldchain',
            Min = 1,
            Max = 2
        }
    }
}

Config.AllowedWeapons = {
    [`weapon_smg`] = true,
    [`weapon_combatpdw`] = true,
    [`weapon_gusenberg`] = true,

    [`weapon_pumpshotgun`] = true,
    [`weapon_pumpshotgun_mk2`] = true,
    [`weapon_sawnoffshotgun`] = true,
    [`weapon_assaultshotgun`] = true,
    [`weapon_bullpupshotgun`] = true,
    [`weapon_musket`] = true,
    [`weapon_heavyshotgun`] = true,
    [`weapon_dbshotgun`] = true,
    [`weapon_autoshotgun`] = true,
    [`weapon_combatshotgun`] = true,

    [`weapon_assaultrifle`] = true,
    [`weapon_assaultrifle_mk2`] = true,
    [`weapon_carbinerifle`] = true,
    [`weapon_carbinerifle_mk2`] = true,
    [`weapon_advancedrifle`] = true,
    [`weapon_specialcarbine`] = true,
    [`weapon_specialcarbine_mk2`] = true,
    [`weapon_bullpuprifle`] = true,
    [`weapon_bullpuprifle_mk2`] = true,
    [`weapon_compactrifle`] = true,
    [`weapon_militaryrifle`] = true,
    [`weapon_heavyrifle`] = true,
    [`weapon_tacticalrifle`] = true,
}

Config.Cabinets = {
    [1] = {
        coords = vector3(-626.83, -235.35, 38.05),
        isOpened = false,
        isBusy = false,
        rayFire = 'DES_Jewel_Cab3',
        heading = 36.17
    },
    [2] = {
        coords = vector3(-625.81, -234.7, 38.05),
        isOpened = false,
        isBusy = false,
        rayFire = 'DES_Jewel_Cab4',
        heading = 36.17
    },
    [3] = {
        coords = vector3(-626.95, -233.14, 38.05),
        isOpened = false,
        isBusy = false,
        rayFire = 'DES_Jewel_Cab',
        heading = 216.17
    },
    [4] = {
        coords = vector3(-628.0, -233.86, 38.05),
        isOpened = false,
        isBusy = false,
        rayFire = 'DES_Jewel_Cab',
        heading = 216.17
    },
    [5] = {
        coords = vector3(-625.7, -237.8, 38.05),
        isOpened = false,
        isBusy = false,
        rayFire = 'DES_Jewel_Cab3',
        heading = 216.17
    },
    [6] = {
        coords = vector3(-626.7, -238.58, 38.05),
        isOpened = false,
        isBusy = false,
        rayFire = 'DES_Jewel_Cab2',
        heading = 216.17
    },
    [7] = {
        coords = vector3(-624.55, -231.06, 38.05),
        isOpened = false,
        isBusy = false,
        rayFire = 'DES_Jewel_Cab4',
        heading = 305.0
    },
    [8] = {
        coords = vector3(-623.13, -232.94, 38.05),
        isOpened = false,
        isBusy = false,
        rayFire = 'DES_Jewel_Cab',
        heading = 305.0
    },
    [9] = {
        coords = vector3(-620.29, -234.44, 38.05),
        isOpened = false,
        isBusy = false,
        rayFire = 'DES_Jewel_Cab',
        heading = 216.17
    },
    [10] = {
        coords = vector3(-619.15, -233.66, 38.05),
        isOpened = false,
        isBusy = false,
        rayFire = 'DES_Jewel_Cab3',
        heading = 216.17
    },
    [11] = {
        coords = vector3(-620.19, -233.44, 38.05),
        isOpened = false,
        isBusy = false,
        rayFire = 'DES_Jewel_Cab4',
        heading = 36.17
    },
    [12] = {
        coords = vector3(-617.63, -230.58, 38.05),
        isOpened = false,
        isBusy = false,
        rayFire = 'DES_Jewel_Cab2',
        heading = 305.0
    },
    [13] = {
        coords = vector3(-618.33, -229.55, 38.05),
        isOpened = false,
        isBusy = false,
        rayFire = 'DES_Jewel_Cab3',
        heading = 305.0
    },
    [14] = {
        coords = vector3(-619.7, -230.33, 38.05),
        isOpened = false,
        isBusy = false,
        rayFire = 'DES_Jewel_Cab',
        heading = 125.0
    },
    [15] = {
        coords = vector3(-620.95, -228.6, 38.05),
        isOpened = false,
        isBusy = false,
        rayFire = 'DES_Jewel_Cab3',
        heading = 125.0
    },
    [16] = {
        coords = vector3(-619.79, -227.6, 38.05),
        isOpened = false,
        isBusy = false,
        rayFire = 'DES_Jewel_Cab2',
        heading = 305.0
    },
    [17] = {
        coords = vector3(-620.42, -226.6, 38.05),
        isOpened = false,
        isBusy = false,
        rayFire = 'DES_Jewel_Cab',
        heading = 305.0
    },
    [18] = {
        coords = vector3(-623.94, -227.18, 38.05),
        isOpened = false,
        isBusy = false,
        rayFire = 'DES_Jewel_Cab4',
        heading = 36.17
    },
    [19] = {
        coords = vector3(-624.91, -227.87, 38.05),
        isOpened = false,
        isBusy = false,
        rayFire = 'DES_Jewel_Cab3',
        heading = 36.17
    },
    [20] = {
        coords = vector3(-623.94, -228.05, 38.05),
        isOpened = false,
        isBusy = false,
        rayFire = 'DES_Jewel_Cab2',
        heading = 216.17
    }
}
