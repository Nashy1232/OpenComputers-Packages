local component = require("component") 
local os = require("os")
local term = require("term")

local settings = dofile("/usr/bin/automatic-agglomeration/settings.cfg")

local sides = require("sides")
local geo = component.proxy(component.get("459b"))
local s = sides.bottom
local data = geo.analyze(s)

for k,v in pairs(data) do
    term.write(k)
    term.write(" : ")
    term.write(v)
    term.write("\n")
end

-- returns percentage value from 0 to 1.0
function get_pool_percent(redstone, side)
    local compare_value = rs.getComparatorInput(side)
    return (compare_value / 15)
end

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