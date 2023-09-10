local component = require("component") 
local os = require("os")
local term = require("term")
local inventory = require("nashy-inventory")

local settings = dofile("/usr/bin/automatic-agglomeration/settings.cfg")

local function status_check()
    local status = {
        mana = false,
        dropper = false,
        buffer = false
    }

end

while true do
    for index in pairs(settings.rigs) do
        os.sleep(0.5)
        local redstone_pool = component.proxy(component.get(settings.rigs[index].redstone_pool_address))
        local redstone_pool_side = settings.rigs[index].redstone_pool_side
        local pool_percent = (redstone_pool.getComparatorInput(redstone_pool_side) / 15) -- percent value between 0 and 1.0
        local mana_threshold = settings.rigs[index].mana_threshold
        local transposer_items = component.proxy(component.get(settings.rigs[index].transposer_items))
        local transposer_buffer_side = settings.rigs[index].transposer_buffer_side

        if pool_percent > mana_threshold then 

        end
    end
    os.sleep(1)
end