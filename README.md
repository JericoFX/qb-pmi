# THIS IS NOT MY WORK, I FORKED IT AND THE ORIGINAL OWNER DELETE THE REPO OR MADE IT PRIVATE if you are the owner please contact me and i will take it down or give proper credits

# Police Management Interface: qb-pmi [WIP]
This PMI was built for the purpose of getting rid of all the other google sheets and discord channels we were using to keep track of police things. Not all features might make sense for your server.

## WIP
Development of this resources is still ongoing. Theres a lot to do so its going to take some time. Here how ever are some screenshots of things that are being built at the moment.


![Duty Screen](https://i.imgur.com/IjLWkjj.png)
![Person Screen](https://i.imgur.com/hfm4mmV.png)

## Dependencies
- [qb-core](https://github.com/qbcore-framework/qb-core) (Duhh :D)
- [qb-police](https://github.com/qbcore-framework/qb-policejob)

## Installation
Please read this carefully otherwise the PMI will not work.

### Config file changes
``PoliceVehicles`` - Set these to the spawn names and names of the vehicles your officers will use.


### Functions to add in other resources
These functions need to be added to other resources in order for PMI functionality to work fully
#### qb-policejob/client/main.lua
```lua
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
```lua
TriggerServerEvent("qb-pmi:server:vehicleTakeout", GetVehicleNumberPlateText(veh), vehicleInfo)
```
Example of what this looks like, the line was added on line 12
```lua
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
12        TriggerServerEvent("qb-pmi:server:vehicleTakeout", GetVehicleNumberPlateText(veh), vehicleInfo)
13    end, coords, true)
14 end
```
Then in the same file find ``for k, v in pairs(Config.Locations["vehicle"]) do`` and add the following before QBCore.Functions.DeleteVehicle
```lua
TriggerServerEvent("qb-pmi:server:vehicleStore", GetVehicleNumberPlateText(GetVehiclePedIsIn(PlayerPedId())))
```

```lua
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
                                        TriggerServerEvent("qb-pmi:server:vehicleStore", GetVehicleNumberPlateText(GetVehiclePedIsIn(PlayerPedId())))
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

### pma-voice/client/module/radio.lua
You need to add a call to update the officers radio channel on the PMI
```lua
TriggerServerEvent('qb-pmi:server:setOfficerRadio', channel)
```
Add this in the ``setRadioChannel(channel)`` function like this:
```lua
function setRadioChannel(channel)
	if GetConvarInt('voice_enableRadios', 1) ~= 1 then return end
	TriggerServerEvent('pma-voice:setPlayerRadio', channel)
	TriggerServerEvent('qb-pmi:server:setOfficerRadio', channel)
	plyState:set('radioChannel', channel, GetConvarInt('voice_syncData', 0) == 1)
	radioChannel = channel
	if GetConvarInt('voice_enableUi', 1) == 1 then
		SendNUIMessage({
			radioChannel = channel,
			radioEnabled = radioEnabled
		})
	end
end
```

## Development Setup
The source files for the UI are included in `client/pmi-source`, these can be used to change the PMI or add new things.

**Disclaimer:** Just because you changed something or added a new feature to the PMI does not give you rights to release the whole PMI as your own work. If its an amazing feature that everyone and there dog needs then make a pull request on github and I can see if it can become a permanent part of the project.

### Setup
1. Open the `client/pmi-source` directory and run `npm install` to install node modules
2. To view the UI in your browser do `npm run serve`
3. Make any changes you want an then run `npm run build` to build the files.
4. The build files automatically go to the html directory, now just restart the resource on your server and you should see the changes.
