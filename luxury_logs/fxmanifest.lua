fx_version "adamant"

game "gta5"

-- Server
server_scripts {
	'@es_extended/locale.lua',
	'en.lua',
	'config.lua',
	'server.lua'
}

-- Client
client_scripts {
	'@es_extended/locale.lua',
	'en.lua',
	'client.lua'
}

'@mysql-async/lib/MySQL.lua'