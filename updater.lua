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
            print(key)
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
    print("Username: ")
    user = io.read()
    key = checkUser(user)
    if key == nil then
        print("User not found.")
        return 0
    end¨

    print("Password: ")
    pass = io.read()
    if not checkPassword(pass, key) then
        print("Wrong password.")
        return 0
    end
    return 1
end

--Add proximity log out to this.
local function serve()
    while loggedIn do
        if authenticate() then
            term.setCursorPos(1, 1)
            term.clear()
            print("Logged in!")
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