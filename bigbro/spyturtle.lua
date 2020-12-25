local spyturtle_protocol = "spyturtleprotocol"
local spyturtle_host     = "spyturtle_"

local turtle_loc = {turtle_location={}}
local radar = nil

-------------------------------------
-- Needs to use independent radars --
-------------------------------------

-------------------------------------------------------------
-- This peace of shit works, but the radars in-game are
-- limited to a radius of 8 blocks.
-- Sooooooo. Hours well wasted. Wooooo...
-------------------------------------------------------------

function checkSpyVersion()

    local payload = {}
    payload[1] = "spyturtle"

    local locatorFile = fs.open("spyturtle", "r")
    payload[2] = locatorFile.readAll()

    --math.randomseed(os.epoch("local"))

    rednet.host(spyturtle_protocol, spyturtle_host)
    local lookup_id = rednet.lookup("sendprogramprotocol")
    rednet.send(lookup_id, payload, "sendprogramprotocol")

    local id, message = rednet.receive(15)

    if message then
        return true
    end

    return false
end


function spy()

    turtle_loc["turtle_location"] = {gps.locate()}
    radar = peripheral.find("radar")
    rednet.broadcast(turtle_loc, spyturtle_protocol)

    while true do
        -- entities is two dimensional
        local lookup_id = rednet.lookup("spyturtleprotocol")
        local entities = radar.getPlayers()
        -- First key is probably amount of players
        if not (entities == nil) then
            for key, value in pairs(entities) do
                local data = {}
                for field, fval in pairs(value) do
                    data[field] = fval
                    print(field..": "..fval)
                end
                rednet.broadcast(data, "spyturtleprotocol")
            end
        end
        os.sleep(.5)
    end
end

peripheral.find("modem", rednet.open)
--if not checkSpyVersion() then
--    rednet.unhost(locator_protocol)
--    peripheral.find("modem", rednet.close)
--    shell.run("get", "spyturtle")
--    os.reboot()
--end

spy()