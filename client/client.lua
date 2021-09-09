RegisterNetEvent('nag-mdt:open')
AddEventHandler('nag-mdt:open', function()
    QBCore.Functions.TriggerCallback('nag-mdt:server:getmdtdata', function(mdtData)
        SetNuiFocus(true, true)
        SendNUIMessage({
            officers = mdtData.officers,
            identifier = GetPlayerServerId(PlayerId()),
            duty = mdtData.duty,
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

RegisterNUICallback('close', function(data)
    SetNuiFocus(false, false)
end)