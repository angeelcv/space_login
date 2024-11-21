fx_version 'cerulean'
game 'gta5'

version '1.0.0'

server_script '@mysql-async/lib/MySQL.lua'
server_script 'server/main.lua'
client_script 'client/main.lua'
ui_page 'html/index.html'

files {
    'html/index.html',
    'html/script.js',
    'html/style.css'
}
