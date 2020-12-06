local programLink = "https://raw.githubusercontent.com/JesseSme/luaAutoupdate/master/getgit.lua"

local response = http.get(programLink)

local test = fs.open("test", "w")

test.write(response)

local content = test.readAll()

print(content)