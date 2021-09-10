# nag-mdt

## Project setup
```
npm install
```

### Compiles and hot-reloads for development
```
npm run serve
```

### Compiles and minifies for production
```
npm run build
```

### Customize configuration
See [Configuration Reference](https://cli.vuejs.org/config/).

### Functions to add in other resources
These functions need to be added to other resources in order for mdt functionality to work fully
#### qb-policejob/client/main.lua
```
RegisterNetEvent('police:client:setDuty')
AddEventHandler('police:client:setDuty', function(duty)
    if(PlayerJob.name == nil) then
        PlayerJob = QBCore.Functions.GetPlayerData().job
    end
    onDuty = duty
end)
```
#### qb-policejob/client/job.lua
Modify TakeOutVehicle function with 
```
TriggerServerEvent("nag-mdt:server:vehicleTakeout", GetVehicleNumberPlateText(veh), vehicleInfo)
```
Example of what this looks like, the line was added on line 12
```
--Example of what this looks like, the line was added on line 12
1  function TakeOutVehicle(vehicleInfo)
2     local coords = Config.Locations["vehicle"][currentGarage]
3     QBCore.Functions.SpawnVehicle(vehicleInfo, function(veh)
4         SetVehicleNumberPlateText(veh, "UNIT"..tostring(math.random(1000, 9999)))
5         SetEntityHeading(veh, coords.w)
6         exports['LegacyFuel']:SetFuel(veh, 100.0)
7         closeMenuFull()
8         TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
9         TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(veh))
10        TriggerServerEvent("inventory:server:addTrunkItems", GetVehicleNumberPlateText(veh), Config.CarItems)
11        SetVehicleEngineOn(veh, true, true)
12        TriggerServerEvent("nag-mdt:server:vehicleTakeout", GetVehicleNumberPlateText(veh), vehicleInfo)
13    end, coords, true)
14 end
```
Then in the same file find ``for k, v in pairs(Config.Locations["vehicle"]) do`` and add the following before QBCore.Functions.DeleteVehicle
```
TriggerServerEvent("nag-mdt:server:vehicleStore", GetVehicleNumberPlateText(GetVehiclePedIsIn(PlayerPedId())))
```

```
for k, v in pairs(Config.Locations["vehicle"]) do
                    if #(pos - vector3(v.x, v.y, v.z)) < 7.5 then
                         if onDuty then
                             DrawMarker(2, v.x, v.y, v.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 0, 0, 222, false, false, false, true, false, false, false)
                             if #(pos - vector3(v.x, v.y, v.z)) < 1.5 then
                                 if IsPedInAnyVehicle(PlayerPedId(), false) then
                                     DrawText3D(v.x, v.y, v.z, "~g~E~w~ - Store vehicle")
                                 else
                                     DrawText3D(v.x, v.y, v.z, "~g~E~w~ - Vehicles")
                                 end
                                 if IsControlJustReleased(0, 38) then
                                     if IsPedInAnyVehicle(PlayerPedId(), false) then
                                        TriggerServerEvent("nag-mdt:server:vehicleStore", GetVehicleNumberPlateText(GetVehiclePedIsIn(PlayerPedId())))
                                        QBCore.Functions.DeleteVehicle(GetVehiclePedIsIn(PlayerPedId()))
                                     else
                                         MenuGarage()
                                         currentGarage = k
                                         Menu.hidden = not Menu.hidden
                                     end
                                 end
                                 Menu.renderGUI()
                             end  
                         end
                     end
                end
```