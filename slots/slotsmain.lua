--local slots_protocol = "slotsprotocol"
--local slots_host     = "slotshost_1"



--if not checkScriptVersion("slotsmain") then
--    rednet.unhost(slots_protocol)
--    peripheral.find("modem", rednet.close)
--    shell.run("get", "slots")
--    os.reboot()
--end

function start()
    local monitor = peripheral.find("monitor")
    term.redirect(monitor)
    paintutils.drawFilledBox(0,0,29,19,colors.magenta)
    --
end

start()