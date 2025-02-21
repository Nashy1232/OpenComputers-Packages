local redstone = {}

function redstone.setOutputAllSides(component, value)
    component.setOutput({val, val, val, val, val, val})
end