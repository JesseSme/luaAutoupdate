--Links for RAW github codes.
--turn program links to a table.
local git = {}
local url = "https://raw.githubusercontent.com/JesseSme/luaAutoupdate/master/"
git.programLinks = {
    ["digger"]=       url.."digger.lua",
    ["inventory"]=    url.."invmanip.lua",
    ["app"]=          url...."app.lua",
    ["tunnel"]=       url.."tunnel.lua",
    ["update"]=       url.."autoupdate/getgit.lua",
    ["updater"]=      url.."autoupdate/updater.lua",
    ["auth"]=         url.."autoupdate/authenticate.lua",
    ["locator"]=      url.."bigbro/locator.lua",
    ["spyturtle"]=    url.."bigbro/spyturtle.lua",
    ["cipherer"]=     url.."tools/cipherer.lua",
    ["serial"]=       url.."tools/serial.lua"
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