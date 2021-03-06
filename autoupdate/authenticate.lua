local auth = {}
local cred = {["users"]={"Jesse"},
              ["passwords"]={"gigamind420"}}

local function checkUser(user)
    for key, value in ipairs(cred["users"]) do
        if value == user then
            return key
        end
    end
    return nil
end


local function checkPassword(pass, key)
    if cred["passwords"][key] == pass then
        return 1
    end
    return 0
end

function auth.credenticate(user, pass)
    if user == nil then
        print("Username: ")
        user = io.read()
    end
    
    key = checkUser(user)
    if key == nil then
        print("User not found.")
        return 0
    end

    if pass == nil then
        print("Password: ")
        pass = io.read()
    end

    if checkPassword(pass, key) == 0 then
        print("Wrong password.")
        return 0
    end

    return 1
end

return auth