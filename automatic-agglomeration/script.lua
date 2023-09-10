local component = require("component") 
local os = require("os")
local term = require("term")
local sides = require("sides")
local inventory = require("nashy-inventory")

local settings = dofile("/usr/bin/automatic-agglomeration/settings.cfg")

local function drop(transposer_dropper, transposer_dropper_side, redstone_dropper, redstone_dropper_side)
    while true do
        if (inventory.isEmpty(transposer_dropper, transposer_dropper_side) == false) then
            redstone_dropper.setOutput(redstone_dropper_side, 15)
            os.sleep(0.25)
            redstone_dropper.setOutput(redstone_dropper_side, 0)
        else
            break
        end
    end
end


while true do
    for index in pairs(settings.rigs) do
        os.sleep(0.5)
        local redstone_pool = component.proxy(component.get(settings.rigs[index].redstone_pool_address))
        local redstone_pool_side = settings.rigs[index].redstone_pool_side
        local redstone_dropper = component.proxy(component.get(settings.rigs[index].redstone_dropper_address))
        local redstone_dropper_side = settings.rigs[index].redstone_dropper_side

        local pool_percent = (redstone_pool.getComparatorInput(redstone_pool_side) / 15) -- percent value between 0 and 1.0
        local mana_threshold = settings.rigs[index].mana_threshold

        local transposer_items = component.proxy(component.get(settings.rigs[index].transposer_items))
        local transposer_buffer_side = settings.rigs[index].transposer_buffer_side
        local transposer_dropper_side = settings.rigs[index].transposer_dropper_side

        drop(transposer_items, transposer_dropper_side, redstone_dropper, redstone_dropper_side)
        break
        
    end
    os.sleep(1)
end


--[[
    if the pool is above the minimum threshold AND the dropper has items in it THEN drop 3 items

    when items are dropped a flag needs to be saved so i can move into the waiting phase,

    if the waiting flag is true then i need to wait until an item shows up in the buffer vacume chest

    once an item is in the buffer chest i can then export it to the ME system
]]