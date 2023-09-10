local inventory = {}


-- check to see if inventory contains any items
function inventory.isEmpty(transposer, side)
    local slots = transposer.getInventorySize()
    for index in pairs(slots) do
        local stack = transposer.getStackInSlot()
        if (stack ~= nil and stack.size > 0) then
            return false
        end
    end
    return true
end

return inventory