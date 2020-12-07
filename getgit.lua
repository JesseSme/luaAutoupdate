--Links for RAW github codes.
--turn program links to a table.
git = {}
git.programLinks = {
    ["update"]=       "https://raw.githubusercontent.com/JesseSme/luaAutoupdate/master/getgit.lua",
    ["digger"]=       "https://raw.githubusercontent.com/JesseSme/luaAutoupdate/master/digger.lua",
    ["inventory"]=    "https://raw.githubusercontent.com/JesseSme/luaAutoupdate/master/invmanip.lua",
    ["app"]=          "https://raw.githubusercontent.com/JesseSme/luaAutoupdate/master/app.lua",
    ["tunnel"]=       "https://raw.githubusercontent.com/JesseSme/luaAutoupdate/master/tunnel.lua"
}

function git.update()
    --Make a loop to create all the files
    for key, url in ipairs(programLinks) do
        print(key)
        print(url)
        local response = http.get(url)
        local file = fs.open(key, "w")
        file.write(response.readAll())
        file.close()
    end
    --end loop here
end

return git