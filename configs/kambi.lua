Config = {}

Config.Debug = false
Config.Location = {
    Coords = vector3(0.0, 0.0, 0.0),
    Range = 25.0,
    Blip = {
        Active = true,
        Name = "Vangelico Jewellery",
        Type = 617,
        Color = 5,
        Size = 0.8
    },
}
Config.Timeout =  45 * 60 -- 45 minutes(2700 seconds)
Config.MinimumCops = 2
Config.NotEnoughCopsNotify = true
Config.Electrical = vector4(-462.06, -64.46, 49.0, 131)
Config.FingerDropChance = 60
Config.UseDrawText = false
Config.UseTarget = false
Config.AlarmDuration = 240000
Config.Doorlock = {
    Name = 'vangelico_jewellery',
    HackTime = {
        Min = 20,
        Max = 60
    },
    RequiredItem =  'electronickit',
    LoseItemOnUse = true,
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
        coords = vector3(-453.66, -76.95, 41.29),
        isOpened = false,
        isBusy = false,
        heading = 130.0
    },
    [2] = {
        coords = vector3(-454.91, -75.42, 41.29),
        isOpened = false,
        isBusy = false,
        heading = 130.0
    },
    [3] = {
        coords = vector3(-456.1, -73.9, 41.29),
        isOpened = false,
        isBusy = false,
        heading = 130.0
    },
    [4] = {
        coords = vector3(-457.38, -72.39, 41.29),
        isOpened = false,
        isBusy = false,
        heading = 130.0
    },
    [5] = {
        coords = vector3(-458.6, -70.87, 41.29),
        isOpened = false,
        isBusy = false,
        heading = 130.0
    },
    [6] = {
        coords = vector3(-459.84, -69.35, 41.29),
        isOpened = false,
        isBusy = false,
        heading = 130.0
    },
    [7] = {
        coords = vector3(-448.37, -72.7, 41.29),
        isOpened = false,
        isBusy = false,
        heading = 310.0
    },
    [8] = {
        coords = vector3(-449.61, -71.16, 41.29),
        isOpened = false,
        isBusy = false,
        heading = 310.0
    },
    [9] = {
        coords = vector3(-450.84, -69.67, 41.29),
        isOpened = false,
        isBusy = false,
        heading = 310.0
    },
    [10] = {
        coords = vector3(-452.13, -68.11, 41.29),
        isOpened = false,
        isBusy = false,
        heading = 310.0
    },
    [11] = {
        coords = vector3(-453.3, -66.62, 41.29),
        isOpened = false,
        isBusy = false,
        heading = 310.0
    },
    [12] = {
        coords = vector3(-454.63, -65.08, 41.29),
        isOpened = false,
        isBusy = false,
        heading = 310.0
    },
    [13] = {
        coords = vector3(-451.44, -73.17, 41.29),
        isOpened = false,
        isBusy = false,
        heading = 40.0
    },
    [14] = {
        coords = vector3(-452.7, -74.22, 41.29),
        isOpened = false,
        isBusy = false,
        heading = 40.0
    },
    [15] = {
        coords = vector3(-455.05, -73.11, 41.29),
        isOpened = false,
        isBusy = false,
        heading = 310.0
    },
    [16] = {
        coords = vector3(-455.5, -70.56, 41.29),
        isOpened = false,
        isBusy = false,
        heading = 220.0
    },
    [17] = {
        coords = vector3(-454.35, -69.64, 41.29),
        isOpened = false,
        isBusy = false,
        heading = 220.0
    },
}
