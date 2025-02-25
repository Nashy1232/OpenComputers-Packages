local os = require("os")
local component = require("component") 
local term = require("term")
local inventory = require("nashy-inventory")

local settings = dofile("/usr/bin/test-carling/settings.cfg")
local component_cache = {}

local function get_component(addr)
    if not component_cache[addr]

local function get_component(id)
    return component.proxy(component.get(id))
end

local function clearStages()
    for i, stage in ipairs(settings.stages) do
        getComponent(stage.id).setOutput(stage.side, 0)
    end
end

local function runStages()
    for i, stage in ipairs(settings.stages) do
        getComponent(stage.id).setOutput(stage.side, 15)
        os.sleep(stage.delay)
    end
end

term.write("Running...\n")
clearStages()
os.sleep(1)
runStages()
term.write("Complete.\n")

-- while true do
--     local transposer = component.proxy(component.get(settings.transposer.id))
--     local empty = inventory.isEmpty(transposer, settings.transposer.side)

--     if (not empty) then
--         term.write("Running Sequence\n")
--         runSequence()
--     else 
--         term.write("Loop\n")
--     end

--     os.sleep(3)
-- end
