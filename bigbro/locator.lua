local locator_protocol = "locatorprotocol"
local locator_host     = "locatorhost_1"

local spyturtle_protocol = "spyturtleprotocol"
local spyturtle_host     = "spyturtleleader"

local turtle_locations = {}

--Checks the locator version and determines
--if the program needs to reboot.
function checkLocatorVersion()

    local payload = {}
    payload[1] = "locator"

    local locatorFile = fs.open("locator.lua", "r")
    payload[2] = locatorFile.readAll()

    --math.randomseed(os.epoch("local"))

    rednet.host(locator_protocol, locator_host)
    local lookup_id = rednet.lookup("sendprogramprotocol")
    rednet.send(lookup_id, payload, "sendprogramprotocol")

    local id, message = rednet.receive(15)

    if message then
        return true
    end

    return false
end

function triangulate()

function listen()
    -- listens for rednet messages from spyturtles
    rednet.host(spyturtle_protocol, spyturtle_host)

    while true do
        local id, message = rednet.receive("spyturtleprotocol")
        print(message)
        if not (id == nil) then
            -- #TODO: Add message parsing and
            for field, fieldval in pairs(message) do
                if field == "turtlelocation" then
                    table.insert(turtle_locations, fieldval)
                    break
                end
            end
        end
    end
end


peripheral.find("modem", rednet.open)

if not checkLocatorVersion() then
    rednet.unhost(locator_protocol)
    peripheral.find("modem", rednet.close)
    shell.run("get", "locator")
    os.reboot()
end

print("Starting to listen...")
listen()