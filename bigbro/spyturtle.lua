local spyturtle_protocol = "spyturtleprotocol"
local spyturtle_host     = "spyturtle_"

local turtle_location = nil

function checkSpyVersion()

    local payload = {}
    payload[1] = "spyturtle"

    local locatorFile = fs.open("spyturtle", "r")
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


function spy()

end


if not checkLocatorVersion() then
    rednet.unhost(locator_protocol)
    peripheral.find("modem", rednet.close)
    shell.run("get", "locator")
    os.reboot()
end

spy()