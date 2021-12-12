local versionCheck = {}

local expect = expect.expect

function versionCheck.checkScriptVersion(updatable)
    expect(1, updatable, "string")
    payload[1] = updatable

    local locatorFile = fs.open(updatable, "r")
    payload[2] = locatorFile.readAll()

    --math.randomseed(os.epoch("local"))

    rednet.host(updatable.."_protocol", updatable.."_host")
    local lookup_id = rednet.lookup("sendprogramprotocol")
    rednet.send(lookup_id, payload, "sendprogramprotocol")

    local id, message = rednet.receive(15)

    if message then
        return true
    end

    return false
end

return versionCheck