local component = require("component") 
local os = require("os")
local term = require("term")

local settings = dofile("/usr/bin/automatic-agglomeration/settings.cfg")

ed_rs = component.proxy(component.get(settings.ed_rs_address))
ed_side = settings.ed_rs_side
mp_rs = component.proxy(component.get(settings.mp_rs_address))
mp_side = settings.mp_rs_side
drop_rs = component.proxy(component.get(settings.drop_rs_address))
drop_side = settings.drop_rs_side

while true do
    if (ed_rs.getInput(ed_side) == 0 and mp_rs.getComparatorInput(mp_side) >= 14) then
        drop_rs.setOutput(drop_side, 15)
        os.sleep(0.1)
        drop_rs.setOutput(drop_side, 0)
    end
    os.sleep(0.5)
end