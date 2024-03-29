--[[
    HIATUS
]]--

local inventory = require("inventory")
local tunnel    = require("tunnel")
local getgit    = require("getgit")

error = {}

local function quit()
    while true do
        print("Press 'Q' to quit.")
        local event, key = os.pullEvent("key")

        if key == keys.q then
            print("Exiting")
            do return end
        end
    end
end

--Updates programs.
if not getgit.update() then
    for key, val in error do
        print(key, ": ", val)
    end
    do return end
end


--Starts tunnel mining
if tunnel.tunnel(arg[1], arg[2], arg[3]) then
    quit()
else
    print("something went wront with tunneling.")
    quit()
end