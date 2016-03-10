-- Copyright (c) 2016 dy008
-- https://github.com/
--
print("Connecteing To wifi...")
enduser_setup.start(
  function()
    print("Connected to wifi as:" .. wifi.sta.getip())
  end,
  function(err, str)
    print("enduser_setup: Err #" .. err .. ": " .. str)
  end
);
gpio.write(0, gpio.HIGH)    --LED OFF
gpio.mode(0, gpio.OUTPUT)

