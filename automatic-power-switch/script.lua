local os = require("os")
local component = require("component")
local term = require("term")

local settings = dofile("/usr/bin/automatic-power-switch/settings.cfg")

local function display_info(data)
    for index in pairs(data) do
        os.sleep(0.1)
        term.write(index .. "\n")
        term.write("Max Energy: " .. data[index].maxEnergy .. "\n")
        term.write("Current Energy: " .. data[index].curEnergy .. "\n")
        term.write("Percent: " .. data[index].percent .. "\n")
        term.write("----------------------------------------------------------------\n")
        --os.sleep(0.2)
    end
end

local function rs(val)
    for address in pairs(settings.redstone_addresses) do
        local rs = component.proxy(component.get(settings.redstone_addresses[address]))
        rs.setOutput({val, val, val, val, val, val})
    end
end

local capacitors = {}
for address in pairs(settings.capacitor_addresses) do
    local capacitor = component.proxy(component.get(settings.capacitor_addresses[address]))
    table.insert(capacitors, capacitor)
end

local status = {}
local readout_data = {}
local active = false
while true do
    if (settings.debug == true) then
        term.clear()
    end

    for capacitor in pairs(capacitors) do
        max_energy = capacitors[capacitor].getEnergyCapacity()
        cur_energy = capacitors[capacitor].getEnergyStored()
        if (settings.debug == true or settings.readout == true) then
            address = capacitors[capacitor].address
            readout_data[address] = {}
            readout_data[address].maxEnergy = math.floor(max_energy)
            readout_data[address].curEnergy = math.floor(cur_energy)
            readout_data[address].percent = math.floor((cur_energy / max_energy) * 100)
        end
        if (cur_energy < (max_energy * 0.50)) then
            table.insert(status, true)
        elseif (cur_energy > (max_energy * 0.80)) then
            table.insert(status, false)
        end
        os.sleep(1)
    end

    activate = false
    for i in pairs(status) do
        if (status[i] == true) then
            activate = true
            os.sleep(1)
            break
        end
    end

    if (activate) then
        rs(15)
    else
        rs(0)
    end

    if (settings.debug == true) then
        if (activate == true) then
            term.write("Generators: Online")
        else
            term.write("Generators: Offline")
        end
    end

    for i in pairs(status) do
        status[i] = nil
        os.sleep(1)
    end
    
    if (settings.debug == true or settings.readout == true) then
        term.clear()
        display_info(readout_data)
    end

    os.sleep(5)
end