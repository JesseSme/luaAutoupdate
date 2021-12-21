local qwait = require("./tools/qwait").wait

local modem = peripheral.find("modem")
if modem == nil then error("monitor not found") end
rednet.open("bottom")
rednet.host("door", "doorOpener")

local function setup()
end

local function open()
end

local function waitForSignal()
    while true do
        local id, message, protocol
        repeat
            id, message, protocol = rednet.receive()
        until 3 == id
        if message == "t" then
            rs.setAnalogOutput("top", 15)
            print(rs.getAnalogOutput("top"))
        else
            rs.setAnalogOutput("top", 0)
            print(rs.getAnalogOutput("top"))
        end
    end
end


parallel.waitForAny(waitForSignal, qwait)