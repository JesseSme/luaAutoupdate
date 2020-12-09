
function updateLocator()
    local locatorFile = fs.open("locator", "r")
    local content = locatorFile.readAll()

    local x, y, z = gps.locate()
    math.randomseed(x + y + z + os.time() + os.clock())

    local reply_channel = 0
    repeat
        reply_channel = math.random(1, 65535)
    until not (reply_channel == 17049)

    modem.transmit(17049, reply_channel, content)

    local event = {os.pullEvent("modem_message")}

end

local modem = peripheral.wrap("modem_1")

