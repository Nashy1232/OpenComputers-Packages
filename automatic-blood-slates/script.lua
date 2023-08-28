local component = require("component") 
local os = require("os")
local term = require("term")

local settings = dofile("/usr/bin/automatic-blood-slates/settings.cfg")

function check_target(transposer, target_side)
    local info = transposer.getStackInSlot(target_side, 1)
    if (settings.debug == true) then
        if (info ~= nil) then
            term.write(info.label .. "\n")
            term.write(info.name .. "\n")
        else 
            term.write("No target item detected" .. "\n")
        end
    end
    return info
end

function check_altar(transposer_fluids, transposer_items, altar_side_items, altar_side_fluids, stop_capacity, start_capacity, target_info)
    local capacity = transposer_fluids.getTankLevel(altar_side_fluids)
    local item_info = transposer_items.getStackInSlot(altar_side_items, 1)

    if (capacity < stop_capacity) then
        if (settings.debug == true) then
            term.write("Altar bellow stop capacity. \n")
        end
        return "stop"
    elseif (capacity < start_capacity) then
        if (settings.debug == true) then
            term.write("Altar bellow start capacity. \n")
        end
        return "low"
    elseif (item_info == nil) then
        if (settings.debug == true) then
            term.write("Altar empty. \n")
        end
        return "empty"
    elseif (item_info.name == target_info.name and item_info.label == target_info.label) then
        if (settings.debug == true) then
            term.write("Altar item match. \n")
        end
        return "match"
    else
        if (settings.debug == true) then
            term.write("Alter contains non target item. \n")
        end
        return "invalid"
    end
end

function altar_extract(transposer, altar_side, output_side)
    local item_info = transposer.getStackInSlot(altar_side, 1)
    while item_info ~= nil do
        for slot=1, transposer.getInventorySize(output_side), 1 do
            local chest_item = transposer.getStackInSlot(output_side, slot)
            if (chest_item == nil) then
                transposer.transferItem(altar_side, output_side, 1, 1, slot)
                break
            elseif (item_info.label == chest_item.label) then
                transposer.transferItem(altar_side, output_side, 1, 1, slot)
                break
            end
            os.sleep(0.1)
        end
        item_info = transposer.getStackInSlot(altar_side, 1)
        os.sleep(0.25)
    end
end

function altar_insert(transposer, altar_side, input_side, transfer_count)
    for slot=1, transposer.getInventorySize(input_side), 1 do
        local chest_item = transposer.getStackInSlot(input_side, slot)
        if (chest_item ~= nil) then
            transposer.transferItem(input_side, altar_side, transfer_count, slot, 1)
            break
        end
        os.sleep(0.1)
    end
end

while true do
    if (settings.debug == true) then
        term.clear()
    end
    
    for index in pairs(settings.altars) do
        local transposer_fluids = component.proxy(component.get(settings.altars[index].transposer_fluid_address))
        local transposer_items = component.proxy(component.get(settings.altars[index].transposer_item_address))
        local transposer_target = component.proxy(component.get(settings.altars[index].transposer_target_address))

        local altar_side_items = settings.altars[index].transposer_altar_item_side
        local altar_side_fluids = settings.altars[index].transposer_altar_fluid_side

        local input_side = settings.altars[index].transposer_input_side
        local output_side = settings.altars[index].transposer_output_side
        local target_side = settings.altars[index].transposer_target_side
        local transfer_count = settings.altars[index].altar_transfer_count
        local start_capacity = settings.altars[index].altar_start_capacity
        local stop_capacity = settings.altars[index].altar_stop_capacity
        local using_buffer = settings.altars[index].using_buffer
    
        if (settings.debug == true) then
            term.write(transposer_target.address .. "\n")
        end
        local target_info = check_target(transposer_target, target_side) 
        if (target_info ~= null) then
            local altar_info = check_altar(transposer_fluids, transposer_items, altar_side_items, altar_side_fluids, stop_capacity, start_capacity, target_info)
            if (altar_info == "stop" and transposer_items.getStackInSlot(altar_side_items, 1) ~= nil) then
                altar_extract(transposer_items, altar_side_items, output_side)
            elseif (altar_info == "match") then
                altar_extract(transposer_items, altar_side_items, output_side)
            elseif (altar_info == "empty") then
                local insert = altar_insert(transposer_items, altar_side_items, input_side, transfer_count)
            end
        elseif (using_buffer == true and transposer_items.getStackInSlot(input_side, 1) ~= nil) then
            transposer_items.transferItem(input_side, output_side, transposer_items.getSlotStackSize(input_side, 1),  1)
        end
    end
    os.sleep(3)
end