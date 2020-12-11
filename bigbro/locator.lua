local serial = require("serial")

-- REDO
function updateLocator()

    local payload = {}
    payload[1] = "locator"

    local locatorFile = fs.open("locator", "r")
    payload[2] = locatorFile.readAll())

    math.randomseed(os.epoch("local"))

    local reply_channel = 0
    repeat
        reply_channel = math.random(2, 65530)
    until not (reply_channel == 17049)

    local serialized_payload = serial.serialize("locator")
    modem.open(reply_channel)
    modem.transmit(reply_channel, 1, serialized_payload)
    local event = nil
    local counter = 30
    repeat
        event = {os.pullEvent("modem_message")}
        os.sleep(1)
        counter = counter - 1
    until counter == 0 or event ~= nil

    if counter == 0 then
        return false
    end

    local deserialized_msg = serial.deseralizeMessage(event[5])
    if event[5] == true then
        return true
    end

    return false
end

local modem = peripheral.wrap("modem_1")

