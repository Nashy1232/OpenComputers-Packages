local sides = require("sides")

local term = require("term")


local inventory = {}

-- check to see if inventory contains any items
function inventory.isEmpty(transposer, side)
    local slots = transposer.getInventorySize(side)
    term.write(tostring(slots))
    for index in pairs(slots) do
        local stack = transposer.getStackInSlot()
        if (stack ~= nil and stack.size > 0) then
            return false
        end
    end
    return true
end

return inventory
