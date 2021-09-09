fx_version 'adamant'

game 'gta5'

ui_page 'client/html/index.html'

shared_scripts {
	'@qb-core/import.lua',
	'Config.lua'
}

server_scripts {
	'server/server.lua'
}

client_scripts {
	'client/functions.lua',
	'client/client.lua'
}

files {
	'client/html/img/*',
    'client/html/css/chunk-vendors.css',
	'client/html/js/about.js',
	'client/html/js/app.js',
	'client/html/js/chunk-vendors.js',
	'client/html/index.html',
    'client/html/favicon.ico',
}