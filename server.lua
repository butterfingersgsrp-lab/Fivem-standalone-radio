local ESX = nil
local framework = Config.Framework

local function detectFramework()
    if framework ~= 'auto' then
        return framework
    end

    if GetResourceState('es_extended') == 'started' then
        return 'esx'
    end

    return 'standalone'
end

local function containsBlacklistedWord(text)
    if not text then
        return false
    end

    local lowered = string.lower(text)
    for _, word in ipairs(Config.BlacklistedWords) do
        if string.find(lowered, string.lower(word), 1, true) then
            return true, word
        end
    end

    return false
end

local function registerRadioCommand(cmd)
    if cmd == '' then
        cmd = 'radio'
    end

    local mode = detectFramework()

    if mode == 'esx' then
        ESX = exports['es_extended']:getSharedObject()
        ESX.RegisterCommand(cmd, 'user', function(xPlayer)
            TriggerClientEvent('fivem-radio:open', xPlayer.source)
        end, true, { help = 'Open the radio UI.' })
        return
    end

    RegisterCommand(cmd, function(source)
        TriggerClientEvent('fivem-radio:open', source)
    end, false)
end

RegisterNetEvent('fivem-radio:setStation', function(payload)
    local source = source
    local name = payload and payload.name or ''
    local url = payload and payload.url or ''

    local blocked, word = containsBlacklistedWord(name)
    if blocked then
        TriggerClientEvent('fivem-radio:notify', source, ('Station name contains a blocked word: %s'):format(word))
        return
    end

    TriggerClientEvent('fivem-radio:play', source, {
        name = name,
        url = url
    })
end)

RegisterNetEvent('fivem-radio:stopStation', function()
    local source = source
    TriggerClientEvent('fivem-radio:stop', source)
end)

CreateThread(function()
    registerRadioCommand(Config.Command)
end)
