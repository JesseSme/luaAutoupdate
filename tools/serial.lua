local serial = {}


function serial.serializeMessage(msg)
    return textutils.serialize(msg)
end


function serial.deserializeMessage(msg)
    local deserialized_msg = nil
    if not (type(msg) == "string") then
        print("Bad request.")
        return 0
    end
    deserialized_msg = textutils.unserialize(msg)
    for key, value in pairs(deserialized_msg) do
        print(tostring(key)..": "..tostring(value))
    end
    return deserialized_msg
end


return serial