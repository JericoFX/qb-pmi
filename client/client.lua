RegisterNetEvent('nag-mdt:open')
AddEventHandler('nag-mdt:open', function()
    QBCore.Functions.TriggerCallback('nag-mdt:server:getmdtdata', function(mdtData)
        SetNuiFocus(true, true)
        SendNUIMessage({
            officers = mdtData.officers,
            identifier = GetPlayerServerId(PlayerId()),
            duty = mdtData.duty,
            citizenId = mdtData.citizenId,
            pvehicles = mdtData.pvehicles,
            open = true,
        })
    end)
end)

RegisterNetEvent('nag-mdt:close')
AddEventHandler('nag-mdt:close', function()
    --SetNuiFocus(false, false)
    SendNUIMessage({
        close = true
    })
end)

RegisterNetEvent('nag-mdt:setOfficerDuty')
AddEventHandler('nag-mdt:setOfficerDuty', function(citId, duty)
    SendNUIMessage({
        type = "dutyUpdate",
        citId = citId,
        duty = duty,
    })
end)

RegisterNetEvent('nag-mdt:updatePvehicles')
AddEventHandler('nag-mdt:updatePvehicles', function(pvehicles)
    SendNUIMessage({
        type = "pvehiclesUpdate",
        pvehicles = pvehicles,
    })
end)

RegisterNUICallback('close', function(data)
    SetNuiFocus(false, false)
end)

RegisterNUICallback('dutyToggle', function(data)
    TriggerServerEvent('QBCore:ToggleDuty')
    TriggerServerEvent('nag-mdt:server:updateDuty')
end)

RegisterNUICallback('toggleInVehicle', function(data)
    TriggerServerEvent('nag-mdt:server:toggleInVehicle', data)
end)

RegisterNUICallback('storeVehicle', function(plate)
    TriggerServerEvent('nag-mdt:server:vehicleStore', plate)
end)
