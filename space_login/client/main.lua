local isRegistered = false

CreateThread(function()
    Wait(1000) 
    TriggerServerEvent('character:checkRegistration')
    TriggerServerEvent('character:loadData')
end)

RegisterNetEvent('character:showRegistrationMenu', function()
    print("Mostrando NUI de registro")
    SendNUIMessage({
        action = "show"
    })
    SetNuiFocus(true, true)
end)

RegisterNUICallback('submit', function(data, cb)
    SetNuiFocus(false, false)
    SendNUIMessage({
        action = "hide"
    })

    TriggerServerEvent('character:save', data)
    cb('ok')
end)

RegisterNetEvent('character:registrationComplete', function(name, gender)
    isRegistered = true
    print("Registro completado con éxito. Cargando jugador:", name, gender)
    
end)

RegisterNetEvent('character:loadPlayer', function(name, gender)
    print("Cargando personaje existente:", name, gender)
end)


RegisterNetEvent('character:receiveData', function(data)
    print("Datos cargados:", data.name, data.gender)
end)

RegisterNetEvent('character:showRegistrationMenu', function()
    print("Mostrando menú de registro")
    SendNUIMessage({
        action = "show"
    })
    SetNuiFocus(true, true)
end)
