-- Pluggy init file
-- (c)copyright 2018 by Gerald Wodni <gerald.wodni@gmail.com>

-- reduce Baudrate to allow reliable file transfer
uart.setup(0,57600,8,0,1)
print("Pluggy Ready!")
