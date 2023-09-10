local inventory = {}

-- check to see if inventory contains any items
function inventory.isEmpty(transposer, side)
    if (transposer == nil or side == nil) then
        return nil
    else
        local slots = transposer.getInventorySize()

        if (slots == nil) then
            return nil
        else
            for index in pairs(slots) do
                local stack = transposer.getStackInSlot()
                if (stack ~= nil and stack.size > 0) then
                    return false
                end
            end
        end
    end

    return true
end

return inventory
