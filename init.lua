-- Copyright (c) 2016 dy008
-- https://github.com/dy008/NodeMcuForLEWEI50Test
--

gpio.write(0, gpio.HIGH)    --LED OFF
gpio.mode(0, gpio.OUTPUT)

print("Connecteing To wifi...")
enduser_setup.start(
  function()
    print("Connected to wifi as:" .. wifi.sta.getip())
    print("Let's Go...")
    dofile("run.lua")
  end,
  function(err, str)
    print("enduser_setup: Err #" .. err .. ": " .. str)
    node.restart()
  end
);


