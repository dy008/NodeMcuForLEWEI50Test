require("LeweiTcpClient")

LeweiTcpClient.init("02","dab6a862154c4ebfab05b845eb4b5652")

--{0x01,0x10,0x80,0x00,0x00,0x08,0xB2,0x02,0x1F,0x00,0x64,0xF4,0x0D,0xA8}
--{01 10 80 00 00 08 B2 02 1F 00 64 F4 0D A8}

function test(p1)
   print("switch01--"..p1)
   if (p1 == '0') then gpio.write(0, gpio.HIGH)
     else gpio.write(0, gpio.LOW) end
end

function test2(p1)
   print("switch02--"..p1)
end

LeweiTcpClient.addUserSwitch(test,"switch01",1)
LeweiTcpClient.addUserSwitch(test2,"switch02",1)

tmr.alarm(0, 30000, 1, function()
    --[[uart.alt(1)     --use alternate pins GPIO13 and GPIO15
    uart.setup(0, 9600, 8, 0, 1, 0)
    uart.write(0,0x01,0x10,0x01,0xEC)
    uart.on("data", 14,
        function(data)
        uart.alt(0)     --Don't use alternate pins GPIO13 and GPIO15
        print("recived--"..#data)
        v= (string.byte(data,8)*256+string.byte(data,9))/10
        print("battery="..v)
        LeweiTcpClient.appendSensorValue("BV",v)
        v= (string.byte(data,6)*256+string.byte(data,7))/10
        print("OutputV="..v)
        LeweiTcpClient.appendSensorValue("OV",v)   
        
        uart.on("data") -- unregister callback function
    end, 0)]]
        
    v = (adc.read(0)-512)*0.15
    print("batteryA="..v)
    LeweiTcpClient.sendSensorValue("BA",v)
    v=nil 
end)
