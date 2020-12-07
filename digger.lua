local inventory = require("inventory")

--Module table
local dig = {}

--Variables
local FACING = 0 --Track facing of turtle

--Constants

--
local deposit = vector.new(2500, 76, -901)
local chunkCorner = vector.new(2464, 70, -928)

--port = 420
local channel = 69

local function getGPS()
    local loc = vector.new(gps.locate())
end


local function turn(turnEnd)
    while turnEnd ~= FACING do
        if turnEnd >= FACING then
            turtle.turnRight()
            FACING = FACING + 1
        elseif turnEnd <= FACING then
            turtle.turnLeft()
            FACING = FACING - 1
        end
    end

    if turnEnd == FACING then
        return true
    else
        return false
    end
end

--Dig main loop
function command()
    local modem = peripheral.wrap("right")

    while true do
        local event, parm1, parm2, parm3, parm4, parm5 = os.pullEventRaw()
        if event == "modem_message" then
            
        end
    end
end

()