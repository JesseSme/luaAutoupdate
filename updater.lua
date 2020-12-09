--[[
    Serves programs from the main git computer
]]--

local git = require("update")
local auth = require("auth")
local programs = git.programLinks

local loggedIn = true

--Modem variables.
local in_signal = 69
local modem_side = "top"

modem = nil
monitor = nil
oldTerm = nil

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


local function processIncomingMsg(msg)
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


local function sendPrograms(side, in_freq, out_freq, msg, dist)
    if not (in_freq == in_signal) then
        modem.transmit(out_freq, in_signal, "Try channel "..in_signal)
        return 0
    end
    --Always serialize msg before sending
    if not (msg == nil) then
        local return_msg = {}
        local processedMsg = processIncomingMsg(msg)
        if processedMsg == 0 then
            return 0
        else
            for key, prog in ipairs(processedMsg) do
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
                                local file = fs.open(ava_prog, "r")
                                return_msg[ava_prog] = file.readAll()
                            end
                        end
                    end
                end-- available programs
            end -- ipairs(processedMsg)
            print("Content gathered...")
            return_msg = textutils.serialize(return_msg)
            modem.transmit(out_freq, 69, return_msg)
            print("Content transmitten on "..out_freq)
            return 1
        end -- not processedMsg
    end --msg not nil
end --function

--Functions need to be declared over this.
--Should probably make them their own file.
actions = {
    ["terminate"]= function() return nil end,
    ["modem_message"]= sendPrograms,
    ["timer"]= function()
                git.update()
                os.startTimer(360)
    end
}

--Add proximity log out to this.
local function serve(user, pass)
    while loggedIn do
        if auth.credenticate(user, pass) == 1 then
            term.setCursorPos(1, 1)
            term.clear()
            print("Logged in!")
            loggedIn = false
        else
            return 0
        end
    end
    os.startTimer(360)
    modem = peripheral.wrap(modem_side)
    modem.open(in_signal)
    monitor = peripheral.wrap("right")
    monitor.setTextScale(0.5)
    oldTerm = term.redirect(monitor)
    term.clear()
    term.setCursorPos(1,1)
    print("Serving programs...")
    while true do
        local event, param1, param2, param3, param4, param5 = os.pullEvent()
        for action, _ in pairs(actions) do
            if action == event then
                print(action)
                local returnstate = actions[event](param1, param2, param3, param4, param5)
                if returnstate == nil then
                    return
                end
                print("Serving programs...")
            end
        end
    end
end


term.clear()
term.setCursorPos(1, 1)
print("Initializing...")
serve(arg[1], arg[2])
term.clear()
term.redirect(oldTerm)
print("Press any key to exit...")
local event, key = os.pullEvent("key")
term.clear()
term.setCursorPos(1, 1)