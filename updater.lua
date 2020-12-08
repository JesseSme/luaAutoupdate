--[[
    Serves programs from the main git computer
]]--

local git = require("update")
local auth = require("auth")
local programs = git.programLinks

local loggedIn = true

--Modem variables.
local in_signal = 69
local out_signal = 70
local modem_side = "top"

local function cipherer(mode, text)
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


local function sendPrograms(side, in_freq, out_freq, msg, dist)
    if not (in_freq == in_signal) then
        modem.transmit(out_freq, in_signal, "Try channel "..in_signal)
        return 0
    end
    if not (msg == nil) then
        os.sleep(1)
        local wanted_programs = textutils.unserialize(msg)
        local return_msg = {}
        if msg == "availableprograms" then
            print("Gathering available programs...")
            local counter = 1
            for prog, url in pairs(programs) do
                if prog == "auth" then
                else
                    return_msg[counter] = prog
                    counter = counter + 1
                end
            end
            return_msg = textutils.serialize(return_msg)
            print("Transmitting to channel..")
            modem.transmit(out_freq, 69, return_msg)
        else
            local deserialized_msg = nil
            if not (type(msg) == "table") then
                deserialized_msg = {msg}
            else
                deserialized_msg = textutils.unserialize(msg)
            end

            for key, prog in ipairs(deserialized_msg) do
                if prog == "auth" then
                else
                    for ava_prog, _ in pairs(programs) do
                        if prog == ava_prog then
                            local content = fs.readAll(fs.open(ava_prog))
                            modem.transmit(out_freq, 69, content)
                        end
                    end
                end
            end
        end
    end
end


actions = {
    ["terminate"]= function () do return end end,
    ["modem_message"]= sendPrograms
}

--Add proximity log out to this.
local function serve()
    while loggedIn do
        if auth.credenticate() then
            term.setCursorPos(1, 1)
            term.clear()
            print("Logged in!")
            loggedIn = false
        else
            do return end
        end
    end
    local modem = peripheral.wrap(modem_side)
    modem.open(in_signal)
    print("Serving programs...")
    while true do
        local event, param1, param2, param3, param4, param5 = os.pullEventRaw()
        print(event)
        for action, _ in pairs(actions) do
            if action == event then
                print(action)
                actions[event](param1, param2, param3, param4, param5)
            end
        end
    end
end


term.clear()
term.setCursorPos(1, 1)
print("Initializing...")
serve()
print("Exiting...")