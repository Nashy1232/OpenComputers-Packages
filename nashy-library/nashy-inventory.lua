local inventory = {}

-- check to see if inventory contains any items returns true if empty
function inventory.isEmpty(transposer, side, sleep)
    sleep = sleep or 0.1
    if (transposer == nil) then
        error("nashy.inventory.isEmpty - transposer nil")
        return nil
    elseif (side == nil) then
        error("nashy.inventory.isEmpty - side nil")
        return nil
    end

    local slots = transposer.getInventorySize(side)
    if (slots ~= nil) then
        for slot = 1, slots, 1 do
            os.sleep(sleep)
            local stack = transposer.getStackInSlot(side, slot)
            if (stack ~= nil and stack.size > 0) then
                return false
            end
        end
    else
        return nil
    end
    return true
end

function inventory.getContents(transposer, side, sleep)
    sleep = sleep or 0.1
    if (transposer == nil) then
        error("nashy.inventory.isEmpty - transposer nil")
        return nil
    elseif (side == nil) then
        error("nashy.inventory.isEmpty - side nil")
        return nil
    end

    local contents = {}
    local slots = transposer.getInventorySize(side)
    if (slots ~= nil) then
        for slot = 1, slots, 1 do
            os.sleep(sleep)
            local stack = transposer.getStackInSlot(side, slot)
            if (stack ~= nil and stack.size > 0) then
                contents[slot] = stack
            end
        end
    else
        return nil
    end
    return contents
end

return inventory
