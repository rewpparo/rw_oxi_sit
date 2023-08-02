
--To rotate a vector to heading
function vec3rotateZ(vec, angle)
    a = angle * math.pi/180
    return vec3(vec.x * math.cos(a) - vec.y * math.sin(a), vec.x * math.sin(a) + vec.y * math.cos(a), vec.z) 
end


--The entity the player is sitting on, or nil if not sitting
sitting = nil
--Position of the seat (incl. model offset)
sittingpos = nil
scenario = nil

CreateThread(function()
	while not ESX.PlayerLoaded do Wait(1) end

    seats ={}
    for k,v in pairs(Config.Seats) do
        table.insert(seats,k)
    end

    exports.ox_target:addModel(seats, {
        label = "Sit",
        name = "rw_oxt_sit",
        icon = "fa-solid fa-chair",
        distance = 1.6,

        onSelect = function(data)
            --Citizen.Trace(dump(data))
            PlayerPed = PlayerPedId()

            --Prevent sitting through walls
            --if not HasEntityClearLosToEntity(PlayerPed, data.entity, 17) then
            --    Citizen.Trace("No line of sight to seat\n")
            --    return
            --end

            --Freeze object in place
            FreezeEntityPosition(data.entity, true)
            PlaceObjectOnGroundProperly(data.entity)
 
            --parse offsets
            hash = GetEntityModel(data.entity)
            sittingpos = nil
            sittingheading = nil
            local scenario = 'PROP_HUMAN_SEAT_BENCH'

            for k,v in pairs(Config.Seats) do
				if joaat(k) == hash then --Found or seat in the database
                    if v.o~=nil then --An offset is provided
                        local t = type(v.o)
                        if t == "table" then
                            for k1,v1 in pairs(v.o) do
                                newpos = GetEntityCoords(data.entity) + vec3rotateZ(v1, GetEntityHeading(data.entity))
                                if sittingpos then
                                    if #(newpos - data.coords) < #(sittingpos - data.coords) then
                                        sittingpos = newpos
                                        if v.h then 
                                            sittingheading = GetEntityHeading(data.entity) + v.h 
                                        else 
                                            sittingheading = GetEntityHeading(data.entity)
                                        end
                                    else
                                    end
                                else --first position
                                    sittingpos = newpos
                                    if v.h then 
                                        sittingheading = GetEntityHeading(data.entity) + v.h 
                                    else 
                                        sittingheading = GetEntityHeading(data.entity)
                                    end
                                end
                            end
                        else --assume single vec3
                            sittingpos = GetEntityCoords(data.entity) + vec3rotateZ(v.o, GetEntityHeading(data.entity))
                            if v.h then 
                                sittingheading = GetEntityHeading(data.entity) + v.h 
                            else 
                                sittingheading = GetEntityHeading(data.entity)
                            end
                        end
                    end
                    if v.s and type(v.s)=='string' then scenario = v.s end
                    break
				end
			end

            --Use default offset if none provided
            if sittingpos==nil then
                sittingpos = GetEntityCoords(data.entity) + vec3rotateZ(vec3(0.0, 0.0, 0.5), GetEntityHeading(data.entity))
                sittingheading = GetEntityHeading(data.entity)
            end

            --Do the sitting
            TaskStartScenarioAtPosition(PlayerPed, scenario, 
                sittingpos.x, sittingpos.y, sittingpos.z,
                sittingheading + 180.0, 
                0, true, false )

            --Check that sitting went well, otherwise just teleport
            Wait(2000)
            if GetEntitySpeed(PlayerPed) > 0 then
                ClearPedTasks(PlayerPed)
                TaskStartScenarioAtPosition(PlayerPed, scenario, 
                    sittingpos.x, sittingpos.y, sittingpos.z,
                    sittingheading + 180.0, 
                    0, true, true )
            end

            sitting = data.entity
        end
    })

    --Main loop
    while true do
        Wait(10)
        --Press X to leave chair (or correct incoherent scenarios)
        if sitting~=nil and IsControlJustPressed(0,Config.Getupkey) then
            playerPed = PlayerPedId()
            TaskStartScenarioAtPosition(playerPed, scenario, 0.0, 0.0, 0.0, 180.0, 2, true, false)
            while IsPedUsingScenario(PlayerPedId(), scenario) do
                Wait(100)
            end
            ClearPedTasks(playerPed)
            sitting = nil
            sittingpos = nil
            scenario = nil
        end
    end
end)
