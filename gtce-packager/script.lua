local os = require("os")
local component = require("component")
local term = require("term")

local settings = dofile("/usr/bin/gtce-packager/settings.cfg")

while true do
    if (settings.debug == true) then
        term.clear()
    end

    for index in pairs(settings.rigs) do
        local transposer_packager = component.proxy(component.get(settings.rigs[index].transposer_packager_address))
        local transposer_input = component.proxy(component.get(settings.rigs[index].transposer_input_address))

        local transposer_packager_side = settings.altars[index].transposer_packager_side
        local transposer_input_side = settings.altars[index].transposer_output_side

        local s = tostring(transposer_packager.getInventorySize(transposer_packager_side))
        term.write(s)

    end
    os.sleep(3)
end
