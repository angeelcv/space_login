local QBCore = exports['qb-core']:GetCoreObject()
local hasDonePreloading = {}

AddEventHandler('QBCore:Server:PlayerLoaded', function(Player)
    Wait(1000) 
    hasDonePreloading[Player.PlayerData.source] = true
end)

AddEventHandler('QBCore:Server:OnPlayerUnload', function(src)
    hasDonePreloading[src] = false
end)

RegisterNetEvent('character:loadUserData', function(cData)
    local src = source
    local identifiers = GetPlayerIdentifiers(src)
    local license = QBCore.Functions.GetIdentifier(src, 'license')

    if not license then
        return
    end

    MySQL.query('SELECT citizenid, charinfo FROM players WHERE license = ?', {license}, function(result)
        if result[1] then
            local citizenid = result[1].citizenid
            local charinfo = json.decode(result[1].charinfo)

            if not charinfo or not charinfo.firstname or not charinfo.lastname or not charinfo.gender then
                TriggerClientEvent('character:client:showRegistrationMenu', src)
            else
                local name = charinfo.firstname .. " " .. charinfo.lastname
                local gender = charinfo.gender
                if QBCore.Player.Login(src, citizenid) then
                    repeat
                        Wait(10)
                    until hasDonePreloading[src]

                    QBCore.Commands.Refresh(src)

                    TriggerClientEvent('character:client:onPlayerLoaded', src, {
                        name = name,
                        gender = gender,
                        citizenid = citizenid
                    })
                else
                end
            end
        else
            TriggerClientEvent('character:client:showRegistrationMenu', src)
        end
    end)
end)


local function CreateCitizenId()
    local charset = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    local citizenid = ""
    for i = 1, 6 do
        local rand = math.random(1, #charset)
        citizenid = citizenid .. charset:sub(rand, rand)
    end
    return "CID" .. citizenid
end


RegisterNetEvent('character:createCharacter', function(data)
    local src = source
    local identifiers = GetPlayerIdentifiers(src)
    local license = QBCore.Functions.GetIdentifier(src, 'license')

    if not license then
        return
    end

    MySQL.query('SELECT * FROM players WHERE license = ?', {license}, function(result)
        if result[1] then
            local charinfo = json.encode({
                firstname = data.firstname or "", 
                lastname = data.lastname or "",
                gender = data.gender or ""
            })

            MySQL.update('UPDATE players SET charinfo = ? WHERE license = ?', {charinfo, license}, function(affectedRows)
                if affectedRows > 0 then
                    print('Datos actualizados correctamente.')
                else
                    print('Error al actualizar los datos.')
                end
            end)
        else
            local citizenid = CreateCitizenId()
            local charinfo = json.encode({
                firstname = data.firstname or "", 
                lastname = data.lastname or "",
                gender = data.gender or ""
            })

            MySQL.insert('INSERT INTO players (license, citizenid, charinfo) VALUES (?, ?, ?)', {
                license,
                citizenid,
                charinfo
            }, function(insertId)
                if insertId then
                else
                end
            end)

        end
    end)
end)

