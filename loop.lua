local os = require("os")
local component = require("component")
local sides = require("sides")
local robot = require("robot")
local inv_cont = component.inventory_controller

local b = true

io.write("Enter wait time in seconds: ")
time = io.read("*n")

while b do
    for i=1,27 do
        for ii=1,65 do
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
        robot.turnAround()
        robot.select(2)
        slate_slot = 55 - i
        inv_cont.dropIntoSlot(sides.front, slate_slot)
        item_info = inv_cont.getStackInSlot(sides.front, i)
        item_info_next = inv_cont.getStackInSlot(sides.front, i+1)
        if item_info.name == "minecraft:stone" then
            robot.select(1)
            inv_cont.suckFromSlot(sides.front, i, item_info.maxSize)
            robot.turnAround()
        else
            print("fuck")
        end
    end
end