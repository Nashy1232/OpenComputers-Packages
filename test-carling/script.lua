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

local transposer = component.proxy(component.get(settings.transposer.id))
local empty = inventory.isEmpty(transposer, settings.transposer.side)
term.write("isEmpty: " .. empty)

term.write("Running...\n")
getItems(settings.transposer)
term.write("Program Complete.")