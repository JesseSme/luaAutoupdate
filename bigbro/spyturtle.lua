local spyturtle_protocol = "spyturtleprotocol"
local spyturtle_host     = "spyturtle_"

local turtle_location = nil
local radar = nil

-------------------------------------
-- Needs to use independent radars --
-------------------------------------

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

    turtle_location = gps.locate()
    radar = peripheral.find("radar")

    while true do
        -- entities is two dimensional
        local lookup_id = rednet.lookup("spyturtleprotocol")
        local entities = {radar.getPlayers()}
        -- First key is probably amount of players

        if not (entities == nil) then
            for key, value in pairs(entities) do
                local data = {}
                for field, fval in pairs(value) do
                    data[field] = fval
                end
                rednet.send(lookup_id, data, "spyturtleprotocol")
            end
        end
        os.sleep(2)
    end
end

peripheral.find("modem", rednet.open)
if not checkSpyVersion() then
    rednet.unhost(locator_protocol)
    peripheral.find("modem", rednet.close)
    shell.run("get", "spyturtle")
    os.reboot()
end

spy()