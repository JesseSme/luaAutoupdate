--[[
    Serves programs from the main git computer
]]--

local git = require("update")
local auth = require("auth")
local programs = git.programLinks

local loggedIn = true
local actions = {
    ["terminate"]= function () do return end end,
    ["modem_message"]= sendPrograms
}


--Add proximity log out to this.
local function serve()
    while loggedIn do
        if auth.authenticate() then
            term.setCursorPos(1, 1)
            term.clear()
            print("Logged in!")
            print("Serving programs...")
            loggedIn = false
        else
            do return end
        end
    end
    local modem = peripheral.wrap("top")
    while true do
        local event, param1, param2, param3, param4, param5 = os.pullEventRaw()
        for action in actions do
            if action == event then
                actions[event](param1, param2, param3, param4, param5)
            end
        end
    end
end


serve()
print("Exiting...")