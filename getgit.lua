local programLink = "https://raw.githubusercontent.com/JesseSme/luaAutoupdate/master/getgit.lua"

local response = http.get(programLink)

local update = fs.open("test", "w")

update.write(response)

update.close()

local testRead = fs.open("test", "r")

local content = testRead.readAll()

print(content)