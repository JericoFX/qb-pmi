local officers = {}

function startUp() end

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
QBCore.Functions.CreateCallback('nag-mdt:server:getmdtdata', function(source, cb) -- NEW EVENT
    local src = source
    local xPlayer = QBCore.Functions.GetPlayer(src)
    updateDutyList(xPlayer.PlayerData.citizenid, xPlayer.PlayerData.job.onduty)
    if xPlayer ~= nil then
        local mdtData = {
            officers = officers,
            duty = xPlayer.PlayerData.job.onduty,
        }
        cb(mdtData)
    end
end)

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

-- Functions
function updateDutyList(citizenId, duty)
    officers[citizenId].onDuty = duty
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
