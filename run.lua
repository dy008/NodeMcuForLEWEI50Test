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

local UartRecive = 0
tmr.alarm(0, 30000, tmr.ALARM_AUTO, function()
    uart.alt(1)     --use alternate pins GPIO13 and GPIO15
    uart.setup(0, 115200, 8, 0, 1, 0)
    uart.write(0,0x01,0x10,0x01,0xEC)    
    uart.on("data", 14,function(data)
        uart.alt(0)     --Don't use alternate pins GPIO13 and GPIO15
        print("recived--"..#data)
        v= (string.byte(data,8)*256+string.byte(data,9))/10
        print("battery="..v)
        LeweiTcpClient.appendSensorValue("BV",v)
        v= (string.byte(data,6)*256+string.byte(data,7))/10
        print("OutputV="..v)
        LeweiTcpClient.appendSensorValue("OV",v)   
        
        UartRecive = 1
        uart.on("data") -- unregister callback function
    end, 0)
    
    tmr.alarm(2, 1000, tmr.ALARM_SINGLE, function() 
        uart.alt(0)
        uart.on("data") -- unregister callback function
        if UartRecive ~= 0 then
            UartRecive = 0
            uart.alt(1)     --use alternate pins GPIO13 and GPIO15
            uart.write(0,0x59,0x0D)    
            uart.on("data", 8,function(data)
                uart.alt(0)     --Don't use alternate pins GPIO13 and GPIO15
                print("recived--"..#data)
                v= string.byte(data,5)*6/100
                uart.on("data") -- unregister callback function
                print("LOAD="..v)
                LeweiTcpClient.appendSensorValue("LA",v)
                
                local SCK = 5
                local SDA = 6
                local sht10 = require("SHT1x")
                local t2,h2 =sht10.read_th(SCK,SDA)
                -- release module
                sht10 = nil
                local v = (adc.read(0)-512)*0.15
                print("batteryA="..v)
                v =nil 
                LeweiTcpClient.appendSensorValue("T2",t2)
                print("SHT10 Temperature="..t2)
                LeweiTcpClient.sendSensorValue("H2",h2)
                print("SHT10 Humidity="..h2)
            end, 0)
        end
    end)
end)
