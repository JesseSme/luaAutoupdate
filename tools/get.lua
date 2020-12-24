local modem = peripheral.find("modem")

math.randomseed(os.epoch)
local rnd1 = math.random(1, 1000)
local rnd2 = math.random(1, 1000)

rednet.open(modem)
rednet.host("proto"+rnd1, "host"+rnd2)

local tbl = {
    arg[1]..""
}

local servid = rednet.lookup("sendprogramprotocol")
rednet.send(servid, tbl, "sendprogramprotocol")

id, message = rednet.receive(5)

for name, code in pairs(message) do
    local file = fs.open(name, "w")
    file.write(code)
    file.close()
end

rednet.close(modem)
