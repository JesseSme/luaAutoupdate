local serial = require("serial")

modem = nil

-- REDO
function updateLocator()

    local payload = {}
    payload[1] = "locator"

    local locatorFile = fs.open("locator", "r")
    payload[2] = locatorFile.readAll()

    math.randomseed(os.epoch("local"))

    local reply_channel = 0
    repeat
        reply_channel = math.random(2, 65530)
    until not (reply_channel == 17049)

    local serialized_payload = serial.serializeMessage(payload)
    modem.open(reply_channel)
    modem.transmit(20, reply_channel, serialized_payload)
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


modem = peripheral.wrap("back")
--local modem = peripheral.wrap("modem_1")
modem.open(17049)

if not (arg[2] == 1) then
    updateLocator()
end