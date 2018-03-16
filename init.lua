-- Pluggy init file
-- (c)copyright 2018 by Gerald Wodni <gerald.wodni@gmail.com>

-- reduce Baudrate to allow reliable file transfer
uart.setup(0,57600,8,0,1)
print("Pluggy Ready!")

-- wait 10 seconds before starting webserver to allow emergency reflash
tmr.alarm(0, 10000, tmr.ALARM_SEMI, function()
    print("Webserver started")
    tmr.unregister(0)
    dofile("pluggy.lua")
    dofile("files.lua")
end)
