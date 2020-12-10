
function updateLocator()
    local locatorFile = fs.open("locator", "r")
    local content = locatorFile.readAll()

    local x, y, z = gps.locate()
    math.randomseed(x + y + z + os.time() + os.clock())

    local reply_channel = 0
    repeat
        reply_channel = math.random(2, 65535)
    until not (reply_channel == 17049)

    local serialized_locator = textutils.serialize("locator")
    modem.open(reply_channel)
    modem.transmit(1, reply_channel, serialized_locator)
    local event = nil
    local downcount = 30
    repeat
        event = {os.pullEvent("modem_message")}
        os.sleep(1)
        downcount = downcount - 1
    until downcount == 0

    if downcount == 0 then
        return false
    end

    if event[5] == "ok" then
        modem.transmit(1, reply_channel, content)
    end

    downcount = 30
    repeat
        event = {os.pullEvent("modem_message")}
        os.sleep(1)
        downcount = downcount - 1
    until downcount == 0

    if event[5] then
        return true
    end

    return false
end

local modem = peripheral.wrap("modem_1")

