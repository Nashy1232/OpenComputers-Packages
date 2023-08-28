local os = require("os")
local component = require("component") 
local term = require("term")

local settings = dofile("/usr/bin/starlight-transmuter/settings.cfg")

while true do
    if (settings.debug == true) then
        term.clear()
    end
    for index in pairs(settings.rigs) do
        local redstone = component.proxy(component.get(settings.rigs[index].redstone_address))
        local redstone_side = settings.rigs[index].redstone_side
        local geolyzer = component.proxy(component.get(settings.rigs[index].geolyzer_address))
        local geolyzer_side = settings.rigs[index].geolyzer_side

        local result_table = geolyzer.analyze(geolyzer_side)
        if (settings.debug == true) then
            term.write(geolyzer.address .. "\n")
            term.write(result_table.name .. "\n")
        end
        if (result_table.name ~= "minecraft:air") then
            for block in pairs(settings.whitelist) do
                if (result_table.name == settings.whitelist[block]) then
                    redstone.setOutput(redstone_side, 15)
                    redstone.setOutput(redstone_side, 0)
                end
            end
        end
        os.sleep(0.5)
    end
end

