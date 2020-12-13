local locator_protocol = "locatorCom"
local locator_host     = "locatorServer"

modem = nil

-- REDO
function updateLocator()

    local payload = {}
    payload[1] = "locator"

    local locatorFile = fs.open("locator", "r")
    payload[2] = locatorFile.readAll()

    --math.randomseed(os.epoch("local"))

    rednet.host(locator_protocol, locator_host)
    rednet.send(rednet.lookup("sendprogramComs", "sendprogramServer"), payload, "sendprogramComs")

    local id, message = rednet.receive(15)

    if message then
        return true
    end

    return false
end

rednet.open("back")

if not (arg[2] == 1) then
    if not updateLocator() then
        shell.run("test", "locator")
        shell.run("locator", "1")
    end
end


--local modem = peripheral.wrap("modem_1")
