local os = require("os")
local component = require("component")
local term = require("term")

local settings = dofile("/usr/bin/fusion-plasma-control/settings.cfg")

-- functions
function currentOutput()
    local output = 0
    for generator in pairs(generators) do
        output = output + (generators[generator].getOutputPerSec()/20) --- convert from per sec to per tick
    end
    return output
end

function currentUsage()
    return (substation.getAverageOutLastSec()) -- already per tick
end


-- setup
--- get the substation
substation = nil
for address, name in component.list("substation") do
    substation = component.proxy(address)
    break
end

--- get generators
generators = {}
for address, name in component.list("large_turbine_plasma", true) do
    generator = component.proxy(address)
    table.insert(generators, generator)
end

-- main

while true do
    term.write("Current Output: " .. currentOutput() .. "\n")
    term.write("Current Usage: " .. currentUsage() .. "\n")

    break
    os.sleep(settings.loop_delay)
end