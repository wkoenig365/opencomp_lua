local os = require("os")
local component = require("component")
local sides = require("sides")
local robot = component.robot
local inv_cont = component.inventory_controller

local b = true

io.write("Enter wait time in seconds: ")
time = io.read("*n")

while b do
    for i=1,27 do
        for ii=1,30 do
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
            if item_info.size == item_info.maxSize then
                robot.select(1)
                inv_cont.suckFromSlot(sides.front, i, item_info.maxSize)
                robot.turnAround()
            elseif item_info_next.name == "minecraft:stone" then
                robot.select(1)
                inv_cont.suckFromSlot(sides.front, i+1, item_info.maxSize)
                robot.turnAround()
            end
        else
            print("fuck")
        end
    end
end