local component = require("component") 
local os = require("os")
local term = require("term")
local nashy = require("nashy-inventory")

local settings = dofile("/usr/bin/automatic-agglomeration/settings.cfg")

local sides = require("sides")

local t = component.proxy(component.get("59a5"))
local s = sides.up

local x = nashy.inventory.isEmpty(t,s)
term.write(tostring(x))

--[[
while true do
    for index in pairs(settings.rigs) do
        os.sleep(0.5)
        local redstone_pool = component.proxy(component.get(settings.rigs[index].redstone_pool_address))
        local redstone_pool_side = settings.rigs[index].redstone_pool_side
        local pool_percent = (redstone_pool.getComparatorInput(redstone_pool_side) / 15) -- percent value between 0 and 1.0
        local mana_threshold = settings.rigs[index].mana_threshold

        if pool_percent > mana_threshold then 
            term.write("true")
            return
        else
            term.write("false")
            return
        end


    end
    os.sleep(1)
end
]]