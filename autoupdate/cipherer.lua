local cipherer = {}


function cipherer.cipher(mode, text)
    if mode == "encrypt" then
        return peripheral.call("cipher_0", mode, text)
    else if mode == "decrypt" then
        return peripheral.call("cipher_0", mode, text)
    else
        print("No valid mode for cipher set.")
    end
    return nil
    end
end



return cipherer