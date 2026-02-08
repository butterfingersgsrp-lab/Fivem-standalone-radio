local isOpen = false

local function setNuiFocus(state)
    SetNuiFocus(state, state)
    isOpen = state
end

local function playerInVehicle()
    local ped = PlayerPedId()
    return IsPedInAnyVehicle(ped, false)
end

local function notify(message)
    BeginTextCommandThefeedPost('STRING')
    AddTextComponentSubstringPlayerName(message)
    EndTextCommandThefeedPostTicker(false, false)
end

RegisterNetEvent('fivem-radio:open', function()
    if isOpen then
        return
    end

    if not playerInVehicle() then
        notify('You can only use the radio while in a vehicle.')
        setNuiFocus(false)
        return
    end

    SendNUIMessage({
        type = 'open'
    })
    setNuiFocus(true)
end)

RegisterNetEvent('fivem-radio:play', function(payload)
    payload = payload or {}
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
    notify(message)
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

CreateThread(function()
    while true do
        if isOpen and not playerInVehicle() then
            setNuiFocus(false)
            SendNUIMessage({
                type = 'close'
            })
            notify('Radio closed: enter a vehicle to use it.')
        end
        Wait(500)
    end
end)
