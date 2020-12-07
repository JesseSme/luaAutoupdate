--[[
    Serves programs from the main git computer
]]--

local git = require("update")
local programs = git.programLinks

local auth = {["users"]={"Jesse"},
              ["passwords"]={"vaikeasalasana1234"}}
local loggedIn = true


local function checkUser(user)
    for key, value in ipairs(auth["users"]) do
        if value == user then
            return key
        end
    end
    return nil
end


local function checkPassword(pass, key)
    if auth["passwords"][key] == pass then
        return 1
    end
    return 0
end

local function authenticate()
    user = io.read()
    pass = io.read()
    key = checkUser(user)
    if key == nil then
        print("User not found.")
        return 0
    end
    if not checkPassword(pass, key) then
        print("Wrong password.")
        return 1
    end
end

--Add proximity log out to this.
local function serve()
    while loggedIn do
        if authenticate() then
            print("Logged in!")
            term.setCursorPos(1, 1)
            print("Serving programs...")
            loggedIn = false
        else
            do return end
        end
    end
    while true do
        
    end
end


serve()