local os = require("os")
local component = require("component")
local term = require("term")

local settings = dofile("/usr/bin/gtce-packager/settings.cfg")

function inventory_table(transposer, side)
    local inventory = {}

    -- loop through every slot in the inventory
    for slot = 1, transposer.getInventorySize(side), 1 do
        -- get item data from slot
        local item = transposer.getStackInSlot(side, slot)
        if (item ~= nil) then
            if (inventory[item.name] ~= nil) then
                inventory[item.name] = inventory[item.name] + item.size
            else
                inventory[item.name] = item.size
            end
            term.write(tostring(item.name) .. "\n")
        end
        os.sleep(0.1)
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
end
