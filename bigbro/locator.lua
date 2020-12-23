local locator_protocol = "locatorprotocol"
local locator_host     = "locatorhost_1"

--Checks the locator version and determines
--if the program needs to reboot.
function checkLocatorVersion()

    local payload = {}
    payload[1] = "locator"

    local locatorFile = fs.open("locator", "r")
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

function listen()
    -- listens for rednet messages from spyturtles

    while true do
        local rn = {rednet.receive(1)}
        if not (rn == nil) then
            local id, message = pairs(rn)
            -- #TODO: Add message parsing and
            -- database addition.
        end
    end
end


peripheral.find("modem", rednet.open)


if arg[1] == 1 then
    if not checkLocatorVersion() then
        rednet.unhost(locator_protocol)
        peripheral.find("modem", rednet.close)
        shell.run("get", "locator")
        os.reboot()
    end
end

listen()