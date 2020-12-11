local serial = {}


function serial.serializeMessage(msg)
    local message = textutils.serialize(msg)
    return message
end


function serial.deserializeMessage(msg)
    local deserialized_msg = nil
    if type(msg) ~= "string" or type(msg) ~= "table" then
        print("Bad request.")
        return 0
    end
    deserialized_msg = textutils.unserialize(msg)
    return deserialized_msg
end


return serial