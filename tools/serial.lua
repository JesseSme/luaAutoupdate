local serial = {}


function serial.serializeMessage(msg)
    local message = textutils.serialize(msg)
    return message
end


function serial.deserializeMessage(msg)
    local deserialized_msg = nil
    deserialized_msg = textutils.unserialize(msg)
    return deserialized_msg
end


return serial