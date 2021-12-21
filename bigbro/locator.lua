local turtle_locations = {}
local qwait = require("./tools/qwait").wait
--Checks the locator version and determines
--if the program needs to reboot.

local kulliInTheHouse = false
local oldInTheHouse = false
--test
local trashFilter = {
    "minecraft:cobblestone",
    "minecraft:dirt",
    "minecraft:blackstone",
    "minecraft:gravel",
    "quark:jasper",
    "quark:cobbled_deepslate",
    "byg:soapstone",
    "byg:rocky_stone",
    "byg:scoria_cobblestone",
    "mysticalagriculture:inferium_essence",
    "thermal:niter",
    "ars_nouveau:mana_gem",
    "rftoolsbase:dimensionalshard"
}

local invFilter = {
    "minecraft:iron_ore",
    "minecraft:flint",
    "minecraft:coal",
    "minecraft:clay_ball",
    "minecraft:sand",
    "minecraft:sandstone",
    "minecraft:andesite",
    "minecraft:gold_ore",
    "minecraft:redstone",
    "minecraft:lapis_lazuli",
    "minecraft:diamond",
    "astralsorcery:marble_raw",
    "thermal:cinnabar",
    "thermal:tin_ore",
    "thermal:silver_ore",
    "thermal:nickel_ore",
    "thermal:lead_ore",
    "thermal:copper_ore",
    "thermal:sulfur",
    "create:zinc_ore",
    "mekanism:osmium_ore",
    "mekanism:fluorite_gem",
    "mekanism:uranium_ore",
    "appliedenergistics2:certus_quartz_crystal",
    "appliedenergistics2:charged_certus_quartz_crystal",
    "mysticalagriculture:prosperity_shard",
}
    --[[


    ]]--
local housecorner1 = {
    ["x"] = 1946,
    ["y"] = 80,
    ["z"] = 2085
}
local housecorner2 = {
    ["x"] = 1929,
    ["y"] = 62,
    ["z"] = 2118
}

local trashManager = peripheral.wrap("inventoryManager_0")
if trashManager == nil then error("inventoryManager_0 not found") end
print(peripheral.getName(trashManager))
local invManager = peripheral.wrap("inventoryManager_1")
if invManager == nil then error("inventoryManager_1 not found") end
print(peripheral.getName(invManager))
local detector = peripheral.find("playerDetector")
if detector == nil then error("playerDetector not found") end
local monitor = peripheral.find("monitor")
if monitor == nil then error("monitor not found") end
local modem = peripheral.find("modem")
if modem == nil then error("modem not found") end
rednet.open("right")
rednet.host("home", "jeserver")

local function setup()
end

local function jesuInvDump()
    while true do
        os.sleep(1)
        local invitems = trashManager.getItems()
        for k, v in pairs(invitems) do
            for k,v2 in pairs(v) do
                print(v2)
                --if type(v2) == "table" then
                --    for k, v3 in pairs(v2) do 
                --        print(v3)
                --    end
                --end
            end
        end

        for k, v in ipairs(trashFilter) do
            trashManager.removeItemFromPlayer("right", 100, -1, v)
        end
        for k, v in ipairs(invFilter) do
            invManager.removeItemFromPlayer("front", 100, -1, v)
        end
    end
end

local function track()
    while true do
        os.sleep(1)
        local players = detector.getPlayersInCoords(housecorner1, housecorner2)
        kulliInTheHouse = false
        for k, v in pairs(players) do
            if v == "RUNKKUKULLI" then
                kulliInTheHouse = true
                break
            end
        end
        local sendSuccess = false
        if kulliInTheHouse and not oldInTheHouse then
            sendSuccess = rednet.send(6, "t", "door")
            --print(sendSuccess)
            --oldInTheHouse = kulliInTheHouse
        elseif not kulliInTheHouse then
            sendSuccess = rednet.send(6, "f", "door")
            --print(sendSuccess)
            --oldInTheHouse = kulliInTheHouse
        end
    end
end

--peripheral.find("modem", rednet.open)
--term.redirect(monitor)
parallel.waitForAny(jesuInvDump,track, qwait)
