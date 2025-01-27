local component = require("component") 
local os = require("os")
local term = require("term")
local sides = require("sides")
local inventory = require("nashy-inventory")

local settings = dofile("/usr/bin/automatic-agglomeration/settings.cfg")

local function drop(transposer_dropper, transposer_dropper_side, redstone_dropper, redstone_dropper_side)
    if (inventory.isEmpty(transposer_dropper, transposer_dropper_side) == false) then
        for i = 1, 3, 1 do
            redstone_dropper.setOutput(redstone_dropper_side, 15)
            os.sleep(0.25)
            redstone_dropper.setOutput(redstone_dropper_side, 0)
        end
    else
        return true
    end
end

while true do
    for index in pairs(settings.rigs) do
        os.sleep(1)
        local redstone_pool = component.proxy(component.get(settings.rigs[index].redstone_pool_address))
        local redstone_pool_side = settings.rigs[index].redstone_pool_side

        local redstone_dropper = component.proxy(component.get(settings.rigs[index].redstone_dropper_address))
        local redstone_dropper_side = settings.rigs[index].redstone_dropper_side

        local redstone_detector = component.proxy(component.get(settings.rigs[index].redstone_detector))
        local redstone_detector_side = settings.rigs[index].redstone_detector_side

        local transposer_dropper = component.proxy(component.get(settings.rigs[index].transposer_dropper))
        local transposer_dropper_side = settings.rigs[index].transposer_dropper_side

        local pool_percent = (redstone_pool.getComparatorInput(redstone_pool_side) / 15) -- percent value between 0 and 1.0
        local mana_threshold = settings.rigs[index].mana_threshold

        if (pool_percent > mana_threshold and redstone_detector.getInput(redstone_detector_side) == 0) then
            drop(transposer_dropper, transposer_dropper_side, redstone_dropper, redstone_dropper_side)
        end

        if (settings.debug == true) then
            term.write("Current mana level: " .. pool_percent .. "\n")
            term.write("Required mana level: " .. mana_threshold .. "\n")
        end
        
    end
    os.sleep(1)
end


--[[
    if the pool is above the minimum threshold AND the dropper has items in it THEN drop 3 items

    when items are dropped a flag needs to be saved so i can move into the waiting phase,

    if the waiting flag is true then i need to wait until an item shows up in the buffer vacume chest

    once an item is in the buffer chest i can then export it to the ME system
]]