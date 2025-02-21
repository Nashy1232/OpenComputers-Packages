local os = require("os")
local component = require("component") 
local term = require("term")

local settings = dofile("/usr/bin/test-carling/settings.cfg")

function setState(obj, value)
    component.proxy(component.get(obj.id)).setOutput(obj.side, value)
end

while true do
    setState(settings.stage1, 0)
    setState(settings.stage2, 0)
    setState(settings.stage3, 0)
    setState(settings.stage4, 0)
    setState(settings.activate, 0)
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
    os.sleep(5)
end