local os = require("os")
local component = require("component")
local term = require("term")

local settings = dofile("/usr/bin/gtce-packager/settings.cfg")

function inventory_table(transposer, side)
    local inventory_size = transposer.getInventorySize(side)
    for active_slot = 1, inventory_size, 1 do
        local active_item = transposer.getStackInSlot(side, active_slot)
        local count = active_item.size
        if (active_item ~= nil) then
            for search_slot = 1, inventory_size, 1 do
                local search_item = transposer.getStackInSlot(side, search_slot)
                if (search_item ~= nil) then
                    if (transposer.areStacksEquivalent(side, active_slot, side, search_slot)) then
                        term.write("true \n")
                    end
                end
            end
        end
    end
end

while true do
    if (settings.debug == true) then
        term.clear()
    end

    for index in pairs(settings.rigs) do
        local transposer_packager = component.proxy(component.get(settings.rigs[index].transposer_packager_address))
        local transposer_input = component.proxy(component.get(settings.rigs[index].transposer_input_address))

        local transposer_packager_side = settings.rigs[index].transposer_packager_side
        local transposer_input_side = settings.rigs[index].transposer_input_side

        inventory_table(transposer_input, transposer_input_side)

    end
    os.sleep(3)
    break
end
