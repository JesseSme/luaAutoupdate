local qwait = {}

function qwait.wait()
    repeat
        local _, key = os.pullEvent("key")
    until key == keys.q
end

return qwait