local QBCore = exports['qb-core']:GetCoreObject()

AddEventHandler('playerConnecting', function(name, setKickReason, deferrals)
    print("playerConnecting ejecutado para:", name) 
    local src = source
    local identifiers = GetPlayerIdentifiers(src)
    local license = identifiers[1]

    if not license then
        print("Error: No se pudo obtener la licencia del jugador.")
        setKickReason("No se encontró una licencia válida.")
        CancelEvent()
        return
    end

    deferrals.defer()
    deferrals.update("Verificando datos de tu cuenta...")

    exports['ghmattimysql']:scalar('SELECT citizenid FROM players WHERE license = ?', { license }, function(citizenid)
        if not citizenid then
            local newCitizenID = 'CID' .. math.random(1000, 9999) .. tostring(os.time())
            print("Generando CitizenID para jugador nuevo:", newCitizenID)

            exports['ghmattimysql']:execute('INSERT INTO players (license, citizenid) VALUES (?, ?)', { license, newCitizenID }, function()
                print("Datos iniciales guardados para el jugador:", license)
                deferrals.done()
            end)
        else
            print("Jugador ya registrado con CitizenID:", citizenid)
            deferrals.done()
        end
    end)
end)



RegisterNetEvent('character:checkRegistration', function()
    local src = source
    local identifiers = GetPlayerIdentifiers(src)
    local license = identifiers[1]

    if not license then
        print("Error: No se pudo obtener la licencia del jugador en character:checkRegistration")
        return
    end

    exports['ghmattimysql']:execute('SELECT name, gender FROM players WHERE license = ?', { license }, function(result)
        if result[1] then
            local playerName = result[1].name
            local playerGender = result[1].gender

            if not playerName or playerName == '' or not playerGender or playerGender == '' then
                print("Faltan datos de registro para el jugador:", license)
                TriggerClientEvent('character:showRegistrationMenu', src)
            else
                print("Jugador ya tiene todos los datos registrados:", playerName, playerGender)
            end
        else
            print("No se encontraron datos para la licencia:", license)
            TriggerClientEvent('character:showRegistrationMenu', src)
        end
    end)
end)

RegisterNetEvent('character:save', function(data)
    local src = source
    local identifiers = GetPlayerIdentifiers(src)
    local license = identifiers[1]

    if not license then
        print("Error: No se pudo obtener la licencia del jugador en character:save")
        return
    end

    local name = data.name
    local gender = data.gender

    exports['ghmattimysql']:execute('UPDATE players SET name = ?, gender = ? WHERE license = ?', {
        name, gender, license
    }, function()
        print("Datos registrados para:", name, gender)
        TriggerClientEvent('character:registrationComplete', src)
    end)
end)


RegisterNetEvent('character:loadData', function()
    local src = source
    local identifiers = GetPlayerIdentifiers(src)
    local license = identifiers[1]

    if not license then
        print("Error: No se pudo obtener la licencia del jugador en character:loadData")
        return
    end

    exports['ghmattimysql']:execute('SELECT name, gender FROM players WHERE license = ?', { license }, function(result)
        if result[1] then
            local data = {
                name = result[1].name,
                gender = result[1].gender,
            }
            TriggerClientEvent('character:receiveData', src, data)
        else
            TriggerClientEvent('character:showRegistrationMenu', src)
        end
    end)
end)

