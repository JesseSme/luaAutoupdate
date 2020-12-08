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

modem = nil

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
    --Wtf is going on between this
    --FIX: Always serialize msg before sending
    if not (msg == nil) then
        local return_msg = {}
        print(type(msg))
        os.sleep(1)
        local deserialized_msg = nil
        if not (type(msg) == "string") then
            print("Bad request.")
            return 0
        end
        deserialized_msg = textutils.unserialize(msg)
        for key, value in pairs(deserialized_msg) do
            print(tostring(key)..": "..tostring(value))
        end
    --and this
        for key, prog in ipairs(deserialized_msg) do
            if prog == "availableprograms" then
                return_msg = {}
                print("Gathering available programs...")
                local counter = 1
                for prog, url in pairs(programs) do
                    if prog == "auth" then
                    else
                        return_msg[counter] = prog
                        counter = counter + 1
                    end
                end
            else
                print("Getting specified programs...")
                if prog == "auth" then
                else
                    for ava_prog, _ in pairs(programs) do
                        if prog == ava_prog then
                            return_msg[ava_prog] = fs.readAll(fs.open(ava_prog))
                        end
                    end
                end
            end
            print("Content gathered...")
            return_msg = textutils.serialize(return_msg)
            modem.transmit(out_freq, 69, return_msg)
            print("Content transmitten on "..out_freq)
            return 1
        end
    end
end

--Functions need to be declared over this.
--Should probably make them their own file.
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
    modem = peripheral.wrap(modem_side)
    modem.open(in_signal)
    print("Serving programs...")
    while true do
        local event, param1, param2, param3, param4, param5 = os.pullEvent()
        for action, _ in pairs(actions) do
            if action == event then
                print(action)
                actions[event](param1, param2, param3, param4, param5)
                print("Serving programs...")
            end
        end
    end
end


term.clear()
term.setCursorPos(1, 1)
print("Initializing...")
serve()
print("Exiting...")