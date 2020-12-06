local programLink = "https://raw.githubusercontent.com/JesseSme/luaAutoupdate/master/getgit.lua"

local response = http.get(programLink)

local update = fs.open("update", "w")

update.write(response)

update.close()

local testRead = fs.open("update", "r")

local content = testRead.readAll()

print(content)