local os = require("os")
local component = require("component") 
local term = require("term")
local inventory = require("nashy-inventory")

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
    clear()
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
    os.sleep(2)
    clear()
end

term.write("Running...\n")

while true do
    local transposer = component.proxy(component.get(settings.transposer.id))
    local empty = inventory.isEmpty(transposer, settings.transposer.side)

    if (not empty) then
        term.write("Running Sequence\n")
        runSequence()
    else 
        term.write("Loop\n")
    end

    os.sleep(3)
end
