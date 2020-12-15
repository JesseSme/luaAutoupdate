local locator_protocol = "locatorCom"
local locator_host     = "locatorServer"

function updateLocator()

    local payload = {}
    payload[1] = "locator"

    local locatorFile = fs.open("locator", "r")
    payload[2] = locatorFile.readAll()

    --math.randomseed(os.epoch("local"))

    rednet.host(locator_protocol, locator_host)
    local lookup_id, message = rednet.receive(10)
    rednet.send(lookup_id, payload, "sendprogramComs")

    local id, message = rednet.receive(15)

    if message then
        return true
    end

    return false
end

--//TODO: Could also cause stack overflow.
if arg[1] == 1 then
    if not updateLocator() then
        shell.run("test", "locator")
        shell.run("locator", "1")
    end
end

peripheral.find("modem", rednet.open)


--local modem = peripheral.wrap("modem_1")
