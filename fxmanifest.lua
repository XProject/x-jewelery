fx_version  "cerulean"
use_experimental_fxv2_oal   "yes"
lua54       "yes"
game        "gta5"

name        "x-jewelleryrobbery"
version     "1.0.0"
description "Qbox Jewellery Robbery"
repository  "https://github.com/Qbox-project/qbx-jewelleryrobbery"

files {
    "locales/*.json",
}

shared_scripts {
    "@ox_lib/init.lua",
    "bridge/**/*shared*.lua",
    "configs/default.lua"
}

client_script {
    "bridge/**/*client*.lua",
    "client/*.lua"
}

client_script {
    "bridge/**/*server*.lua",
    "server/*.lua"
}