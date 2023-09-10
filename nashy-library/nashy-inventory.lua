local sides = require("sides")

local term = require("term")


local inventory = {}

-- check to see if inventory contains any items
function inventory.isEmpty(transposer, side)
    if (transposer == nil or side == nil) then
        return nil
    end

    local slots = transposer.getInventorySize(side)
    for slot = 1, slots, 1 do
        local stack = transposer.getStackInSlot(side, slot)
        if (stack ~= nil and stack.size > 0) then
            return false
        end
    end
    return true
end

local tp = component.proxy(component.get("1e8b"))
local side = sides.up
inventory.isEmpty(tp, side)

--return inventory
