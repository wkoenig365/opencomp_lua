local os = require("os")
local component = require("component")
local sides = require("sides")
local robot = component.robot
local inv_cont = component.inventory_controller

local i = true

io.write("Enter wait time in seconds: ")
time = io.read("*n")

while i do
    robot.select(1)
    robot.use(sides.front)
    robot.select(2)
    os.sleep(tonumber(time))
    robot.use(sides.front)
    robot.select(1)
    robot.transferTo(6, 1)
    robot.select(6)
    inv_cont.equip()
end
