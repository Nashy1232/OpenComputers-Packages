local os = require("os")
local component = require("component") 
local term = require("term")

local settings = dofile("/usr/bin/celestial-crystal-cluster/settings.cfg")

function cycleRedstone(component, side, onValue, offValue, time)
    component.setOutput(side, onValue)
    os.sleep(time)
    component.setOutput(side, offValue)
end

while true do
    if (settings.debug == true) then
        term.clear()
    end
    for index in pairs(settings.rigs) do
        --local redstone = component.proxy(component.get(settings.rigs[index].redstone_address))
        --local redstone_side = settings.rigs[index].redstone_side

        local redstone_dropper = component.proxy(component.get(settings.rigs[index].redstone_dropper_address))
        local redstone_dropper_side = settings.rigs[index].redstone_dropper_side
        local redstone_breaker = component.proxy(component.get(settings.rigs[index].redstone_breaker_address))
        local redstone_breaker_side = settings.rigs[index].redstone_breaker_side
        local geolyzer = component.proxy(component.get(settings.rigs[index].geolyzer_address))
        local geolyzer_side = settings.rigs[index].geolyzer_side

        -- reset redstone
        redstone_breaker.setOutput(redstone_breaker_side, 0)
        redstone_dropper.setOutput(redstone_dropper_side, 0)


        local result_table = geolyzer.analyze(geolyzer_side)
        if (settings.debug == true) then
            term.write(geolyzer.address .. "\n")
            term.write(result_table.name .. "\n")
        end

        if (result_table.name == "astralsorcery:blockcelestialcrystals") then
            if (result_table.properties.stage == 4) then
                if (settings.debug == true) then
                    term.write("Crystal has fully grown. \n")
                end
                -- crystal has fully grown
                cycleRedstone(redstone_breaker, redstone_breaker_side, 15, 0, 0)
                settings.rigs[index].dropped = false -- reset the flag to false
            else
                -- crystal has not finished growing
                -- I dont think anything has to be done here
            end
        elseif (result_table.name == "astralsorcery:fluidblockliquidstarlight") then
            -- there is starlight, drop item and set flag
            if (settings.rigs[index].dropped == false) then
                -- drop the item
                cycleRedstone(redstone_dropper, redstone_dropper_side, 15, 0, 0.5)
                settings.rigs[index].dropped = true
            end
        end
        os.sleep(5)
    end
end

