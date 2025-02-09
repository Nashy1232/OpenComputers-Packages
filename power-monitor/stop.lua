local os = require("os")
local component = require("component")
local term = require("term")

local settings = dofile("/usr/bin/power-monitor/settings.cfg")

redstone = component.proxy(component.get(settings.redstone_address))

local function rs(val)
    redstone.setOutput({val, val, val, val, val, val})
end

rs(0)