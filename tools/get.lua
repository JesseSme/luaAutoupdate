local modem = peripheral.find("modem", rednet.open)

--math.randomseed(os.epoch)
local rnd1 = math.random(1, 1000)
local rnd2 = math.random(1, 1000)

rednet.host("proto"..rnd1, "host"..rnd2)

local tbl = {
    arg[1]..""
}

local servid = rednet.lookup("sendprogramprotocol")
if servid == nil then
    term.setTextColor(4)
    print("Updater not running")
    term.setTextColor(1)
    return 0
end
rednet.send(servid, tbl, "sendprogramprotocol")

id, message = rednet.receive(5)

for name, code in pairs(message) do
    local file = fs.open(name, "w")
    file.write(code)
    file.close()
end

rednet.close(modem)
