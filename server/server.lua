local officers = {}
local pvehicles = {}

-- Commands
RegisterCommand(Config.Command, function(source, args)
    local src = source
    local xPlayer = QBCore.Functions.GetPlayer(src)
    for k, v in pairs(Config.Jobs) do
        if xPlayer.PlayerData.job.name == v then
            TriggerClientEvent('nag-mdt:open', src)
        end
    end
end)

RegisterCommand(Config.CloseCommand, function(source, args)
    local src = source
    local xPlayer = QBCore.Functions.GetPlayer(src)
    for k, v in pairs(Config.Jobs) do
        if xPlayer.PlayerData.job.name == v then
            TriggerClientEvent('nag-mdt:close', src)
        end
    end
end)

RegisterCommand(Config.CallsignCommand, function(source, args)
    local src = source
    local xPlayer = QBCore.Functions.GetPlayer(src)
    for k, v in pairs(Config.Jobs) do
        if xPlayer.PlayerData.job.name == v then
            xPlayer.Functions.SetMetaData("callsign", args[1])
            updateCallsigns(xPlayer.PlayerData.citizenid, args[1])
        end
    end
end)

RegisterCommand("mdt-records", function(source, args)
    local src = source
    local citizenId = args[1]
    print(citizenId)
    local resultPlayer = exports.ghmattimysql:executeSync('SELECT * FROM players WHERE citizenid=@citizenid', {['@citizenid'] = citizenId})
    local resultRecord = exports.ghmattimysql:executeSync('SELECT * FROM player_mdt WHERE char_id=@citizenid', {['@citizenid'] = citizenId})
    for k,v in pairs(resultPlayer) do
            if v.charinfo then
                local playerData = json.decode(v.charinfo)
                local gender = 'Male'
                if playerData.gender ~= 0 then
                    gender = 'Female'
                end
                local player = {
                    char = playerData,
                    name = playerData.firstname.. ' ' ..playerData.lastname,
                    job = json.decode(v.job),
                    gang = json.decode(v.gang),
                    metadata = json.decode(v.metadata),
                    gender = gender,
                    record = resultRecord,
                }
                TriggerClientEvent('nag-mdt:returnGetRecord', src, player)
            end
    end
end)

-- Stuff that can be done on resource start
Citizen.CreateThread(function()
    local query =
        "SELECT citizenid, charinfo, job, metadata FROM players WHERE job LIKE '%police%'"
    exports.ghmattimysql:execute(query, function(result)
        for k, v in ipairs(result) do
            local charinfo = json.decode(v.charinfo)
            local job = json.decode(v.job)
            local metadata = json.decode(v.metadata)
            local officer = {
                citizenid = v.citizenid,
                firstname = charinfo.firstname,
                lastname = charinfo.lastname,
                phone = charinfo.phone,
                onDuty = false,
                callsign = metadata.callsign
            }
            officers[v.citizenid] = officer
        end
    end)
end)

-- Base MDT data
QBCore.Functions.CreateCallback('nag-mdt:server:getmdtdata', function(source, cb)
    local src = source
    local xPlayer = QBCore.Functions.GetPlayer(src)
    updateDutyList(xPlayer.PlayerData.citizenid, xPlayer.PlayerData.job.onduty)
    if xPlayer ~= nil then
        local mdtData = {
            officers = officers,
            pvehicles = pvehicles,
            duty = xPlayer.PlayerData.job.onduty,
            citizenId = xPlayer.PlayerData.citizenid,
        }
        cb(mdtData)
    end
end)

-- Events
RegisterServerEvent('nag-mdt:server:updateDuty')
AddEventHandler('nag-mdt:server:updateDuty', function()
    local src = source
    local xPlayer = QBCore.Functions.GetPlayer(src)
    local citId = xPlayer.PlayerData.citizenid
    local duty = xPlayer.PlayerData.job.onduty
    updateDutyList(citId, duty)
    TriggerClientEvent('police:client:setDuty', src, duty)
    TriggerClientEvent('nag-mdt:setOfficerDuty', -1, citId, duty)
end)

RegisterServerEvent('nag-mdt:server:vehicleTakeout')
AddEventHandler('nag-mdt:server:vehicleTakeout', function(plate, vehicleInfo)
    local src = source
    local xPlayer = QBCore.Functions.GetPlayer(src)
    local citId = xPlayer.PlayerData.citizenid
    local model = "UNKNOWN"
    for k,v in pairs(Config.PoliceVehicles) do
        if k == vehicleInfo then
            model = v
            break
        end
    end
    local vehicle = {
        plate = plate,
        model = model,
        ownerName = ( officers[citId].firstname .. " " .. officers[citId].lastname),
        ownerCallSign = officers[citId].callsign,
        occupants = {
            citId
        },
    }
    pvehicles[plate] = vehicle
    TriggerClientEvent('nag-mdt:updatePvehicles', -1, pvehicles)
end)

RegisterServerEvent('nag-mdt:server:vehicleStore')
AddEventHandler('nag-mdt:server:vehicleStore', function(plate)
    pvehicles[plate] = nil
    TriggerClientEvent('nag-mdt:updatePvehicles', -1, pvehicles)
end)

RegisterServerEvent('nag-mdt:server:toggleInVehicle')
AddEventHandler('nag-mdt:server:toggleInVehicle', function(data)
    local src = source
    local xPlayer = QBCore.Functions.GetPlayer(src)
    local citId = xPlayer.PlayerData.citizenid
    if data.getIn then
        table.insert(pvehicles[data.plate].occupants, citId)
    else
        for k, v in ipairs(pvehicles[data.plate].occupants) do
            if v == citId then
                table.remove(pvehicles[data.plate].occupants, k)
            end
        end
    end
    TriggerClientEvent('nag-mdt:updatePvehicles', -1, pvehicles)
end)

RegisterServerEvent('nag-mdt:server:getRecord')
AddEventHandler('nag-mdt:server:getRecord', function(data)
    local src = source
    local resultPlayer = exports.ghmattimysql:executeSync('SELECT * FROM players WHERE citizenid=@citizenid', {['@citizenid'] = citizenId})
    local resultRecord = exports.ghmattimysql:executeSync('SELECT * FROM player_mdt WHERE citizenid=@citizenid', {['@citizenid'] = citizenId})
    for k,v in pairs(resultPlayer) do
        for x, y in pairs(resultRecord) do
            if v.charinfo then
                local playerData = json.decode(v.charinfo)
                local gender = 'm'
                if playerData.gender ~= 0 then
                    gender = 'f'
                end
                local player = {
                    char = playerData,
                    name = playerData.firstname.. ' ' ..playerData.lastname,
                    job = json.decode(v.job),
                    gang = json.decode(v.gang),
                    metadata = json.decode(v.metadata),
                    gender = gender,
                    record = y,
                }
                TriggerClientEvent('nag-mdt:returnGetRecord', src, player)
            end
        end
    end
end)

-- Callbacks



-- Functions
function updateDutyList(citizenId, duty)
    officers[citizenId].onDuty = duty
end
function updateCallsigns(citizenId, cs)
    officers[citizenId].callsign = cs
end

function dump(o)
    if type(o) == 'table' then
        local s = '{ '
        for k, v in pairs(o) do
            if type(k) ~= 'number' then k = '"' .. k .. '"' end
            s = s .. '[' .. k .. '] = ' .. dump(v) .. ','
        end
        return s .. '} '
    else
        return tostring(o)
    end
end
