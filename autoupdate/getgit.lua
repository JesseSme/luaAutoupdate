--Links for RAW github codes.
--turn program links to a table.
local git = {}
git.programLinks = {
    ["digger"]=       "https://raw.githubusercontent.com/JesseSme/luaAutoupdate/master/digger.lua",
    ["inventory"]=    "https://raw.githubusercontent.com/JesseSme/luaAutoupdate/master/invmanip.lua",
    ["app"]=          "https://raw.githubusercontent.com/JesseSme/luaAutoupdate/master/app.lua",
    ["tunnel"]=       "https://raw.githubusercontent.com/JesseSme/luaAutoupdate/master/tunnel.lua",
    ["update"]=       "https://raw.githubusercontent.com/JesseSme/luaAutoupdate/master/autoupdate/getgit.lua",
    ["updater"]=      "https://raw.githubusercontent.com/JesseSme/luaAutoupdate/master/autoupdate/updater.lua",
    ["auth"]=         "https://raw.githubusercontent.com/JesseSme/luaAutoupdate/master/autoupdate/authenticate.lua",
    ["cipherer"]=     "https://raw.githubusercontent.com/JesseSme/luaAutoupdate/master/autoupdate/cipherer.lua",
    ["locator"]=      "https://raw.githubusercontent.com/JesseSme/luaAutoupdate/master/bigbro/locator.lua",
    ["spyturtle"]=    "https://raw.githubusercontent.com/JesseSme/luaAutoupdate/master/bigbro/spyturtle.lua"
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
        for i=5, 1, -1 do
        print("Updater will rerun in... "..i)
        os.sleep(1)
        end
        shell.run("updater", "Jesse", "gigamind420")
    end
end

if shell.getRunningProgram() == "update" then
    git.update()
end

return git