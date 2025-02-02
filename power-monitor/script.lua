local os = require("os")
local component = require("component")
local term = require("term")

local settings = dofile("/usr/bin/power-monitor/settings.cfg")

capacitor = component.proxy(component.get(settings.substation_address))
redstone = component.proxy(component.get(settings.redstone_address))

local function rs(val)
    redstone.setOutput({val, val, val, val, val, val})
end

while true do
    max_energy = tonumber(capacitor.getCapacity():gsub(",",""),10)    
    cur_energy = tonumber(capacitor.getStored():gsub(",",""),10)
    percent_energy = (cur_energy / max_energy)

    if (percent_energy < settings.min_level) then
        rs(1)
    else
        rs(0)
    end

    os.sleep(10)
end