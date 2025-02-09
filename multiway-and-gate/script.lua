local os = require("os")
local component = require("component")
local term = require("term")

local settings = dofile("/usr/bin/multiway-and-gate/settings.cfg")

--- functions
function sum(table)
    local val = 0
    for _, v in ipairs(table) do
        val = val + v
    end
    return val
end

function setRedstone(gate, val)
    for _, address in pairs(settings.gates[gate].outputs) do
        local redstone = component.proxy(component.get(address))
        --redstone.setOutput(val)
    end
end

--- main

while true do
    if (settings.debug == true) then
        term.clear()
    end

    for gate in pairs(settings.gates) do
        local inputs = {}
        term.write("gate : " .. gate .. "\n")
        for _, address in pairs(settings.gates[gate].inputs) do
            local input = component.proxy(component.get(address))
            table.insert(inputs, input)
        end
        os.sleep(0.5)
        for _, input in ipairs(inputs) do
            if (settings.debug == true) then
                term.write("address : " .. input.address .. "\n")
                term.write("sum : " .. tostring(sum(input.getInput())) .. "\n")
                term.write("raw : " .. table.concat(input.getInput(), ", ") .. "\n\n")
            end
            if (sum(input.getInput()) < settings.minimum_signal_strength) then
                setRedstone(gate, 0)
                goto nextloop
            end
        end
        if (settings.debug == true) then
            term.write("setting redstone to 15\n\n\n")
        end
        setRedstone(gate, 15)
        ::nextloop::
        os.sleep(1)
    end
    os.sleep(settings.loop_delay)
end