local os = require("os")
local component = require("component") 
local term = require("term")

local settings = dofile("/usr/bin/test-carling/settings.cfg")

function setState(obj, value)
    component.proxy(component.get(obj.id)).setOutput(obj.side, value)
end

function clear()
    setState(settings.stage1, 0)
    setState(settings.stage2, 0)
    setState(settings.stage3, 0)
    setState(settings.stage4, 0)
    setState(settings.activate, 0)
end

function runSequence()
    os.sleep(1)
    setState(settings.stage1, 15)
    os.sleep(1)
    setState(settings.stage2, 15)
    os.sleep(1)
    setState(settings.stage3, 15)
    os.sleep(1)
    setState(settings.stage4, 15)
    os.sleep(1)
    setState(settings.activate, 15)
end

function getItems(transposer)
    local item = component.proxy(component.get(settings.transposer.id))
    local slots = item.getInventorySize(settings.transposer.side)

    term.write("Slots: " .. slots .. "\n")

    for i=1, slots, 1 do
        --getSlotStackSize(side:number, slot:number)
        local count = item.getSlotStackSize(transposer.side, i)
        term.write(i .. ": " .. count .. "\n")
    end
end

term.write("Running...\n")
getItems(settings.transposer)
term.write("Program Complete.")