fx_version 'adamant'

game 'gta5'

description 'Rewpparo - sit with OX_Target'
lua54 'yes'
version '0.0.0'

shared_scripts {
	'@es_extended/imports.lua',
	'config.lua'
}

client_scripts {
    'client.lua',
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
    'server.lua',
}

dependencies {
	'es_extended',
	'ox_target',
}
