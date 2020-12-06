local programLink = "https://raw.githubusercontent.com/JesseSme/luaAutoupdate/master/getgit.lua"

local response = http.get(programLink)

local test = fs.open("test", "w")

test.write(response)

test.close()

local testRead = fs.open("test", "r")

local content = testRead.readAll()

print(content)