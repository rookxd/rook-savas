shared_script '@fiveguard/ai_module_fg-obfuscated.lua'
shared_script '@fiveguard/shared_fg-obfuscated.lua'
shared_script '@MasonGuard/ai_module_fg-obfuscated.lua'
shared_script '@MasonGuard/shared_fg-obfuscated.lua'
fx_version 'cerulean'
games { 'gta5' }
client_scripts{
    '@PolyZone/client.lua',
    '@PolyZone/BoxZone.lua',
    '@PolyZone/EntityZone.lua',
    '@PolyZone/CircleZone.lua',
    '@PolyZone/ComboZone.lua',
    'client/*.lua',
}
server_scripts{
    'server/*.lua',
    '@oxmysql/lib/MySQL.lua',
}

shared_scripts {
    'config.lua'
}

files {
    'html/*.html',
    'html/*.js',
    'html/*.css',
    'html/fonts/*.ttf',
    'html/fonts/*.otf',
    'html/fonts/*.woff',
    'html/weapons/*.png',
    'html/animations/*.mp4',
}