--[[
    Serves programs from the main git computer
]]--
local self = {}

local git = require("update")
local cipherer = require("cipherer")
local auth = require("auth")
local programs = git.programLinks

local loggedIn = true

--Modem variables.
local sendPrograms_channel = 69
local checkVersion_channel = 1
local modem_side = "top"

modem = nil
monitor = nil
oldTerm = nil

local function checkVersion(program_name, program)
    local e_program = cipherer.cipher("encrypt", program)
    local file = fs.open(program_name, "r")
    local content = file.readAll()
    local e_version = cipherer.cipher("encrypt", content)
    if e_version == e_program then
        return true
    end
    return false
end

local function deserializeMessage(msg)
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


local function sendPrograms(out_channel, msg)

    --Always serialize msg before sending
    if not (msg == nil) then
        local return_msg = {}
        local processedMsg = deserializeMessage(msg)
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
            modem.transmit(out_channel, 69, return_msg)
            print("Content transmitten on "..out_channel)
            return 1
        end -- not processedMsg
    end --msg not nil
end --function


local function processIncomingMsg(side, in_channel, out_channel, msg, dist)

    local processedMsg = {deserializeMessage(msg)}
    if processedMsg == 0 then
        return 0
    end

    if in_channel == sendPrograms_channel then
        sendPrograms(out_channel, msg)
        return "sent"
    end
end


--Functions need to be declared over this.
--Should probably make them their own file.
actions = {
    ["terminate"]= function() return nil end,
    ["modem_message"]= processIncomingMsg,
    ["timer"]= function()
                git.update()
    end
}

--The main loop of the program.
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
    modem.open(sendPrograms_channel)
    modem.open(checkVersion_channel)
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