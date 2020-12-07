--Links for RAW github codes.
--turn program links to a table.

local programLinks = {
    "update": "https://raw.githubusercontent.com/JesseSme/luaAutoupdate/master/getgit.lua",
    "digger": "https://raw.githubusercontent.com/JesseSme/luaAutoupdate/master/digger.lua"
}

--Make a loop to create all the files
for key, url in programLinks
local response = http.get(programLink)
local file = fs.open("update", "w")
file.write(response.readAll())
file.close()
--end loop here
