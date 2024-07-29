local QBCore = exports['qb-core']:GetCoreObject()
local isMenuOpen = false
local currentFloor = nil

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local letSleep = true

        for _, elevator in pairs(Config.Elevators) do
            for _, floor in pairs(elevator.floors) do
                local distance = #(playerCoords - floor.coords)
                if distance < 3.0 then
                    letSleep = false
                    DrawText3Ds(floor.coords.x, floor.coords.y, floor.coords.z + 1.0, "~g~E~w~ - Use Elevator")
                    if IsControlJustPressed(0, 38) and not isMenuOpen then
                        currentFloor = floor.coords
                        openElevatorMenu(elevator)
                    end
                end
            end
        end

        if letSleep then
            Citizen.Wait(1000)
        end
    end
end)

function openElevatorMenu(elevator)
    isMenuOpen = true
    local options = {}
    
    for _, floor in pairs(elevator.floors) do
        if floor.coords ~= currentFloor then
            table.insert(options, {
                header = floor.label,
                params = {
                    event = 'elevator:goToFloor',
                    args = floor.coords
                }
            })
        end
    end

    exports['qb-menu']:openMenu(options)
end

RegisterNetEvent('elevator:goToFloor')
AddEventHandler('elevator:goToFloor', function(coords)
    local playerPed = PlayerPedId()
    DoScreenFadeOut(1000)
    Citizen.Wait(1000)
    SetEntityCoords(playerPed, coords.x, coords.y, coords.z)
    Citizen.Wait(1000)
    DoScreenFadeIn(1000)
    isMenuOpen = false
end)

function DrawText3Ds(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x, y, z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0 + 0.0125, 0.017 + factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end
