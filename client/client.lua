RegisterNetEvent('qb-pmi:open')
AddEventHandler('qb-pmi:open', function()
    QBCore.Functions.TriggerCallback('qb-pmi:server:getmdtdata', function(mdtData)
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

RegisterNetEvent('qb-pmi:close')
AddEventHandler('qb-pmi:close', function()
    --SetNuiFocus(false, false)
    SendNUIMessage({
        close = true
    })
end)

RegisterNetEvent('qb-pmi:updateOfficer')
AddEventHandler('qb-pmi:updateOfficer', function(citId, officer)
    SendNUIMessage({
        type = "officerUpdate",
        citId = citId,
        officer = officer,
    })
end)

RegisterNetEvent('qb-pmi:updatePvehicles')
AddEventHandler('qb-pmi:updatePvehicles', function(pvehicles)
    SendNUIMessage({
        type = "pvehiclesUpdate",
        pvehicles = pvehicles,
    })
end)

RegisterNetEvent('qb-pmi:returnGetRecord')
AddEventHandler('qb-pmi:returnGetRecord', function(player)
    SendNUIMessage({
        type = "recordRequestResult",
        player = player,
    })
end)

RegisterNUICallback('close', function(data)
    SetNuiFocus(false, false)
end)

RegisterNUICallback('dutyToggle', function(data)
    TriggerServerEvent('QBCore:ToggleDuty')
    TriggerServerEvent('qb-pmi:server:updateDuty')
end)

RegisterNUICallback('toggleInVehicle', function(data)
    TriggerServerEvent('qb-pmi:server:toggleInVehicle', data)
end)

RegisterNUICallback('storeVehicle', function(plate)
    TriggerServerEvent('qb-pmi:server:vehicleStore', plate)
end)
