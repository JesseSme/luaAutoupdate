local invmanip = {}

local function getItems()
    local inventory = {}
    for i=1,16,1 do
        turtle.select(i)
        if turtle.getItemDetail() ~= nil then
            inventory[i] = turtle.getItemDetail()
            print(inventory[i].name)
        end
    end

    return inventory
end


local function combineStacks()

end


local function refuel()

end


function invmanip.dropItemUseless()
    local inventory = getItems()
    local uselessStuff = {
        "minecraft:cobblestone",
        "minecraft:granite",
        "minecraft:stone",
        "quark:biome_cobblestone",
        "quark:slate",
        "chisel:basalt2",
        "rustic:slate",
        "minecraft:dirt"
    }

    for i, value in ipairs(uselessStuff) do
        for key, invValue in pairs(inventory) do
            if value == invValue.name then
                turtle.select(key)
                turtle.drop()
            end
        end
    end
    turtle.select(1)
end

function invmanip.manageInventory()

end

return invmanip