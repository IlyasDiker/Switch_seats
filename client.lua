-----------------------------------------------------------------------
--            :::     :::    ::::::::::: ::::::::::: :::     ::::::::: 
--         :+: :+:   :+:        :+:         :+:   :+: :+:   :+:    :+: 
--       +:+   +:+  +:+        +:+         +:+  +:+   +:+  +:+    +:+  
--     +#++:++#++: +#+        +#+         +#+ +#++:++#++: +#++:++#+    
--    +#+     +#+ +#+        +#+         +#+ +#+     +#+ +#+    +#+    
--   #+#     #+# #+#        #+#         #+# #+#     #+# #+#    #+#     
--  ###     ### ########## ###         ### ###     ### #########       
-----------------------------------------------------------------------
-- Script  : alttab_seats 
-- Version : v2.0
-- Written by ILYASleZWIN*s
-- Status  : Working
-----------------------------------------------------------------------

local display = false

------------------------------------------------------------------
--                          Functions
------------------------------------------------------------------

function setdisplay(bool)
    display = bool
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        type="ui",
        status = bool,
    })
end

function switchseat(pos)
    local pedveh = GetVehiclePedIsIn(GetPlayerPed(-1), false)
    SetPedIntoVehicle(GetPlayerPed(-1), pedveh, tonumber(pos))
    exports['mythic_notify']:SendAlert('success', 'you are now in seat: '..pos)
end

function checkseat(seat)
    local pedveh = GetVehiclePedIsIn(GetPlayerPed(-1), false)
    local result = IsVehicleSeatFree(pedveh, tonumber(seat))
    return result
end

-- function lockseat(pos)  --- Not finished idea will be finished on the v3.0
--     SendNUIMessage({
--         type="lock",
--         seat = pos,
--     })
-- end

-- function unlockseat(pos) 
--     SendNUIMessage({
--         type="unlock",
--         seat = pos,
--     })
-- end

function getmaxseat()
    local pedveh = GetVehiclePedIsIn(GetPlayerPed(-1), false)
    local maxseat = GetVehicleModelNumberOfSeats(maxseat)
    return maxseat
end



------------------------------------------------------------------
--                           Events
------------------------------------------------------------------ 

RegisterCommand("seat", function(source, args) 
    local isinanyveh = IsPedInAnyVehicle(GetPlayerPed(-1), false)
    if isinanyveh then
        if args[1] == nil then
            setdisplay(true)
        else
            local pos = args[1]
            switchseat(pos)
        end
    else
        exports['mythic_notify']:SendAlert('error', 'you\'re not in a vehicle')
    end
end)

RegisterCommand("check", function(source, args)
    local isinanyveh = IsPedInAnyVehicle(GetPlayerPed(-1), false)
    if isinanyveh then
        local result = checkseat(args[1])
        local status = nil
        if result then
            status = "free"
        else
            status = "occupied"
        end
        -- exports['mythic_notify']:SendAlert('inform', 'the seat '..args[1]..' is '..status) -- only for DEBUG
    else
    exports['mythic_notify']:SendAlert('error', 'you\'re not in a vehicle')
    end
end)

Citizen.CreateThread(function()
    while display do
        Citizen.Wait(0)
        
        DisableControlAction(0, 1, display) -- LookLeftRight
        DisableControlAction(0, 2, display) -- LookUpDown
        DisableControlAction(0, 142, display) -- MeleeAttackAlternate
        DisableControlAction(0, 18, display) -- Enter
        DisableControlAction(0, 322, display) -- ESC
        DisableControlAction(0, 106, display) -- VehicleMouseControlOverride
    end
end)

RegisterCommand("nui", function(source)
    setdisplay(true)
end)

RegisterNUICallback("switch", function(data)
    -- exports['mythic_notify']:SendAlert('return : seat '..data.seat) -- only for DEBUG
    if checkseat(data.seat) then
        switchseat(data.seat)
    else
        exports['mythic_notify']:SendAlert('error', 'The seat is full')
    end
    setdisplay(false)
end)

RegisterNUICallback("error", function(data)
    exports['mythic_notify']:SendAlert('error', 'Error : '..data) -- only for DEBUG
    setdisplay(false)
end)

RegisterNUICallback("exit", function(data)
    setdisplay(false)
end)