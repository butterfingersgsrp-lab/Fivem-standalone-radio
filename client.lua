local isOpen = false

local function setNuiFocus(state)
    SetNuiFocus(state, state)
    isOpen = state
end

RegisterNetEvent('fivem-radio:open', function()
    if isOpen then
        return
    end

    SendNUIMessage({
        type = 'open'
    })
    setNuiFocus(true)
end)

RegisterNetEvent('fivem-radio:play', function(payload)
    SendNUIMessage({
        type = 'play',
        name = payload.name,
        url = payload.url
    })
end)

RegisterNetEvent('fivem-radio:stop', function()
    SendNUIMessage({
        type = 'stop'
    })
end)

RegisterNetEvent('fivem-radio:notify', function(message)
    BeginTextCommandThefeedPost('STRING')
    AddTextComponentSubstringPlayerName(message)
    EndTextCommandThefeedPostTicker(false, false)
end)

RegisterNUICallback('close', function(_, cb)
    setNuiFocus(false)
    cb({})
end)

RegisterNUICallback('setStation', function(data, cb)
    TriggerServerEvent('fivem-radio:setStation', {
        name = data.name,
        url = data.url
    })
    cb({})
end)

RegisterNUICallback('stopStation', function(_, cb)
    TriggerServerEvent('fivem-radio:stopStation')
    cb({})
end)

RegisterCommand('radioshortcut', function()
    TriggerEvent('fivem-radio:open')
end, false)

RegisterKeyMapping('radioshortcut', 'Open Radio UI', 'keyboard', Config.ToggleKey)
