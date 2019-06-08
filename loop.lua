local os = require("os")
local component = require("component")
local sides = require("sides")
local robot = component.robot
local inv_cont = component.inventory_controller

local i = true

while i do
    robot.select(1)
    robot.use(sides.front)
    robot.select(2)
    os.sleep(24)
    robot.use(sides.front)
    robot.select(1)
    robot.transferTo(6, 1)
    robot.select(6)
    inv_cont.equip()
end
