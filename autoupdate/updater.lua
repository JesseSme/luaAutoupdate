--[[
    Serves programs from the main git computer
]]--
local self = {}

--Used to check for correct parameters
local expect = require("cc.expect")
local expect = expect.expect

local git = require("update")
local cipherer = require("cipherer")
local auth = require("auth")
local serial = require("serial")
local programs = git.programLinks

local loggedIn = true

--Modem variables.
local sendPrograms_channel = 69
local checkVersion_channel = 20
local modem_side = "top"

modem = nil
monitor = nil
oldTerm = nil


local function checkVersion(out_channel, msg)
    expect(1, out_channel, "number")
    expect(2, msg, "table")

    local program = nil

    if program == nil then
        print("Version check failed. Program not assigned.")
        return 0
    end

    local e_program = cipherer.cipher("encrypt", msg[2])
    local file = fs.open(msg[1], "r")
    local content = file.readAll()
    local e_version = cipherer.cipher("encrypt", content)

    if e_version == e_program then
        modem.transmit(out_channel, checkVersion_channel, true)
        return 1 -- Recent version
    else
        modem.transmit(out_channel, checkVersion_channel, false)
    end

    return 2 -- Different version
end


local function sendPrograms(out_channel, msg)

    --Always serialize msg before sending
    if not (msg == nil) then
        local return_msg = {}
        for key, prog in ipairs(msg) do
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
        return_msg = serial.serializeMessage(return_msg)
        modem.transmit(out_channel, 69, return_msg)
        print("Content transmitten on "..out_channel)
        return 1
    end --msg not nil
end --function


local function processIncomingMsg(side, in_channel, out_channel, msg, dist)

    local processedMsg = serial.deserializeMessage(msg)
    if processedMsg == 0 then
        return 0
    end

    if in_channel == sendPrograms_channel then
        sendPrograms(out_channel, processedMsg)
        return "sent"
    end

    if in_channel == checkVersion_channel then
        local version = checkVersion(out_channel, processedMsg)
        return ""
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
                    break
                end
                print("Serving programs...")
            end
        end
    end

    return 0
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