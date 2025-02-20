local os = require("os")
local component = require("component") 
local term = require("term")

local settings = dofile("/usr/bin/test-carling/settings.cfg")

component.proxy(component.get(settings.stage1.address)).setOutput(settings.stage1.side, settings.output)
component.proxy(component.get(settings.stage2.address)).setOutput(settings.stage2.side, settings.output)
component.proxy(component.get(settings.stage3.address)).setOutput(settings.stage3.side, settings.output)
component.proxy(component.get(settings.stage4.address)).setOutput(settings.stage4.side, settings.output)
component.proxy(component.get(settings.activate.address)).setOutput(settings.activate.side, settings.output)