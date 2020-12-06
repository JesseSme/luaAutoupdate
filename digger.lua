local inventory = require("inventory")

--Variables
local FACING = 0 --Track facing of turtle

--Constants

--
local deposit = vector.new(2500, 76, -901)
local chunkCorner = vector.new(2464, 70, -928)

--port = 420
--channel = 69

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


local modem = peripheral.wrap("right")

while true do
    local event = os.pullEventRaw()
    if event == "modem_message" then

    end
end