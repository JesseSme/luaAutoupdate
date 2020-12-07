local auth = {}

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

function auth.authenticate()
    print("Username: ")
    user = io.read()
    key = checkUser(user)
    if key == nil then
        print("User not found.")
        return 0
    end

    print("Password: ")
    pass = io.read()
    if checkPassword(pass, key) == 0 then
        print("Wrong password.")
        return 0
    end
    return 1
end

return auth