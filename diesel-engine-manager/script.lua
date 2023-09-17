local component = require("component")
local os = require("os")
local term = require("term")

local settings = dofile("/usr/bin/diesel-engine-manager/settings.cfg")

local function setRedstone(redstone, val)
    redstone.setOutput({val, val, val, val, val, val})
end

local function getRedstone(redstone, side) 
    local val = redstone.getInput(side)
    if (val == nil) then val = 0 end
    return val
end

local rs_enable = component.proxy(component.get(settings.enable_redstone_address))
local rs_enable_side = settings.enable_redstone_side

while true do
    if (settings.debug == true) then
        term.clear()
    end

    for index in pairs(settings.generators) do
        os.sleep(1)
        local battery_buffer = component.proxy(component.get(settings.generators[index].battery_buffer_address))
        local redstone = component.proxy(component.get(settings.generators[index].redstone_address))
        local low_capacity = settings.generators[index].low_capacity
        local high_capacity = settings.generators[index].high_capacity
        local battery_percent = battery_buffer.getEnergyStored() / battery_buffer.getEnergyCapacity()
        local enabled = settings.generators[index].enabled

        if (battery_percent < low_capacity and enabled == true and getRedstone(rs_enable, rs_enable_side) > 0) then
            setRedstone(redstone, 15)
        elseif (battery_percent > high_capacity or enabled == false or getRedstone(rs_enable, rs_enable_side) == 0) then
            setRedstone(redstone, 0)
        end
    end
    os.sleep(1)
end
