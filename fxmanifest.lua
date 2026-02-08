fx_version 'cerulean'
game 'gta5'

name 'Fivem-standalone-radio'
author 'OpenAI'
description 'Standalone/ESX radio with word filtering'
version '1.0.0'

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/app.js'
}

shared_scripts {
    'config.lua'
}

client_scripts {
    'client.lua'
}

server_scripts {
    'server.lua'
}
