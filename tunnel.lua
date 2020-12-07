-- Original direction is 0.
-- -1 when turning left.
-- +1 when turning right.
local dig = {}
local inventory = require("inventory")

--Variables to track direction of turtles
FACING = 0
DIRECTION = 1

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

local function wide(widthWide)
    local width = widthWide

    for i=1,width do
        print("Digging for ", width-i, " blocks")
        if turtle.detect() then
            turtle.dig()
        end
        turtle.forward()
    end
end

local function slice(height2, width)
    --Slices a piece out of earth
    print("Slice ")
    local height = math.floor(height2)
    for i=1, height do
        local rota = math.fmod(i, 2)
        if rota == 1 then
            --Right
            turn(1)
        elseif rota == 0 then
            --Left
            turn(-1)
        end

        wide(width)

        if (i < height) then
            if turtle.detectUp() then
                turtle.digUp()
            end
            turtle.up()
        else
            print("i = height")
        end
    end

    --Returns to start
    if math.fmod(height, 2) == 0 then
        for i=1, width do
            if FACING ~= -1 then
                turn(-1)
            end
            turtle.forward()
        end
        for i=1, height-1 do
            turtle.down()
        end
    end
    for i=1, height-1 do
        turtle.down()
    end

end

function dig.tunnel(length, width, height)
    local length, width, height = length, width, height

    for i=1,length do
        --Prepare to move forward
        if FACING ~= 0 then
            turn(0)
            if turtle.detect() then
                turtle.dig()
            end
            turtle.forward()
        end

        --Mine widths for heights
        slice(height, width)
        inventory.dropItemUseless()
        inventory.refuel()
        inventory.combineStacks()
    end
    turn(0)
    return 1
end

return dig