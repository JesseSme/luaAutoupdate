--Links for RAW github codes.
--turn program links to a table.
local git = {}
git.programLinks = {
    ["update"]=       "https://raw.githubusercontent.com/JesseSme/luaAutoupdate/master/getgit.lua",
    ["digger"]=       "https://raw.githubusercontent.com/JesseSme/luaAutoupdate/master/digger.lua",
    ["inventory"]=    "https://raw.githubusercontent.com/JesseSme/luaAutoupdate/master/invmanip.lua",
    ["app"]=          "https://raw.githubusercontent.com/JesseSme/luaAutoupdate/master/app.lua",
    ["tunnel"]=       "https://raw.githubusercontent.com/JesseSme/luaAutoupdate/master/tunnel.lua",
    ["updater"]=      "https://raw.githubusercontent.com/JesseSme/luaAutoupdate/master/updater.lua",
    ["auth"]=         "https://raw.githubusercontent.com/JesseSme/luaAutoupdate/master/authenticate.lua"
}

function git.update()
    for key, url in pairs(git.programLinks) do
        print("Updating: "..key)
        local response = http.get(url)
        local file = fs.open(key, "w")
        file.write(response.readAll())
        file.close()
        print(key.." Done!")
    end
    if shell.getRunningProgram() == "updater" then
        shell.run("updater", "Jesse", "gigamind420")
    end
end

if shell.getRunningProgram() == "update" then
    git.update()
end

return git