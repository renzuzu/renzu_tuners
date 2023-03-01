fx_version 'cerulean'
lua54 'yes'
game 'gta5' 
shared_script '@ox_lib/init.lua'
ui_page {
    'web/index.html',
}
client_scripts {
	'config.lua',
	'init.lua',
	'client/function/*.lua',
	'client/handlers/*.lua',
	'client/main.lua',
	'client/function/exports/client.lua'
}
server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'config.lua',
	'server/inventory.lua',
	'server/job.lua',
	'server/main.lua'
}
files {
	'web/index.html',
	'web/script.js',
	'web/style.css',
}

dependencies {
	'/server:5848',
	'/onesync',
	'ox_lib',
}