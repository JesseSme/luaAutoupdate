local locator_protocol = "locatorCom"
local locator_host     = "locatorServer"

modem = nil

local id = "iPad_Ender"

-- REDO
function updateLocator()

    local payload = {}
    payload[1] = "locator"

    local locatorFile = fs.open("locator", "r")
    payload[2] = locatorFile.readAll()

    math.randomseed(os.epoch("local"))

    modem.host(locator_protocol, locator_host)
    modem.send("sendprogramComs", payload)
    local event = nil
    local counter = 5
    repeat
        event = {os.pullEvent("rednet_message")}
        os.sleep(1)
        counter = counter - 1
    until counter == 0 or event ~= nil

    if counter == 0 then
        return false
    end
    if event[5] == true then
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
