local inv = {}

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


function inv.combineStacks()
    local inventory = getItems()

    for key, invValue in pairs(inventory) do
        for key2, invValue2 in pairs(inventory) do
            if invValue2.name == invValue.name then
                turtle.select(key)
                if (turtle.getItemCount() < 64) then
                    turtle.select(key2)
                    if (turtle.getItemCount() < 64) then
                        turtle.transferTo(key)
                    end
                end
            end
        end
    end
    turtle.select(1)
end


function inv.refuel()
    if turtle.getFuelLevel() < 10000 then
        local inventory = getItems()
        local coal = "minecraft:coal"
        for key, invValue in pairs(inventory) do
            if coal == invValue.name then
                turtle.select(key)
                turtle.refuel()
            end
        end
        turtle.select(1)
    end
end


function inv.dropItemUseless()
    local inventory = getItems()
    local uselessStuff = {
        "minecraft:cobblestone",
        "minecraft:granite",
        "minecraft:stone",
        "quark:biome_cobblestone",
        "quark:slate",
        "chisel:basalt2",
        "rustic:slate",
        "minecraft:dirt",
        "quark:root_flower",
        "projectred-core:resource_item",
        "botania:mushroom",
        "chisel:limestone2",
        "chisel:marble2",
        "minecraft:clay_ball",
        "minecraft:torch",
        "minecraft:gravel",
        "thaumcraft:crystal_essence"
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

--function invmanip.manageInventory()

--end

return inv