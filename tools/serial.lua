local serial = {}


function serial.serializeMessage(msg)
    local message = textutils.serialize(msg)
    return message
end


function serial.deserializeMessage(msg)
    local deserialized_msg = nil
    if type(msg) == "string" then
        deserialized_msg = textutils.unserialize(msg)
    else
        print("Not string, not unserialized!")
        deserialized_msg = msg
    end
    return deserialized_msg
end


return serial