local cipher_protocol = "cipherprotocol"
local cipher_hostname = "cipherhost_1"

--//TODO: Could this be made always available?
local function cipher(mode, text)
    if mode == "encrypt" then
        return peripheral.call("cipher_0", mode, text)
    elseif mode == "decrypt" then
        return peripheral.call("cipher_0", mode, text)
    else
        print("No valid mode for cipher set.")
    end
    return nil
end



local function cipherserver()
    rednet.open("top")
    rednet.host(cipher_protocol, cipher_hostname)

    while true do
        local event = {os.pullEventRaw}

        if event[1] == "terminate" then
            rednet.unhost(cipher_protocol)
            rednet.close()
            return false
        elseif event[1] == "rednet_message" then
        
        end

    end

    return true
end

if shell.getRunningProgram() == "cipherer" then
    if cipherserver() then
        os.reboot()
    end
end

return