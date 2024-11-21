local QBCore = exports['qb-core']:GetCoreObject()
local isLoading = false

CreateThread(function()
    if not isLoading then
        isLoading = true
        Wait(2000) 
        TriggerServerEvent('character:loadUserData', {})
    end
end)

RegisterNetEvent('character:client:onPlayerLoaded', function(data)
    isLoading = false 
end)

RegisterNetEvent('character:client:showRegistrationMenu', function()
    SendNUIMessage({
        action = "show"
    })
    SetNuiFocus(true, true)
end)

RegisterNUICallback('submit', function(data, cb)
    TriggerServerEvent('character:createCharacter', {
        firstname = data.firstname,
        lastname = data.lastname, 
        gender = data.gender
    })
    cb('ok')
    SetNuiFocus(false, false)
    TriggerEvent('qb-clothing:client:openMenu')
end)



