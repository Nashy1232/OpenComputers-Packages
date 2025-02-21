local os = require("os")
local component = require("component") 
local term = require("term")

local settings = dofile("/usr/bin/test-carling/settings.cfg")

component.proxy(component.get(settings.stage1.id)).setOutput(settings.stage1.side, 1)
component.proxy(component.get(settings.stage2.id)).setOutput(settings.stage2.side, settings.output)
component.proxy(component.get(settings.stage3.id)).setOutput(settings.stage3.side, 0)
component.proxy(component.get(settings.stage4.id)).setOutput(settings.stage4.side, 0)
component.proxy(component.get(settings.activate.id)).setOutput(settings.activate.side, 3)
