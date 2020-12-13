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
local sendprograms_protocol = "sendprogramComs"
local sendprograms_host     = "sendprogramServer"

local checkversion_protocol = "checkversionComs"
local checkversion_host     = "checkversionServer"

local modem_side = "top"

modem = nil
monitor = nil
oldTerm = nil


local function checkVersion(senderid, message)
    expect(1, senderid, "number")
    expect(2, message, "table")

    local program = nil

    for key, value in pairs(programs) do
        if key == message[1] then
            program = message[1]
        end
    end

    if program == nil then
        print("Version check failed. Program not assigned.")
        return 0
    end

    local e_program = cipherer.cipher("encrypt", program)
    local file = fs.open(message[1], "r")
    local content = file.readAll()
    local e_version = cipherer.cipher("encrypt", content)

    if e_version == e_program then
        rednet.send(senderid, true)
        return 1 -- Recent version
    else
        rednet.send(senderid, false)
    end

    return 2 -- Different version
end


local function sendPrograms(senderid, msg)

    if not (msg == nil) then
        print(msg)
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
            end -- available programs
        end -- ipairs(processedMsg)
        print("Content gathered...")
        rednet.send(senderid, return_msg, "LocatorCom")
        print("Content transmitted to "..senderid)
        return 1
    end --msg not nil
end --function


local function processIncomingMsg(senderid, message, protocol)
    print(senderid)
    print(message)
    print(protocol)

    if protocol == "dns" then
        if rednet.send(senderid, os.getComputerID()) then
            print("Sent data.")
        end
        return "Checked"
    end

    if protocol == sendprograms_protocol then
        sendPrograms(senderid, message)
        return "sent"
    end

    if protocol == checkversion_protocol then
        local version = checkVersion(senderid, message)
        return ""
    end

end


--Functions need to be declared over this.
--Should probably make them their own file.
actions = {
    ["terminate"]= function() return nil end,
    ["rednet_message"]= processIncomingMsg,
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
    --
    rednet.host(sendprograms_protocol, sendprograms_host)
    rednet.host(checkversion_protocol, checkversion_host)
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
rednet.open(modem_side)
serve(arg[1], arg[2])
term.clear()
term.redirect(oldTerm)
print("Press any key to exit...")
local event, key = os.pullEvent("key")
term.clear()
term.setCursorPos(1, 1)